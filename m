From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] extensions/libxt_tcp: fix nftables translate flags
 value, 'none' vs '0x0'
Date: Wed, 06 Apr 2016 14:10:52 +0200
Message-ID: <145994465193.22717.2137088538000837721.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter@mva.name
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48235 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754237AbcDFMLC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 08:11:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The iptables command:
 -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE

should translate to:
 tcp flags & fin|syn|rst|psh|ack|urg == 0x0

instead of:
 tcp flags & fin|syn|rst|psh|ack|urg == none

Reported-by: Vadim A. Misbakh-Soloviov <netfilter@mva.name>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libxt_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 6a85ed4..2a14035 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -390,7 +390,7 @@ static void print_tcp_xlate(struct xt_xlate *xl, uint8_t flags)
 	}
 
 	if (!have_flag)
-		xt_xlate_add(xl, "none");
+		xt_xlate_add(xl, "0x0");
 }
 
 static int tcp_xlate(const void *ip, const struct xt_entry_match *match,

