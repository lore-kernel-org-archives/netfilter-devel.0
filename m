From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] json: remove the rule flags in ruleset file
Date: Mon, 11 Nov 2013 21:09:21 +0100
Message-ID: <20131111200921.19419.32343.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58880 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3KKUJp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:09:45 -0500
Received: by mail-wi0-f176.google.com with SMTP id m19so2710312wiv.9
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2013 12:09:44 -0800 (PST)
Received: from [127.0.1.1] ([89.234.147.219])
        by mx.google.com with ESMTPSA id fr4sm37403842wib.0.2013.11.11.12.09.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2013 12:09:43 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch fix the unconsistence of this file with the
commit 2cba09966c77e946f6f32e860a368a0c5a9830a0

rule: remove NFT_RULE_ATTR_FLAGS

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/jsonfiles/64-ruleset.json |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-rules=
et.json
index a1baec8..533d7fa 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1,2 +1,2 @@
-{"nftables":[{"table":{"name":"filter","family":"ip","flags":0}},{"tab=
le":{"name":"filter2","family":"ip6","flags":0}},{"chain":{"name":"inpu=
t","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"f=
ilter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"acc=
ept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"fam=
ily":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward",=
"prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"byte=
s":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type=
":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"n=
ame":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"f=
ilter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"fami=
ly":"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"fi=
lter","chain":"output","handle":6,"flags":0,"expr":[{"type":"payload","=
dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":=
"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"=
}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,=
"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"=
rule":{"family":"ip","table":"filter","chain":"output","handle":9,"flag=
s":0,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link=
"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"valu=
e","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":=
2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"d=
ata_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"count=
er","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","cha=
in":"output","handle":10,"flags":0,"expr":[{"type":"payload","dreg":1,"=
offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmp=
data":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"typ=
e":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"fil=
ter","chain":"output","handle":11,"flags":0,"expr":[{"type":"payload","=
dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":=
"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"=
}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,=
"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"table":{"name":"filter","family":"ip","flags":0}},{"tab=
le":{"name":"filter2","family":"ip6","flags":0}},{"chain":{"name":"inpu=
t","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"f=
ilter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"acc=
ept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"fam=
ily":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward",=
"prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"byte=
s":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type=
":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"n=
ame":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"f=
ilter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"fami=
ly":"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"fi=
lter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"o=
ffset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpd=
ata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type=
":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediate=
data":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"fa=
mily":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type"=
:"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sr=
eg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"=
0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"li=
nk"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"va=
lue","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes"=
:0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle=
":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"lin=
k"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"val=
ue","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":=
0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle"=
:11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link=
"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"valu=
e","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0=
},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"ver=
dict","verdict":"drop"}}}]}}]}
=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
