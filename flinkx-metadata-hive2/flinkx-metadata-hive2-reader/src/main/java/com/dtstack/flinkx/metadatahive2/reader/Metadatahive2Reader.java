/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.dtstack.flinkx.metadatahive2.reader;

import com.dtstack.flinkx.config.DataTransferConfig;
import com.dtstack.flinkx.config.ReaderConfig;
import com.dtstack.flinkx.metadata.inputformat.MetadataInputFormatBuilder;
import com.dtstack.flinkx.metadata.reader.MetadataReader;
import com.dtstack.flinkx.metadatahive2.inputformat.Metadatahive2InputFormat;
import com.dtstack.flinkx.metadatahive2.inputformat.Metadatehive2InputFormatBuilder;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

import static com.dtstack.flinkx.metadatahive2.constants.Hive2MetaDataCons.*;
import static com.dtstack.flinkx.metadatahive2.constants.Hive2Version.Source.SPARK_THRIFT_SERVER;
import static com.dtstack.flinkx.metadatahive2.constants.Hive2Version.Version.APACHE2;

/**
 * @author : tiezhu
 * @date : 2020/3/9
 */
public class Metadatahive2Reader extends MetadataReader {

    protected String source;
    protected String version;

    public Metadatahive2Reader(DataTransferConfig config, StreamExecutionEnvironment env) {
        super(config, env);
        ReaderConfig readerConfig = config.getJob().getContent().get(0).getReader();
        source = readerConfig.getParameter().getStringVal(KEY_SOURCE, SPARK_THRIFT_SERVER.getType());
        version = readerConfig.getParameter().getStringVal(KEY_VERSION, APACHE2.getType());
        driverName = DRIVER_NAME;
    }

    @Override
    protected MetadataInputFormatBuilder getBuilder(){
        Metadatehive2InputFormatBuilder Builder = new Metadatehive2InputFormatBuilder(new Metadatahive2InputFormat());
        Builder.setHive2Server(version, source);
        return Builder;
    }
}