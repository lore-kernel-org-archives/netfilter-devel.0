From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 04/04]: netfilter: nf_conntrack_irc: make sure string is terminated before calling simple_strtoul
Date: Thu,  4 Sep 2008 16:15:58 +0200 (MEST)
Message-ID: <20080904141558.6414.18261.sendpatchset@x2.localnet>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62504 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYIDOQA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:16:00 -0400
In-Reply-To: <20080904141553.6414.87829.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit c834a27db90c3b871709c2f3b5d02d5ba62c6c48
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Sep 4 14:22:06 2008 +0200

    netfilter: nf_conntrack_irc: make sure string is terminated before calling simple_strtoul
    
    Alexey Dobriyan points out:
    
    1. simple_strtoul() silently accepts all characters for given base even
       if result won't fit into unsigned long. This is amazing stupidity in
       itself, but
    
    2. nf_conntrack_irc helper use simple_strtoul() for DCC request parsing.
       Data first copied into 64KB buffer, so theoretically nothing prevents
       reading past the end of it, since data comes from network given 1).
    
    This is not actually a problem currently since we're guaranteed to have
    a 0 byte in skb_shared_info or in the buffer the data is copied to, but
    to make this more robust, make sure the string is actually terminated.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 1b1226d..20633fd 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -68,11 +68,21 @@ static const char *const dccprotos[] = {
 static int parse_dcc(char *data, const char *data_end, u_int32_t *ip,
 		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
 {
+	char *tmp;
+
 	/* at least 12: "AAAAAAAA P\1\n" */
 	while (*data++ != ' ')
 		if (data > data_end - 12)
 			return -1;
 
+	/* Make sure we have a newline character within the packet boundaries
+	 * because simple_strtoul parses until the first invalid character. */
+	for (tmp = data; tmp <= data_end; tmp++)
+		if (*tmp == '\n')
+			break;
+	if (tmp > data_end || *tmp != '\n')
+		return -1;
+
 	*ad_beg_p = data;
 	*ip = simple_strtoul(data, &data, 10);
 
