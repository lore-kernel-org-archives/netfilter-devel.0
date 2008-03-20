From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: ipt_recent: sanity check hit count
Date: Thu, 20 Mar 2008 18:55:19 +0100
Message-ID: <47E2A507.6070409@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070607060801060906020206"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:44737 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755231AbYCTRzZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:55:25 -0400
Received: from edge02.upc.biz ([192.168.13.237]) by viefep16-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080320175523.FGXR8097.viefep16-int.chello.at@edge02.upc.biz>
          for <netfilter-devel@vger.kernel.org>;
          Thu, 20 Mar 2008 18:55:23 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070607060801060906020206
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------070607060801060906020206
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit be32bceccbf7051ff1433943df7e808c576d1191
Author: Daniel Hokka Zakrisson <daniel@hozac.com>
Date:   Thu Mar 20 18:34:39 2008 +0100

    [NETFILTER]: ipt_recent: sanity check hit count
    
    If a rule using ipt_recent is created with a hit count greater than
    ip_pkt_list_tot, the rule will never match as it cannot keep track
    of enough timestamps. This patch makes ipt_recent refuse to create such
    rules.
    
    With ip_pkt_list_tot's default value of 20, the following can be used
    to reproduce the problem.
    
    nc -u -l 0.0.0.0 1234 &
    for i in `seq 1 100`; do echo $i | nc -w 1 -u 127.0.0.1 1234; done
    
    This limits it to 20 packets:
    iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
             --rsource
    iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
             60 --hitcount 20 --name test --rsource -j DROP
    
    While this is unlimited:
    iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
             --rsource
    iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
             60 --hitcount 21 --name test --rsource -j DROP
    
    With the patch the second rule-set will throw an EINVAL.
    
    Reported-by: Sean Kennedy <skennedy@vcn.com>
    Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 68cbe3c..8e8f042 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -252,6 +252,8 @@ recent_mt_check(const char *tablename, const void *ip,
 	if ((info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
 		return false;
+	if (info->hit_count > ip_pkt_list_tot)
+		return false;
 	if (info->name[0] == '\0' ||
 	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
 		return false;

--------------070607060801060906020206--
