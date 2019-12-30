Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,WEIRD_QUOTING
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BFFC2D0C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 21:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF26206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 21:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="GhWz9Cy+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfL3VTh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 16:19:37 -0500
Received: from mx1.riseup.net ([198.252.153.129]:48794 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfL3VTh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 16:19:37 -0500
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 47mr0l4TtMzDsP2
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 13:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1577740775; bh=xKFRxbIR0QzhXy2M3KBp848oVRtsURq52rYxGF70yaE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GhWz9Cy+ejSgOc2JrKshDEiNFpxkOUDqQmDBsQcFqXkZZlnHLiDQ4vj/Pbj5dFbk4
         XsuP8fRGeLNBht3epSYhA6igxhBX3aFHKgrEDqc4pOjoGTjwVkRMMh0+12AcdqhKYj
         mYxcHPmKCjAle75AV4K0YlEsvW3UEdnZRrYiZfSQ=
X-Riseup-User-ID: 189E14722B9200881EC35691B7AC8C9F52C67903C1D06115D878E4419374AA38
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 47mr0k4gRWzJr1q
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 13:19:34 -0800 (PST)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables geoip 1/1] contrib: geoip: add geoip python script
Date:   Mon, 30 Dec 2019 22:19:03 +0100
Message-Id: <fa52a4d0fbbd993e46fd87049e4983232e0857bd.1577738918.git.guigom@riseup.net>
In-Reply-To: <cover.1577738918.git.guigom@riseup.net>
References: <cover.1577738918.git.guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a python script which generates .nft files that
contains mappings between the IP address and the geolocation.

It requires two csv files:

1) location database, its stored in the location.csv file shipped with
   the script. This is currently a modified version of

https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv

   You can specift the location database via the --file-location option.

2) geoip database. You can specify the file through --file-address, or use
   --download to fetch the one provided by db-ip.com. (needed if using
   the script for the first time)

Output files:

	geoip-def-*.nft: contains definitions for countries of a continent to its
	2-digit iso-3166 code

	geoip-ipv{4,6}.nft: contains maps for ip blocks mapped to the 2-digit
	iso-3166 value of the country.

Output directory can be specified with '-o' option. It must be an
existing directory.

Example, a counter of input packets from Spanish addresses, (there is a
folder named "test-geoip" in our current directory):

./nft_geoip.py -o test-geoip/ --file-location location.csv --download

table filter {
	include "./geoip-def-all.nft"
	include "./geoip-ipv4.nft"
	include "./geoip-ipv6.nft"

	chain input {
                type filter hook input priority filter; policy accept;
                meta mark set ip saddr map @geoip4
                meta mark $ES counter
        }

}

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 contrib/geoip/location.csv | 251 ++++++++++++++++++++++++++++++
 contrib/geoip/nft_geoip.py | 310 +++++++++++++++++++++++++++++++++++++
 2 files changed, 561 insertions(+)
 create mode 100644 contrib/geoip/location.csv
 create mode 100755 contrib/geoip/nft_geoip.py

diff --git a/contrib/geoip/location.csv b/contrib/geoip/location.csv
new file mode 100644
index 00000000..8fe41d7b
--- /dev/null
+++ b/contrib/geoip/location.csv
@@ -0,0 +1,251 @@
+# Modified version of github.com/lukes/ISO-3166-Countries-with-Regional-Codes all.csv licensed under CC-BY-SA 4.0
+name,alpha-2,alpha-3,country-code,iso_3166-2,region,sub-region,intermediate-region,region-code,sub-region-code,intermediate-region-code
+Afghanistan,AF,AFG,004,ISO 3166-2:AF,Asia,Southern Asia,"",142,034,""
+Åland Islands,AX,ALA,248,ISO 3166-2:AX,Europe,Northern Europe,"",150,154,""
+Albania,AL,ALB,008,ISO 3166-2:AL,Europe,Southern Europe,"",150,039,""
+Algeria,DZ,DZA,012,ISO 3166-2:DZ,Africa,Northern Africa,"",002,015,""
+American Samoa,AS,ASM,016,ISO 3166-2:AS,Oceania,Polynesia,"",009,061,""
+Andorra,AD,AND,020,ISO 3166-2:AD,Europe,Southern Europe,"",150,039,""
+Angola,AO,AGO,024,ISO 3166-2:AO,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Anguilla,AI,AIA,660,ISO 3166-2:AI,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Antarctica,AQ,ATA,010,ISO 3166-2:AQ,"Antarctica","","","","",""
+Antigua and Barbuda,AG,ATG,028,ISO 3166-2:AG,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Argentina,AR,ARG,032,ISO 3166-2:AR,Americas,Latin America and the Caribbean,South America,019,419,005
+Armenia,AM,ARM,051,ISO 3166-2:AM,Asia,Western Asia,"",142,145,""
+Aruba,AW,ABW,533,ISO 3166-2:AW,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Australia,AU,AUS,036,ISO 3166-2:AU,Oceania,Australia and New Zealand,"",009,053,""
+Austria,AT,AUT,040,ISO 3166-2:AT,Europe,Western Europe,"",150,155,""
+Azerbaijan,AZ,AZE,031,ISO 3166-2:AZ,Asia,Western Asia,"",142,145,""
+Bahamas,BS,BHS,044,ISO 3166-2:BS,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Bahrain,BH,BHR,048,ISO 3166-2:BH,Asia,Western Asia,"",142,145,""
+Bangladesh,BD,BGD,050,ISO 3166-2:BD,Asia,Southern Asia,"",142,034,""
+Barbados,BB,BRB,052,ISO 3166-2:BB,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Belarus,BY,BLR,112,ISO 3166-2:BY,Europe,Eastern Europe,"",150,151,""
+Belgium,BE,BEL,056,ISO 3166-2:BE,Europe,Western Europe,"",150,155,""
+Belize,BZ,BLZ,084,ISO 3166-2:BZ,Americas,Latin America and the Caribbean,Central America,019,419,013
+Benin,BJ,BEN,204,ISO 3166-2:BJ,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Bermuda,BM,BMU,060,ISO 3166-2:BM,Americas,Northern America,"",019,021,""
+Bhutan,BT,BTN,064,ISO 3166-2:BT,Asia,Southern Asia,"",142,034,""
+Bolivia,BO,BOL,068,ISO 3166-2:BO,Americas,Latin America and the Caribbean,South America,019,419,005
+"Bonaire, Sint Eustatius and Saba",BQ,BES,535,ISO 3166-2:BQ,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Bosnia and Herzegovina,BA,BIH,070,ISO 3166-2:BA,Europe,Southern Europe,"",150,039,""
+Botswana,BW,BWA,072,ISO 3166-2:BW,Africa,Sub-Saharan Africa,Southern Africa,002,202,018
+Bouvet Island,BV,BVT,074,ISO 3166-2:BV,Americas,Latin America and the Caribbean,South America,019,419,005
+Brazil,BR,BRA,076,ISO 3166-2:BR,Americas,Latin America and the Caribbean,South America,019,419,005
+British Indian Ocean Territory,IO,IOT,086,ISO 3166-2:IO,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Brunei Darussalam,BN,BRN,096,ISO 3166-2:BN,Asia,South-eastern Asia,"",142,035,""
+Bulgaria,BG,BGR,100,ISO 3166-2:BG,Europe,Eastern Europe,"",150,151,""
+Burkina Faso,BF,BFA,854,ISO 3166-2:BF,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Burundi,BI,BDI,108,ISO 3166-2:BI,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Cabo Verde,CV,CPV,132,ISO 3166-2:CV,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Cambodia,KH,KHM,116,ISO 3166-2:KH,Asia,South-eastern Asia,"",142,035,""
+Cameroon,CM,CMR,120,ISO 3166-2:CM,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Canada,CA,CAN,124,ISO 3166-2:CA,Americas,Northern America,"",019,021,""
+Cayman Islands,KY,CYM,136,ISO 3166-2:KY,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Central African Republic,CF,CAF,140,ISO 3166-2:CF,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Chad,TD,TCD,148,ISO 3166-2:TD,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Chile,CL,CHL,152,ISO 3166-2:CL,Americas,Latin America and the Caribbean,South America,019,419,005
+China,CN,CHN,156,ISO 3166-2:CN,Asia,Eastern Asia,"",142,030,""
+Christmas Island,CX,CXR,162,ISO 3166-2:CX,Oceania,Australia and New Zealand,"",009,053,""
+Cocos Keeling Islands,CC,CCK,166,ISO 3166-2:CC,Oceania,Australia and New Zealand,"",009,053,""
+Colombia,CO,COL,170,ISO 3166-2:CO,Americas,Latin America and the Caribbean,South America,019,419,005
+Comoros,KM,COM,174,ISO 3166-2:KM,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Congo,CG,COG,178,ISO 3166-2:CG,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Democratic Republic of the Congo,CD,COD,180,ISO 3166-2:CD,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Cook Islands,CK,COK,184,ISO 3166-2:CK,Oceania,Polynesia,"",009,061,""
+Costa Rica,CR,CRI,188,ISO 3166-2:CR,Americas,Latin America and the Caribbean,Central America,019,419,013
+Ivory Coast,CI,CIV,384,ISO 3166-2:CI,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Croatia,HR,HRV,191,ISO 3166-2:HR,Europe,Southern Europe,"",150,039,""
+Cuba,CU,CUB,192,ISO 3166-2:CU,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Curaçao,CW,CUW,531,ISO 3166-2:CW,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Cyprus,CY,CYP,196,ISO 3166-2:CY,Asia,Western Asia,"",142,145,""
+Czechia,CZ,CZE,203,ISO 3166-2:CZ,Europe,Eastern Europe,"",150,151,""
+Denmark,DK,DNK,208,ISO 3166-2:DK,Europe,Northern Europe,"",150,154,""
+Djibouti,DJ,DJI,262,ISO 3166-2:DJ,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Dominica,DM,DMA,212,ISO 3166-2:DM,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Dominican Republic,DO,DOM,214,ISO 3166-2:DO,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Ecuador,EC,ECU,218,ISO 3166-2:EC,Americas,Latin America and the Caribbean,South America,019,419,005
+Egypt,EG,EGY,818,ISO 3166-2:EG,Africa,Northern Africa,"",002,015,""
+El Salvador,SV,SLV,222,ISO 3166-2:SV,Americas,Latin America and the Caribbean,Central America,019,419,013
+Equatorial Guinea,GQ,GNQ,226,ISO 3166-2:GQ,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Eritrea,ER,ERI,232,ISO 3166-2:ER,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Estonia,EE,EST,233,ISO 3166-2:EE,Europe,Northern Europe,"",150,154,""
+Eswatini,SZ,SWZ,748,ISO 3166-2:SZ,Africa,Sub-Saharan Africa,Southern Africa,002,202,018
+Ethiopia,ET,ETH,231,ISO 3166-2:ET,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Falkland Islands,FK,FLK,238,ISO 3166-2:FK,Americas,Latin America and the Caribbean,South America,019,419,005
+Faroe Islands,FO,FRO,234,ISO 3166-2:FO,Europe,Northern Europe,"",150,154,""
+Fiji,FJ,FJI,242,ISO 3166-2:FJ,Oceania,Melanesia,"",009,054,""
+Finland,FI,FIN,246,ISO 3166-2:FI,Europe,Northern Europe,"",150,154,""
+France,FR,FRA,250,ISO 3166-2:FR,Europe,Western Europe,"",150,155,""
+French Guiana,GF,GUF,254,ISO 3166-2:GF,Americas,Latin America and the Caribbean,South America,019,419,005
+French Polynesia,PF,PYF,258,ISO 3166-2:PF,Oceania,Polynesia,"",009,061,""
+French Southern Territories,TF,ATF,260,ISO 3166-2:TF,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Gabon,GA,GAB,266,ISO 3166-2:GA,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Gambia,GM,GMB,270,ISO 3166-2:GM,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Georgia,GE,GEO,268,ISO 3166-2:GE,Asia,Western Asia,"",142,145,""
+Germany,DE,DEU,276,ISO 3166-2:DE,Europe,Western Europe,"",150,155,""
+Ghana,GH,GHA,288,ISO 3166-2:GH,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Gibraltar,GI,GIB,292,ISO 3166-2:GI,Europe,Southern Europe,"",150,039,""
+Greece,GR,GRC,300,ISO 3166-2:GR,Europe,Southern Europe,"",150,039,""
+Greenland,GL,GRL,304,ISO 3166-2:GL,Americas,Northern America,"",019,021,""
+Grenada,GD,GRD,308,ISO 3166-2:GD,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Guadeloupe,GP,GLP,312,ISO 3166-2:GP,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Guam,GU,GUM,316,ISO 3166-2:GU,Oceania,Micronesia,"",009,057,""
+Guatemala,GT,GTM,320,ISO 3166-2:GT,Americas,Latin America and the Caribbean,Central America,019,419,013
+Guernsey,GG,GGY,831,ISO 3166-2:GG,Europe,Northern Europe,Channel Islands,150,154,830
+Guinea,GN,GIN,324,ISO 3166-2:GN,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Guinea-Bissau,GW,GNB,624,ISO 3166-2:GW,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Guyana,GY,GUY,328,ISO 3166-2:GY,Americas,Latin America and the Caribbean,South America,019,419,005
+Haiti,HT,HTI,332,ISO 3166-2:HT,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Heard Island and McDonald Islands,HM,HMD,334,ISO 3166-2:HM,Oceania,Australia and New Zealand,"",009,053,""
+Holy See,VA,VAT,336,ISO 3166-2:VA,Europe,Southern Europe,"",150,039,""
+Honduras,HN,HND,340,ISO 3166-2:HN,Americas,Latin America and the Caribbean,Central America,019,419,013
+Hong Kong,HK,HKG,344,ISO 3166-2:HK,Asia,Eastern Asia,"",142,030,""
+Hungary,HU,HUN,348,ISO 3166-2:HU,Europe,Eastern Europe,"",150,151,""
+Iceland,IS,ISL,352,ISO 3166-2:IS,Europe,Northern Europe,"",150,154,""
+India,IN,IND,356,ISO 3166-2:IN,Asia,Southern Asia,"",142,034,""
+Indonesia,ID,IDN,360,ISO 3166-2:ID,Asia,South-eastern Asia,"",142,035,""
+Iran,IR,IRN,364,ISO 3166-2:IR,Asia,Southern Asia,"",142,034,""
+Iraq,IQ,IRQ,368,ISO 3166-2:IQ,Asia,Western Asia,"",142,145,""
+Ireland,IE,IRL,372,ISO 3166-2:IE,Europe,Northern Europe,"",150,154,""
+Isle of Man,IM,IMN,833,ISO 3166-2:IM,Europe,Northern Europe,"",150,154,""
+Israel,IL,ISR,376,ISO 3166-2:IL,Asia,Western Asia,"",142,145,""
+Italy,IT,ITA,380,ISO 3166-2:IT,Europe,Southern Europe,"",150,039,""
+Jamaica,JM,JAM,388,ISO 3166-2:JM,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Japan,JP,JPN,392,ISO 3166-2:JP,Asia,Eastern Asia,"",142,030,""
+Jersey,JE,JEY,832,ISO 3166-2:JE,Europe,Northern Europe,Channel Islands,150,154,830
+Jordan,JO,JOR,400,ISO 3166-2:JO,Asia,Western Asia,"",142,145,""
+Kazakhstan,KZ,KAZ,398,ISO 3166-2:KZ,Asia,Central Asia,"",142,143,""
+Kenya,KE,KEN,404,ISO 3166-2:KE,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Kiribati,KI,KIR,296,ISO 3166-2:KI,Oceania,Micronesia,"",009,057,""
+North Korea,KP,PRK,408,ISO 3166-2:KP,Asia,Eastern Asia,"",142,030,""
+South Korea,KR,KOR,410,ISO 3166-2:KR,Asia,Eastern Asia,"",142,030,""
+Kuwait,KW,KWT,414,ISO 3166-2:KW,Asia,Western Asia,"",142,145,""
+Kyrgyzstan,KG,KGZ,417,ISO 3166-2:KG,Asia,Central Asia,"",142,143,""
+Laos,LA,LAO,418,ISO 3166-2:LA,Asia,South-eastern Asia,"",142,035,""
+Latvia,LV,LVA,428,ISO 3166-2:LV,Europe,Northern Europe,"",150,154,""
+Lebanon,LB,LBN,422,ISO 3166-2:LB,Asia,Western Asia,"",142,145,""
+Lesotho,LS,LSO,426,ISO 3166-2:LS,Africa,Sub-Saharan Africa,Southern Africa,002,202,018
+Liberia,LR,LBR,430,ISO 3166-2:LR,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Libya,LY,LBY,434,ISO 3166-2:LY,Africa,Northern Africa,"",002,015,""
+Liechtenstein,LI,LIE,438,ISO 3166-2:LI,Europe,Western Europe,"",150,155,""
+Lithuania,LT,LTU,440,ISO 3166-2:LT,Europe,Northern Europe,"",150,154,""
+Luxembourg,LU,LUX,442,ISO 3166-2:LU,Europe,Western Europe,"",150,155,""
+Macao,MO,MAC,446,ISO 3166-2:MO,Asia,Eastern Asia,"",142,030,""
+Madagascar,MG,MDG,450,ISO 3166-2:MG,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Malawi,MW,MWI,454,ISO 3166-2:MW,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Malaysia,MY,MYS,458,ISO 3166-2:MY,Asia,South-eastern Asia,"",142,035,""
+Maldives,MV,MDV,462,ISO 3166-2:MV,Asia,Southern Asia,"",142,034,""
+Mali,ML,MLI,466,ISO 3166-2:ML,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Malta,MT,MLT,470,ISO 3166-2:MT,Europe,Southern Europe,"",150,039,""
+Marshall Islands,MH,MHL,584,ISO 3166-2:MH,Oceania,Micronesia,"",009,057,""
+Martinique,MQ,MTQ,474,ISO 3166-2:MQ,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Mauritania,MR,MRT,478,ISO 3166-2:MR,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Mauritius,MU,MUS,480,ISO 3166-2:MU,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Mayotte,YT,MYT,175,ISO 3166-2:YT,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Mexico,MX,MEX,484,ISO 3166-2:MX,Americas,Latin America and the Caribbean,Central America,019,419,013
+Federated States of Micronesia,FM,FSM,583,ISO 3166-2:FM,Oceania,Micronesia,"",009,057,""
+Republic of Moldova,MD,MDA,498,ISO 3166-2:MD,Europe,Eastern Europe,"",150,151,""
+Monaco,MC,MCO,492,ISO 3166-2:MC,Europe,Western Europe,"",150,155,""
+Mongolia,MN,MNG,496,ISO 3166-2:MN,Asia,Eastern Asia,"",142,030,""
+Montenegro,ME,MNE,499,ISO 3166-2:ME,Europe,Southern Europe,"",150,039,""
+Montserrat,MS,MSR,500,ISO 3166-2:MS,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Morocco,MA,MAR,504,ISO 3166-2:MA,Africa,Northern Africa,"",002,015,""
+Mozambique,MZ,MOZ,508,ISO 3166-2:MZ,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Myanmar,MM,MMR,104,ISO 3166-2:MM,Asia,South-eastern Asia,"",142,035,""
+Namibia,NA,NAM,516,ISO 3166-2:NA,Africa,Sub-Saharan Africa,Southern Africa,002,202,018
+Nauru,NR,NRU,520,ISO 3166-2:NR,Oceania,Micronesia,"",009,057,""
+Nepal,NP,NPL,524,ISO 3166-2:NP,Asia,Southern Asia,"",142,034,""
+Netherlands,NL,NLD,528,ISO 3166-2:NL,Europe,Western Europe,"",150,155,""
+New Caledonia,NC,NCL,540,ISO 3166-2:NC,Oceania,Melanesia,"",009,054,""
+New Zealand,NZ,NZL,554,ISO 3166-2:NZ,Oceania,Australia and New Zealand,"",009,053,""
+Nicaragua,NI,NIC,558,ISO 3166-2:NI,Americas,Latin America and the Caribbean,Central America,019,419,013
+Niger,NE,NER,562,ISO 3166-2:NE,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Nigeria,NG,NGA,566,ISO 3166-2:NG,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Niue,NU,NIU,570,ISO 3166-2:NU,Oceania,Polynesia,"",009,061,""
+Norfolk Island,NF,NFK,574,ISO 3166-2:NF,Oceania,Australia and New Zealand,"",009,053,""
+North Macedonia,MK,MKD,807,ISO 3166-2:MK,Europe,Southern Europe,"",150,039,""
+Northern Mariana Islands,MP,MNP,580,ISO 3166-2:MP,Oceania,Micronesia,"",009,057,""
+Norway,NO,NOR,578,ISO 3166-2:NO,Europe,Northern Europe,"",150,154,""
+Oman,OM,OMN,512,ISO 3166-2:OM,Asia,Western Asia,"",142,145,""
+Pakistan,PK,PAK,586,ISO 3166-2:PK,Asia,Southern Asia,"",142,034,""
+Palau,PW,PLW,585,ISO 3166-2:PW,Oceania,Micronesia,"",009,057,""
+Palestine,PS,PSE,275,ISO 3166-2:PS,Asia,Western Asia,"",142,145,""
+Panama,PA,PAN,591,ISO 3166-2:PA,Americas,Latin America and the Caribbean,Central America,019,419,013
+Papua New Guinea,PG,PNG,598,ISO 3166-2:PG,Oceania,Melanesia,"",009,054,""
+Paraguay,PY,PRY,600,ISO 3166-2:PY,Americas,Latin America and the Caribbean,South America,019,419,005
+Peru,PE,PER,604,ISO 3166-2:PE,Americas,Latin America and the Caribbean,South America,019,419,005
+Philippines,PH,PHL,608,ISO 3166-2:PH,Asia,South-eastern Asia,"",142,035,""
+Pitcairn,PN,PCN,612,ISO 3166-2:PN,Oceania,Polynesia,"",009,061,""
+Poland,PL,POL,616,ISO 3166-2:PL,Europe,Eastern Europe,"",150,151,""
+Portugal,PT,PRT,620,ISO 3166-2:PT,Europe,Southern Europe,"",150,039,""
+Puerto Rico,PR,PRI,630,ISO 3166-2:PR,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Qatar,QA,QAT,634,ISO 3166-2:QA,Asia,Western Asia,"",142,145,""
+Réunion,RE,REU,638,ISO 3166-2:RE,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Romania,RO,ROU,642,ISO 3166-2:RO,Europe,Eastern Europe,"",150,151,""
+Russian Federation,RU,RUS,643,ISO 3166-2:RU,Europe,Eastern Europe,"",150,151,""
+Rwanda,RW,RWA,646,ISO 3166-2:RW,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Saint Barthélemy,BL,BLM,652,ISO 3166-2:BL,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Saint Helena,SH,SHN,654,ISO 3166-2:SH,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Saint Kitts and Nevis,KN,KNA,659,ISO 3166-2:KN,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Saint Lucia,LC,LCA,662,ISO 3166-2:LC,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Saint Martin,MF,MAF,663,ISO 3166-2:MF,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Saint Pierre and Miquelon,PM,SPM,666,ISO 3166-2:PM,Americas,Northern America,"",019,021,""
+Saint Vincent and the Grenadines,VC,VCT,670,ISO 3166-2:VC,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Samoa,WS,WSM,882,ISO 3166-2:WS,Oceania,Polynesia,"",009,061,""
+San Marino,SM,SMR,674,ISO 3166-2:SM,Europe,Southern Europe,"",150,039,""
+Sao Tome and Principe,ST,STP,678,ISO 3166-2:ST,Africa,Sub-Saharan Africa,Middle Africa,002,202,017
+Saudi Arabia,SA,SAU,682,ISO 3166-2:SA,Asia,Western Asia,"",142,145,""
+Senegal,SN,SEN,686,ISO 3166-2:SN,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Serbia,RS,SRB,688,ISO 3166-2:RS,Europe,Southern Europe,"",150,039,""
+Seychelles,SC,SYC,690,ISO 3166-2:SC,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Sierra Leone,SL,SLE,694,ISO 3166-2:SL,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Singapore,SG,SGP,702,ISO 3166-2:SG,Asia,South-eastern Asia,"",142,035,""
+Sint Maarten,SX,SXM,534,ISO 3166-2:SX,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Slovakia,SK,SVK,703,ISO 3166-2:SK,Europe,Eastern Europe,"",150,151,""
+Slovenia,SI,SVN,705,ISO 3166-2:SI,Europe,Southern Europe,"",150,039,""
+Solomon Islands,SB,SLB,090,ISO 3166-2:SB,Oceania,Melanesia,"",009,054,""
+Somalia,SO,SOM,706,ISO 3166-2:SO,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+South Africa,ZA,ZAF,710,ISO 3166-2:ZA,Africa,Sub-Saharan Africa,Southern Africa,002,202,018
+South Georgia and the South Sandwich Islands,GS,SGS,239,ISO 3166-2:GS,Americas,Latin America and the Caribbean,South America,019,419,005
+South Sudan,SS,SSD,728,ISO 3166-2:SS,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Spain,ES,ESP,724,ISO 3166-2:ES,Europe,Southern Europe,"",150,039,""
+Sri Lanka,LK,LKA,144,ISO 3166-2:LK,Asia,Southern Asia,"",142,034,""
+Sudan,SD,SDN,729,ISO 3166-2:SD,Africa,Northern Africa,"",002,015,""
+Suriname,SR,SUR,740,ISO 3166-2:SR,Americas,Latin America and the Caribbean,South America,019,419,005
+Svalbard and Jan Mayen,SJ,SJM,744,ISO 3166-2:SJ,Europe,Northern Europe,"",150,154,""
+Sweden,SE,SWE,752,ISO 3166-2:SE,Europe,Northern Europe,"",150,154,""
+Switzerland,CH,CHE,756,ISO 3166-2:CH,Europe,Western Europe,"",150,155,""
+Syrian Arab Republic,SY,SYR,760,ISO 3166-2:SY,Asia,Western Asia,"",142,145,""
+Taiwan,TW,TWN,158,ISO 3166-2:TW,Asia,Eastern Asia,"",142,030,""
+Tajikistan,TJ,TJK,762,ISO 3166-2:TJ,Asia,Central Asia,"",142,143,""
+Tanzania,TZ,TZA,834,ISO 3166-2:TZ,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Thailand,TH,THA,764,ISO 3166-2:TH,Asia,South-eastern Asia,"",142,035,""
+Timor-Leste,TL,TLS,626,ISO 3166-2:TL,Asia,South-eastern Asia,"",142,035,""
+Togo,TG,TGO,768,ISO 3166-2:TG,Africa,Sub-Saharan Africa,Western Africa,002,202,011
+Tokelau,TK,TKL,772,ISO 3166-2:TK,Oceania,Polynesia,"",009,061,""
+Tonga,TO,TON,776,ISO 3166-2:TO,Oceania,Polynesia,"",009,061,""
+Trinidad and Tobago,TT,TTO,780,ISO 3166-2:TT,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Tunisia,TN,TUN,788,ISO 3166-2:TN,Africa,Northern Africa,"",002,015,""
+Turkey,TR,TUR,792,ISO 3166-2:TR,Asia,Western Asia,"",142,145,""
+Turkmenistan,TM,TKM,795,ISO 3166-2:TM,Asia,Central Asia,"",142,143,""
+Turks and Caicos Islands,TC,TCA,796,ISO 3166-2:TC,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Tuvalu,TV,TUV,798,ISO 3166-2:TV,Oceania,Polynesia,"",009,061,""
+Uganda,UG,UGA,800,ISO 3166-2:UG,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Ukraine,UA,UKR,804,ISO 3166-2:UA,Europe,Eastern Europe,"",150,151,""
+United Arab Emirates,AE,ARE,784,ISO 3166-2:AE,Asia,Western Asia,"",142,145,""
+United Kingdom,GB,GBR,826,ISO 3166-2:GB,Europe,Northern Europe,"",150,154,""
+United States of America,US,USA,840,ISO 3166-2:US,Americas,Northern America,"",019,021,""
+United States Minor Outlying Islands,UM,UMI,581,ISO 3166-2:UM,Oceania,Micronesia,"",009,057,""
+Uruguay,UY,URY,858,ISO 3166-2:UY,Americas,Latin America and the Caribbean,South America,019,419,005
+Uzbekistan,UZ,UZB,860,ISO 3166-2:UZ,Asia,Central Asia,"",142,143,""
+Vanuatu,VU,VUT,548,ISO 3166-2:VU,Oceania,Melanesia,"",009,054,""
+Venezuela,VE,VEN,862,ISO 3166-2:VE,Americas,Latin America and the Caribbean,South America,019,419,005
+Viet Nam,VN,VNM,704,ISO 3166-2:VN,Asia,South-eastern Asia,"",142,035,""
+Virgin Islands British,VG,VGB,092,ISO 3166-2:VG,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Virgin Islands US,VI,VIR,850,ISO 3166-2:VI,Americas,Latin America and the Caribbean,Caribbean,019,419,029
+Wallis and Futuna,WF,WLF,876,ISO 3166-2:WF,Oceania,Polynesia,"",009,061,""
+Western Sahara,EH,ESH,732,ISO 3166-2:EH,Africa,Northern Africa,"",002,015,""
+Yemen,YE,YEM,887,ISO 3166-2:YE,Asia,Western Asia,"",142,145,""
+Zambia,ZM,ZMB,894,ISO 3166-2:ZM,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
+Zimbabwe,ZW,ZWE,716,ISO 3166-2:ZW,Africa,Sub-Saharan Africa,Eastern Africa,002,202,014
diff --git a/contrib/geoip/nft_geoip.py b/contrib/geoip/nft_geoip.py
new file mode 100755
index 00000000..46091dea
--- /dev/null
+++ b/contrib/geoip/nft_geoip.py
@@ -0,0 +1,310 @@
+#!/usr/bin/env python3
+#
+# (C) 2019 by Jose M. Guisado <jmgg@riseup.net>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+from collections import namedtuple
+from datetime import datetime
+
+import argparse
+import csv
+import gzip
+import ipaddress
+import os
+import requests
+import shutil
+import sys
+import time
+import unicodedata
+
+
+# entries in location csv
+GeoEntry = namedtuple('GeoEntry',
+                      'name, '
+                      'alpha_2, '
+                      'alpha_3, '
+                      'country_code, '
+                      'iso_3166_2, '
+                      'region, '
+                      'sub_region, '
+                      'intermediate_region, '
+                      'region_code, '
+                      'sub_region_code, '
+                      'intermediate_region_code')
+
+# entries in DB-IP geoip csv
+NetworkEntry = namedtuple('NetworkEntry',
+                          'network_first, '
+                          'network_last, '
+                          'country_alpha_2')
+
+
+def strip_accent(text):
+    """
+    Remove accented characters. Convert to ASCII.
+    """
+    return ''.join(char for char in unicodedata.normalize('NFKD', text)
+                   if unicodedata.category(char) != 'Mn')
+
+
+def make_country_and_continent_dict():
+    """
+    Returns three formatted dictionaries with following key/value:
+        - iso_3166_2 (numeric)  :   country name
+        - country_name          :   continent/region name
+        - country_name          :   alpha2 name
+    """
+    country_dict = {}
+    continent_dict = {}
+    country_alpha_dict = {}
+    next(args.locations)  # Omit license notice
+    next(args.locations)  # Omit csv header
+    for geo_entry in map(GeoEntry._make, csv.reader(args.locations)):
+        country_dict[geo_entry.country_code.lstrip('0')] = geo_entry.name
+        continent_dict[geo_entry.name] = geo_entry.region
+        country_alpha_dict[geo_entry.name] = geo_entry.alpha_2
+    return format_dict(country_dict), \
+           format_dict(continent_dict), \
+           format_dict(country_alpha_dict)
+
+
+def format_dict(dictionary):
+    """
+    Strip accents and replace special characters for keys and values
+    inside a dictionary
+    """
+    new_dict = {}
+    for key, value in dictionary.items():
+        if key != '' and value != '':
+            new_key = strip_accent(key).lower()
+            new_key = new_key.replace(' ', '_').replace('[', '').replace(']', '').replace(',', '')
+            new_value = strip_accent(value).lower()
+            new_value = new_value.replace(' ', '_').replace('[', '').replace(']', '').replace(',','')
+            new_dict[new_key] = new_value
+        else:
+            sys.exit('BUG: There is an empty string as key or value inside a dictionary')
+
+    return new_dict
+
+
+def write_geoip_location(country_dict, continent_dict, country_alpha_dict):
+    """
+    Write country iso code definitions, separating files for each continent
+    (eg. geoip-def-asia.nft, etc.)
+    Also writes a definition file with all countries in "geoip-def-all.nft"
+    """
+    for continent in continent_dict.values():
+        with open(args.dir+'geoip-def-{}.nft'.format(continent), 'w') as output_file:
+            try:
+               for country, iso in [(country, iso)
+                                    for iso, country
+                                    in country_dict.items()
+                                    if continent_dict[country] == continent]:
+                    output_file.write('define {} = {}\n'.format(country_alpha_dict[country].upper(), iso))
+            except KeyError as e:
+                # 'ZZ' is used for an unknown country, so it won't match
+                # any country in the location file. Pass and do not write
+                # to output file
+                pass
+
+    with open(args.dir+'geoip-def-all.nft', 'w') as output_file:
+        for iso, country in country_dict.items():
+            output_file.write('define {} = {}\n'.format(country_alpha_dict[country].upper(), iso))
+        output_file.write('\n' * 2)
+
+        output_file.write('define africa = 1\n'
+                          'define asia = 2\n'
+                          'define europe = 3\n'
+                          'define americas = 4\n'
+                          'define oceania = 5\n'
+                          'define antarctica = 6\n')
+        output_file.write('\n')
+        output_file.write('map continent_code {\n'
+                          '\ttype mark : mark\n'
+                          '\tflags interval\n'
+                          '\telements = {\n\t\t')
+
+        output_file.write(',\n\t\t'.join(make_lines2({country_alpha_dict[country].upper():v
+                                                      for country, v
+                                                      in continent_dict.items()})))
+        output_file.write('\n')
+        output_file.write('\t}\n')
+        output_file.write('}\n')
+
+def check_ipv4(addr):
+    """
+    Returns true if a string is representing an ipv4 address.
+    False otherwise.
+    """
+    try:
+        ipaddress.IPv4Address(addr)
+        return True
+    except ipaddress.AddressValueError:
+        return False
+
+
+def make_geoip_dict(country_alpha_dict):
+    """
+    Read DB-IP network ranges and creates geoip4 and geoip6 dictionaries
+    mapping ip ranges over country alpha-2 codes
+    """
+    # XXX: country_alpha_dict is used to prune countries not appearing
+    #      inside location.csv (eg. Kosovo)
+    #
+    #      Kosovo could be added to location.csv with a "virtual" code
+    #      Kosovo,XK,XKX,999,ISO 3166-2:XK,Europe,"","","","",""
+    #
+    #      Or instead use geonames.
+    geoip4_dict = {}
+    geoip6_dict = {}
+
+    known_alphas = country_alpha_dict.values()
+
+    for net_entry in map(NetworkEntry._make, csv.reader(args.blocks)):
+
+        alpha2 = net_entry.country_alpha_2
+        # 'ZZ' or codes not appearing in location.csv will be ignored
+        if (alpha2 == 'ZZ') or (alpha2.lower() not in known_alphas):
+            continue
+
+        # There are entries in DB-IP csv for single addresses which
+        # are represented as same start and end address range.
+        # nftables does not accept same start/end address in ranges
+        if net_entry.network_first == net_entry.network_last:
+            k = net_entry.network_first
+        else:
+            k = '-'.join((net_entry.network_first, net_entry.network_last))
+
+        if check_ipv4(net_entry.network_first):
+            geoip4_dict[k] = alpha2
+        else:
+            geoip6_dict[k] = alpha2
+
+    return format_dict(geoip4_dict), format_dict(geoip6_dict)
+
+
+def make_lines1(dictionary):
+    """
+    For each entry in the dictionary maps to a line for nftables dict files
+    using key literal and value as nft variable.
+    """
+    return ['{} : ${}'.format(k, v) for k, v in dictionary.items()]
+
+
+def make_lines2(dictionary):
+    """
+    For each entry in the dictionary maps to a line for nftables dict files
+    using key and value as nft variables.
+    """
+    return ['${} : ${}'.format(k, v) for k, v in dictionary.items()]
+
+def write_nft_header(f):
+    """
+    Writes nft comments about generation date and db-ip copyright notice.
+    """
+    f.write("# Generated by nft_geoip.py on {}\n"
+            .format(datetime.now().strftime("%a %b %d %H:%M %Y")))
+    f.write("# IP Geolocation by DB-IP (https://db-ip.com) licensed under CC-BY-SA 4.0\n\n")
+
+def write_geoips(geoip4_dict, geoip6_dict):
+    """
+    Write ipv4 and ipv6 geoip nftables maps to corresponding output files.
+    """
+    with open(args.dir+'geoip-ipv4.nft', 'w') as output_file:
+        write_nft_header(output_file)
+        output_file.write('map geoip4 {\n'
+                          '\ttype ipv4_addr : mark\n'
+                          '\tflags interval\n'
+                          '\telements = {\n\t\t')
+
+        output_file.write(',\n\t\t'.join(make_lines1({k:v.upper() for k,v in geoip4_dict.items()})))
+        output_file.write('\n')
+        output_file.write('\t}\n')
+        output_file.write('}\n')
+
+    with open(args.dir+'geoip-ipv6.nft', 'w') as output_file:
+        write_nft_header(output_file)
+        output_file.write('map geoip6 {\n'
+                          '\ttype ipv6_addr : mark\n'
+                          '\tflags interval\n'
+                          '\telements = {\n\t\t')
+
+        output_file.write(',\n\t\t'.join(make_lines1({k:v.upper() for k,v in geoip6_dict.items()})))
+        output_file.write('\n')
+        output_file.write('\t}\n')
+        output_file.write('}\n')
+
+
+if __name__ == '__main__':
+    parser = argparse.ArgumentParser(description='Creates nftables geoip definitions and maps.')
+    parser.add_argument('--file-location',
+                        type=argparse.FileType('r'),
+                        help='path to csv file containing information about countries',
+                        required=True,
+                        dest='locations')
+    parser.add_argument('--file-address',
+                        type=argparse.FileType('r'),
+                        help='path to db-ip.com lite cvs file with ipv4 and ipv6 geoip information',
+                        required=False,
+                        dest='blocks')
+    parser.add_argument('-d', '--download', action='store_true',
+                        help='fetch geoip data from db-ip.com. This option overrides --file-address',
+                        required=False,
+                        dest='download')
+    parser.add_argument('-o', '--output-dir',
+                        help='Existing directory where downloads and output will be saved. \
+                              If not specified, working directory',
+                        required=False,
+                        dest='dir')
+    args = parser.parse_args()
+
+    if not args.dir:
+        args.dir = ''
+    elif not os.path.isdir(args.dir):
+        parser.print_help()
+        sys.exit('\nSpecified output directory does not exist or is not a directory')
+    else:
+        # Add trailing / for folder path if there isn't
+        args.dir += '/' if args.dir[-1:] != '/' else ''
+
+    if args.download:
+        filename = args.dir+'dbip.csv.gz'
+        url = 'https://download.db-ip.com/free/dbip-country-lite-{}.csv.gz'.format(time.strftime("%Y-%m"))
+        print('Downloading db-ip.com geoip csv file...')
+        r = requests.get(url, stream=True)
+        if r.status_code == 200:
+            with open(filename, 'wb') as f:
+                r.raw.decode_content = True
+                shutil.copyfileobj(r.raw, f)
+        else:
+            sys.exit('Error trying to download DB-IP lite geoip csv file. Bailing out...')
+
+        with gzip.open(filename, 'rb') as f_in:
+            with open(args.dir+'dbip.csv', 'wb') as f_out:
+                shutil.copyfileobj(f_in, f_out)
+                os.remove(filename)
+
+        # Update blocks arg with the downloaded file
+        args.blocks = open(args.dir+'dbip.csv', 'r', encoding='utf-8')
+
+    if not (args.blocks or args.locations):
+        parser.print_help()
+        sys.exit('Missing required address and location csv files.')
+    if not args.blocks:
+        parser.print_help()
+        sys.exit('Missing geoip address csv file. You can instead download it using --download.')
+    if not args.locations:
+        parser.print_help()
+        sys.exit('Missing country information csv file')
+
+    country_dict, continent_dict, country_alpha_dict = make_country_and_continent_dict()
+    print('Writing country definition files...')
+    write_geoip_location(country_dict, continent_dict, country_alpha_dict)
+    print('Writing nftables maps (geoip-ipv{4,6}.nft)...')
+    geoip4_dict, geoip6_dict = make_geoip_dict(country_alpha_dict)
+    write_geoips(geoip4_dict, geoip6_dict)
+    print('Done!')
-- 
2.23.0

