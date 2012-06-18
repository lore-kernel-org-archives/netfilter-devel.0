From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] properly annotate ipv4_netfilter_{init,fini}()
Date: Mon, 18 Jun 2012 11:18:31 +0100
Message-ID: <4FDF1C97020000780008A64E@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: <pablo@netfilter.org>, <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nat28.tlf.novell.com ([130.57.49.28]:60624 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2FRKSf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-netfilter-devel@vger.kernel.org:3:1>);
	Mon, 18 Jun 2012 06:18:35 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Despite being just a few bytes of code, they should still have proper
annotations.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 net/ipv4/netfilter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.5-rc3/net/ipv4/netfilter.c
+++ 3.5-rc3-ipv4-netfilter-sections/net/ipv4/netfilter.c
@@ -225,12 +225,12 @@ static const struct nf_afinfo nf_ip_afin
 	.route_key_size		= sizeof(struct ip_rt_info),
 };
 
-static int ipv4_netfilter_init(void)
+static int __init ipv4_netfilter_init(void)
 {
 	return nf_register_afinfo(&nf_ip_afinfo);
 }
 
-static void ipv4_netfilter_fini(void)
+static void __exit ipv4_netfilter_fini(void)
 {
 	nf_unregister_afinfo(&nf_ip_afinfo);
 }



