From: Thomas Backlund <tmb@mageia.org>
Subject: [PATCH] add missing ipset_parse_tcp_udp_port to libipset.map
Date: Fri, 24 Oct 2014 22:22:14 +0259
Message-ID: <544AA6FF.1000803@mageia.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030903000804070803070200"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:47035 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaJXTgk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:36:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030903000804070803070200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Found this issue when we switched from 6.19 static build to 6.21 dynamic 
build, and is still there in 6.23

--
Thomas

--------------030903000804070803070200
Content-Type: text/x-patch;
 name="ipset-6.23-add-missing-ipset_parse_tcp_udp_port.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="ipset-6.23-add-missing-ipset_parse_tcp_udp_port.patch"


Commit: 

author	Quentin Armitage <quentin@armitage.org.uk>	2013-08-09 11:26:33 (GMT)
committer	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>	2013-08-17 19:31:29 (GMT)
commit	480761a3bdaa55bf8c966e4dab950ebf84775863 (patch)
tree	6d750f948abf1ae4f93e4c704502d085ac13d679
parent	3a4419954a3ae0ba5dafd711e6b8dd8f0beb5c21 (diff)
Add specifying protocol for bitmap:port
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

added ipset_parse_tcp_udp_port, but forgot to update libipset.map

so we get:

# ipset list
/usr/lib64/ipset/ipset_bitmap_port.so: /usr/lib64/ipset/ipset_bitmap_port.so: undefined symbol: ipset_parse_tcp_udp_port

so update the map.

Signed-off-by: Thomas Backlund <tmb@mageia.org>


---
Note, this patch is against a build that also has the ipset_parse_uint16 added:
http://www.spinics.net/lists/netfilter-devel/msg33805.html

Since there is now 2 issues, what should be done for:
"bump API curr and age in Make_global.am and add a new section to libipset.map"

diff -Nurp ipset-6.23.old/lib/libipset.map ipset-6.23/lib/libipset.map
--- ipset-6.23.old/lib/libipset.map	2014-10-24 21:34:52.000000000 +0300
+++ ipset-6.23/lib/libipset.map	2014-10-24 21:45:46.502262622 +0300
@@ -149,6 +149,7 @@ LIBIPSET_4.3 {
 global:
   ipset_parse_skbmark;
   ipset_parse_skbprio;
+  ipset_parse_tcp_udp_port;
   ipset_parse_uint16;
   ipset_print_skbmark;
   ipset_print_skbprio;

--------------030903000804070803070200--
