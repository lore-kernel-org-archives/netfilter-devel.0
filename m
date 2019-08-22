Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,WEIRD_QUOTING
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCB3C3A59D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 04:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 213C42145D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 04:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vU5GIj5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfHVEMK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:12:10 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:34209 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfHVEMK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 00:12:10 -0400
Received: by mail-pg1-f176.google.com with SMTP id n9so2703579pgc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 21:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f+L2yQhvHzRm4KU+vG/oarFAdaItsUIF6el6fr/eHfA=;
        b=vU5GIj5s8lN28uUqKkaE2dUzCinKWXkJ616//uSNoGbWwhRymlEf3tMYgb4qacFKgc
         +LfQEhSX5frPr3NXWa7LWdSAGhjHzl44ncAA9HeWeRVSNPElCFpsBA382MWKVHETq0bI
         JxDNG3nwWy9FAc4pJe8ao6JG9rJm0GTdE2llypVvGP3MSgsPYvs8p7HewPjpSSVwvZWl
         iVB8nCcVVUPT3Z+Q5LvTGgT5cLah+wsCQVfFY3gbBTMYSKLtncqjd41cdxl5Q4CTVWfj
         LKSTExTwwi0zqbO3YV4EomNt/cKLEtrZNJauRGsjlHFI/8zBcMpwsIoyTF3cYHj47pgM
         CL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f+L2yQhvHzRm4KU+vG/oarFAdaItsUIF6el6fr/eHfA=;
        b=Yac4jjf9pYYNlVAZsdLHf0qoBWgJ/w6QcPtemssjh0cIGVskHBjNeiu8/D7CoHPPO4
         aphBEsDiPZXibigJyaxFtSanResV7KJnX6vGBTFcyYj+0rD8De1lSuU9iV4qjp7ca4Wk
         dr2XW1baaTFgte5TPOXyZq3ECDKwPUIyuqc+kcpZwopgvhYsmy1SztQtYc2zjAQEnLwl
         kF9DKUAJOc2xbH96jWxtwCWICfB2qR4diwP5plUwOXNI21CiPuNH4T+KxV1fRcWM16ez
         KHLQvNdUB8nwgLeqxHSPFtMadIRqrc3FnOFk2mhPn2PASIf+MThB5FK7GtzryD6z3Ow4
         t8TA==
X-Gm-Message-State: APjAAAVjwFsOTvKvydXtM2blEOM/8vmRds3K+vmKlbquA/LYRCDr4dMq
        /UBzJj/VbJNtEPDWmW5kFsqziqiL9Ts=
X-Google-Smtp-Source: APXvYqzIy81aUYbZXXjYbXV2/pDWGk63Ke/zKVGGwIAW3D0AEjnQd/CnJsTplle0/c4YEvBa3332bw==
X-Received: by 2002:a63:2c8:: with SMTP id 191mr31386518pgc.139.1566447129031;
        Wed, 21 Aug 2019 21:12:09 -0700 (PDT)
Received: from localhost.localdomain ([2409:4043:a:9fc7:918f:4214:52e2:f8ea])
        by smtp.gmail.com with ESMTPSA id o35sm21789343pgm.29.2019.08.21.21.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 21:12:08 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v1]files: add script to generate geoip.nft file
Date:   Thu, 22 Aug 2019 09:41:53 +0530
Message-Id: <20190822041153.4680-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a python script to download MaxMind's GeoLite2
database and generate a file named geoip.nft, which users can 'include'.

The nft_geoip.py file has three options:
 --download            : to download and unzip the database folder from MaxMind.
 --file-location       : to specify the .csv file containing the country names and geoname ids.
 --file-ipv4           : to specify the .csv file containing information about IPv4 blocks.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version history of the patch is:
v1: add the script nft_geoip.py 
---
 files/nft_geoip.py | 181 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100644 files/nft_geoip.py

diff --git a/files/nft_geoip.py b/files/nft_geoip.py
new file mode 100644
index 00000000..52b65ff9
--- /dev/null
+++ b/files/nft_geoip.py
@@ -0,0 +1,181 @@
+#!/usr/bin/env python3
+#
+# (C) 2019 by Shekhar Sharma <shekhar250198@gmail.com>
+
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+"""Download and unzip GeoLite2 database from MaxMind database and Generate geoip.nft file by parsing CSVs."""
+import argparse
+from collections import namedtuple
+import csv
+import unicodedata
+from zipfile import ZipFile
+import urllib.request
+import os
+import sys
+
+
+GeoEntry = namedtuple('GeoEntry', 'geoname_id, '
+                      'continent_code, '
+                      'locale_code, '
+                      'continent_name, '
+                      'country_iso_code, '
+                      'country_name, '
+                      'is_in_european_union')
+
+# then mapping for network address to geoname_id
+NetworkEntry = namedtuple('NetworkEntry',
+                          'network, '
+                          'geoname_id, '
+                          'registered_country_geoname_id,'
+                          'represented_country_geoname_id,'
+                          'is_anonymous_proxy,'
+                          'is_satellite_provider')
+
+
+def strip_accent(text):
+    """Remove accented characters. Convert to ASCII."""
+    return ''.join(char for char in unicodedata.normalize('NFKD', text) \
+                   if unicodedata.category(char) != 'Mn')
+
+
+def make_country_and_continent_dict():
+    """Read the locations file and make dicts."""
+    country_dict = {}
+    continent_dict = {}
+    flag = 0
+    for geo_entry in map(GeoEntry._make, csv.reader(ARGS.LOCATIONS)):
+        if flag == 0:
+            flag = 1
+        else:
+            country_dict[geo_entry.geoname_id] = geo_entry.country_name
+            continent_dict[geo_entry.country_name] = geo_entry.continent_name
+    return correct_dictionary(country_dict), correct_dictionary(continent_dict)
+
+
+def correct_dictionary(dictionary):
+    """Given a dict, strip accents from it, and replace special characters."""
+    new_dict = {}
+    for key, value in dictionary.items():
+        if key != '' and value != '':
+            new_key = strip_accent(key).lower()
+            new_key = new_key.replace(" ", "_").replace("[", "").replace("]", "").replace(",","")
+            new_value = strip_accent(value).lower()
+            new_value = new_value.replace(" ", "_").replace("[", "").replace("]", "").replace(",","")
+            new_dict[new_key] = new_value
+    return new_dict
+
+
+def write_geoids(country_dict):
+    """Write geoids to output file."""
+    with open('geoip.nft', 'w') as output_file:
+        for row, country in country_dict.items():
+            output_file.write('define {} = {}\n'.format(country,row))
+        output_file.write('\n' * 3)
+
+
+def make_geoip_dict(country_dict):
+    """Use country_dict to make geoip_dict."""
+    geoip_dict = {}
+    for net_entry in map(NetworkEntry._make, csv.reader(ARGS.BLOCKS)):
+        try:
+            geoip_dict[net_entry.network] = country_dict[net_entry.geoname_id]
+        except KeyError:
+            pass
+    return correct_dictionary(geoip_dict)
+
+
+def make_lines1(dictionary):
+    """Given dict, make lines to write into output file."""
+    return ['{} : ${}'.format(row,value) for row, value in dictionary.items()]
+
+
+def make_lines2(dictionary):
+    """Given dict, make lines to write into output file."""
+    return ['${} : ${}'.format(row,value) for row, value in dictionary.items()]
+
+
+def write_continent_info(geoip_dict, continent_dict):
+    """Write to output file."""
+    with open("geoip.nft", "a+") as output_file:
+        output_file.write('map geoname_id {\n'
+                          '\ttype ipv4_addr : mark\n'
+                          '\tflags interval\n'
+                          '\telements = {\n\t\t')
+
+        output_file.write(',\n\t\t'.join(make_lines1(geoip_dict)))
+        output_file.write('\n')
+        output_file.write('\t}\n')
+        output_file.write('\t}')
+        output_file.write('\n'*3)
+        output_file.write('define africa = 1\n'
+                          'define asia = 2\n'
+                          'define europe = 3\n'
+                          'define north_america = 4\n'
+                          'define south_america = 5\n'
+                          'define oceania = 6\n'
+                          'define antarctic = 7\n')
+        output_file.write('\n' * 3)
+
+        output_file.write('map continent_code {\n'
+                          '\ttype mark : mark\n'
+                          '\tflags interval\n'
+                          '\telements = {\n\t\t')
+
+        output_file.write(',\n\t\t'.join(make_lines2(continent_dict)))
+        output_file.write('\n')
+        output_file.write('\t}\n')
+        output_file.write('\t}')
+        output_file.write('\n' * 3)
+
+if __name__ == '__main__':
+    # Parse input file names
+    PARSER = argparse.ArgumentParser(description='Create geoip.nft file by parsing CSVs.')
+    PARSER.add_argument('--file-location',
+                        type=argparse.FileType('r'),
+                        help='a csv file containing the locations of countries with geoname ids.',
+                        required=False,
+                        dest='LOCATIONS')
+    PARSER.add_argument('--file-ipv4',
+                        type=argparse.FileType('r'),
+                        help='a csv file containing the ipv4 blocks for countries.',
+                        required=False,
+                        dest='BLOCKS')
+
+    PARSER.add_argument('--download',action='store_true',
+                        help='download the folder containing data in CSV format.',
+                        dest='DOWNLOAD')
+
+
+    ARGS = PARSER.parse_args()
+
+    if ARGS.DOWNLOAD:
+        print('Downloading GeoIP CSV files,\nPlease wait, this may take a moment.\n')
+        url ='http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip'
+        urllib.request.urlretrieve(url,'csvdata.zip')
+        file='csvdata.zip'
+        with ZipFile(file,'r') as zip:
+            zip.extractall()
+        os.remove(file)
+        sys.exit("Done")
+
+    if not ARGS.DOWNLOAD:
+        if not (ARGS.BLOCKS or ARGS.LOCATIONS):
+            PARSER.print_help()
+            sys.exit("You must specify the files where data is located or download the data folder using --download option")
+        if not ARGS.BLOCKS:
+            PARSER.print_help()
+            sys.exit("You must specify the file where IPv4 data is located")
+        if not ARGS.LOCATIONS:
+            PARSER.print_help()
+            sys.exit("You must specify the file where country location data is located")		
+
+    print('Creating geoip.nft\n')
+    COUNTRY_DICT, CONTINENT_DICT = make_country_and_continent_dict()
+    write_geoids(COUNTRY_DICT)
+    GEOIP_DICT = make_geoip_dict(COUNTRY_DICT)
+    write_continent_info(GEOIP_DICT, CONTINENT_DICT)
+    print('Done')
-- 
2.17.1

