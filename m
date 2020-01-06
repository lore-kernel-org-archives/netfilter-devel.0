Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E50C32771
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 07:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3945E21734
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 07:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgAFHJ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 02:09:29 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45148 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgAFHJ2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 02:09:28 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id CE5343A23DA
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 18:09:16 +1100 (AEDT)
Received: (qmail 4746 invoked by uid 501); 6 Jan 2020 07:09:15 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 1/1] doc: setup: Add shell script fixmanpages.sh to make usable man pages
Date:   Mon,  6 Jan 2020 18:09:15 +1100
Message-Id: <20200106070915.4700-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200106070915.4700-1-duncan_roe@optusnet.com.au>
References: <20200106070915.4700-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=YfSddF41CuLhZLoWo2sA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

fixmanpages.sh generates a top-level man page file tree such that man/man3
contains an entry for every documented nfq function.

How it works: Doxygen generates a man page for every module. For each module,
fixmanpages.sh copies the man age to a file with the name of the first defined
function in the module: e.g. it copies tcp.3 to nfq_tcp_get_hdr.3. Then it
symlinks all the other functions defined in the module to that file, e.g.
ln -s nfq_tcp_get_hdr.3 nfq_tcp_get_payload.3.

The end result is that when a user types "man some_nfq_function", a man page
will always display.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 fixmanpages.sh | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100755 fixmanpages.sh

diff --git a/fixmanpages.sh b/fixmanpages.sh
new file mode 100755
index 0000000..32b2420
--- /dev/null
+++ b/fixmanpages.sh
@@ -0,0 +1,60 @@
+#!/bin/bash -p
+#set -x
+function main
+{
+  set -e
+  rm -rf man
+  mkdir -p man/man3
+  cd doxygen/man/man3
+  setgroup LibrarySetup nfq_open
+  add2group nfq_close nfq_bind_pf nfq_unbind_pf
+  setgroup Parsing nfq_get_msg_packet_hdr
+  add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev\
+    nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name nfq_get_physindev_name\
+    nfq_get_outdev_name nfq_get_physoutdev_name nfq_get_packet_hw nfq_get_uid\
+    nfq_get_gid nfq_get_secctx nfq_get_payload
+  setgroup Queue nfq_fd
+  add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode\
+    nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict nfq_set_verdict2\
+    nfq_set_verdict_batch nfq_set_verdict_batch2 nfq_set_verdict_mark
+  setgroup ipv4 nfq_ip_get_hdr
+  add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf\
+    nfq_ip_set_checksum
+  setgroup ipv6 nfq_ip6_get_hdr
+  add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf
+  setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd
+  add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen
+  setgroup nfq_verd nfq_nlmsg_verdict_put
+  add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt
+  setgroup nlmsg nfq_nlmsg_parse
+  setgroup otherfns pktb_tailroom
+  add2group pktb_mac_header pktb_network_header pktb_transport_header
+  setgroup pktbuff pktb_alloc
+  add2group pktb_usebuf pktb_data pktb_len pktb_free pktb_mangle pktb_mangled
+  setgroup tcp nfq_tcp_get_hdr
+  add2group nfq_tcp_get_payload nfq_tcp_get_payload_len\
+    nfq_tcp_compute_checksum_ipv4 nfq_tcp_compute_checksum_ipv6\
+    nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6
+  setgroup udp
+  add2group nfq_udp_get_hdr nfq_udp_get_payload nfq_udp_get_payload_len\
+    nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf
+  setgroup internals nfq_udp_compute_checksum_ipv4
+  add2group nfq_udp_compute_checksum_ipv6
+  setgroup uselessfns pktb_push
+  add2group pktb_pull pktb_put pktb_trim
+}
+function setgroup
+{
+  cp $1.3 ../../../man/man3/$2.3
+  BASE=$2
+}
+function add2group
+{
+  cd ../../../man/man3
+  for i in $@
+  do
+    ln -sf $BASE.3 $i.3
+  done
+  cd - >/dev/null
+}
+main
-- 
2.14.5

