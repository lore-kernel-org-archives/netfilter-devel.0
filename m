From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 02/09]: Fix minor memleaks on exit
Date: Fri, 18 Jan 2008 17:55:49 +0100 (MET)
Message-ID: <20080118165516.13385.89513.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762035AbYARQzu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:50 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f3982f36f684c2ef1174bf3d951c15d3e5a91f9a
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 16:16:07 2008 +0100

    [LIBNL]: Fix minor memleaks on exit
    
    Make valgrind happy ...
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/lib/route/route_utils.c b/lib/route/route_utils.c
index a12d169..1386cda 100644
--- a/lib/route/route_utils.c
+++ b/lib/route/route_utils.c
@@ -63,6 +63,11 @@ static void __init init_routing_table_names(void)
 	add_routing_table_name(RT_TABLE_LOCAL, "local");
 };
 
+static void __exit release_routing_table_names(void)
+{
+	__trans_list_clear(&table_names);
+}
+
 int rtnl_route_read_table_names(const char *path)
 {
 	__trans_list_clear(&table_names);
@@ -104,6 +109,11 @@ static void __init init_proto_names(void)
 	add_proto_name(RTPROT_STATIC, "static");
 };
 
+static void __exit release_proto_names(void)
+{
+	__trans_list_clear(&proto_names);
+}
+
 int rtnl_route_read_protocol_names(const char *path)
 {
 	__trans_list_clear(&proto_names);
