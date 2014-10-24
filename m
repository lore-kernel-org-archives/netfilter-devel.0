From: Thomas Backlund <tmb@mageia.org>
Subject: [PATCH v2] add missing ipset_parse_tcp_udp_port to libipset.map
Date: Fri, 24 Oct 2014 23:35:45 +0259
Message-ID: <544AB83A.4070707@mageia.org>
References: <544AA6FF.1000803@mageia.org> <alpine.LSU.2.11.1410242206380.16647@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060707060907050008080907"
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:47183 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733AbaJXUg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:36:26 -0400
In-Reply-To: <alpine.LSU.2.11.1410242206380.16647@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060707060907050008080907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



2014-10-24 23:07, Jan Engelhardt skrev:
> On Friday 2014-10-24 21:23, Thomas Backlund wrote:
>
>> Found this issue when we switched from 6.19 static build to 6.21 dynamic build,
>> and is still there in 6.23
>
> What has been released is immutable; after a release, only add
> symbols to new sections.
>

Ok, so I guess it should be added after the patch:

[PATCH] libipset: Bump lib version and update map file

posted today, so something like:


--------------060707060907050008080907
Content-Type: text/x-patch;
 name="ipset-6.23-add-missing-ipset_parse_tcp_udp_port-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="ipset-6.23-add-missing-ipset_parse_tcp_udp_port-v2.patch"


Commit: 

author	Quentin Armitage <quentin@armitage.org.uk>	2013-08-09 11:26:33 (GMT)
committer	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>	2013-08-17 19:31:29 (GMT)
commit	480761a3bdaa55bf8c966e4dab950ebf84775863 (patch)
tree	6d750f948abf1ae4f93e4c704502d085ac13d679
parent	3a4419954a3ae0ba5dafd711e6b8dd8f0beb5c21 (diff)
Add specifying protocol for bitmap:port
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

added ipset_parse_tcp_udp_port(), but forgot to update libipset.map

so we get:

# ipset list
/usr/lib64/ipset/ipset_bitmap_port.so: /usr/lib64/ipset/ipset_bitmap_port.so: undefined symbol: ipset_parse_tcp_udp_port

so update the map.

Signed-off-by: Thomas Backlund <tmb@mageia.org>

---
 lib/libipset.map |    1 +
 1 file changed, 1 insertion(+)

Note, this patch is added after the patch posted earlier today
(so we 're-use' the newly added LIBIPSET_4.4 and lib version bump
 as it's not released yet):

[PATCH] libipset: Bump lib version and update map file

The ipset_parse_uint16() was introduced but no lib version bumped and
no map file updated.

Bump lib version to 9:0:6. (current and age was bumped)

diff -Nurp ipset-6.23.orig/lib/libipset.map ipset-6.23/lib/libipset.map
--- ipset-6.23.orig/lib/libipset.map	2014-10-24 23:22:58.000000000 +0300
+++ ipset-6.23/lib/libipset.map	2014-10-24 23:25:24.239233671 +0300
@@ -155,5 +155,6 @@ global:
 
 LIBIPSET_4.4 {
 global:
+  ipset_parse_tcp_udp_port;
   ipset_parse_uint16;
 } LIBIPSET_4.3;

--------------060707060907050008080907--
