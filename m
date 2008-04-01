From: James King <t.james.king@gmail.com>
Subject: [PATCH][IPTABLES]: libxt_iprange: Fix IP validation logic
Date: Tue, 01 Apr 2008 14:17:36 -0700
Message-ID: <47F2A670.2000405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:56473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbYDAVRh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:17:37 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2816026wah.23
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Apr 2008 14:17:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On iptables 1.4.1 pulled from SVN, the iprange match rejects valid IP addresses:

#iptables -t filter -A INPUT -m iprange --src-range \
192.168.1.1-192.168.1.2 -j ACCEPT
iptables v1.4.1: iprange match: Bad IP address `192.168.1.1'

The validation logic following numeric_to_ipaddr() was inverted.
Compile and rule insert tested.

===
[IPTABLES]: libxt_iprange: Fix IP validation logic

IP address validation logic was inverted, causing valid addresses to
be rejected.

Signed-off-by: James King <t.james.king@gmail.com>
---
diff -uprN a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
--- a/extensions/libxt_iprange.c        2008-04-01 10:26:51.000000000 -0700
+++ b/extensions/libxt_iprange.c        2008-04-01 10:40:15.000000000 -0700
@@ -41,14 +41,14 @@ parse_iprange(char *arg, struct ipt_ipra
                 *dash = '\0';

         ip = numeric_to_ipaddr(arg);
-       if (ip != NULL)
+       if (!ip)
                 exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
                            arg);
         range->min_ip = ip->s_addr;

         if (dash != NULL) {
                 ip = numeric_to_ipaddr(dash+1);
-               if (ip != NULL)
+               if (!ip)
                         exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
                                    dash+1);
                 range->max_ip = ip->s_addr;
