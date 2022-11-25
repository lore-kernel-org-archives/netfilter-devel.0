Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599A8C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Nov 2022 16:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiKYQNB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 11:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiKYQM5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 11:12:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA1E10FCD
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Nov 2022 08:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mEXzDIFq4evpE8gDSoP0AasEUt6Ri6VM0HojPQu4Z6g=; b=KGoUgX+hiLic/LUFPLgX/YBfiR
        2xykOj5DJJLcOeZ0X00Tz58wTcNaZ3Ta6wwtt2jhBdDcVYgtoGgwhGjRYDtYAaWYhKFLeBBsFgRzA
        /2I+Ds7VyuuH+HGDqcuLxxrEwP4wQ1F71OnjOvdQjmoMOc+oXFP9dk8YdroQdq8p7DvhaP1+xtmja
        iX+7zyH8o23vfux99HCAAsBn5V4dx8lED09ey++Llh8RGHv6uEGOxHhXghM4wW3jj5bBbqFe5lQXb
        d1jgYtvk+Qs2YTpiuLbuhxbum8zUhC90p3rVTE9uNnmHKRWHRGs+4sJPAe5LKsHDKeyVLgNj9B4F+
        AWVaXjeg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oybJu-0006Zw-Gj; Fri, 25 Nov 2022 17:12:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 3/4] extensions: libxt_conntrack: Drop extra whitespace in xlate
Date:   Fri, 25 Nov 2022 17:12:28 +0100
Message-Id: <20221125161229.18406-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125161229.18406-1-phil@nwl.cc>
References: <20221125161229.18406-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No point in having this. Interestingly, other test cases even made up
for it.

Fixes: 0afd957f6bc03 ("extensions: libxt_state: add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_SYNPROXY.txlate  | 2 +-
 extensions/libxt_conntrack.c      | 1 -
 extensions/libxt_hashlimit.txlate | 4 ++--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_SYNPROXY.txlate b/extensions/libxt_SYNPROXY.txlate
index b3de2b2a8c9dc..a2a3b6c522fe7 100644
--- a/extensions/libxt_SYNPROXY.txlate
+++ b/extensions/libxt_SYNPROXY.txlate
@@ -1,2 +1,2 @@
 iptables-translate -t mangle -A INPUT -i iifname -p tcp -m tcp --dport 80 -m state --state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
-nft add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460
+nft add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked counter synproxy sack-perm timestamp wscale 7 mss 1460
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 08dba42db5a18..09548c297695f 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1186,7 +1186,6 @@ static int state_xlate(struct xt_xlate *xl,
 	xt_xlate_add(xl, "ct state ");
 	state_xlate_print(xl, sinfo->state_mask,
 			  sinfo->invert_flags & XT_CONNTRACK_STATE);
-	xt_xlate_add(xl, " ");
 	return 1;
 }
 
diff --git a/extensions/libxt_hashlimit.txlate b/extensions/libxt_hashlimit.txlate
index 251a30d371db4..4cc26868e29c0 100644
--- a/extensions/libxt_hashlimit.txlate
+++ b/extensions/libxt_hashlimit.txlate
@@ -1,5 +1,5 @@
 iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-above 20kb/s --hashlimit-burst 1mb --hashlimit-mode dstip --hashlimit-name https --hashlimit-dstmask 24 -m state --state NEW -j DROP
-nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes } ct state new  counter drop
+nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second burst 1 mbytes } ct state new counter drop
 
 iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit --hashlimit-upto 300 --hashlimit-burst 15 --hashlimit-mode srcip,dstip --hashlimit-name https --hashlimit-htable-expire 300000 -m state --state NEW -j DROP
-nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets } ct state new  counter drop
+nft add rule ip filter OUTPUT tcp dport 443 meter https { ip daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets } ct state new counter drop
-- 
2.38.0

