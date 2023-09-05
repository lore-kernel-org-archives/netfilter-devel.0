Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593FECA0FFE
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351846AbjIEQ0P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353610AbjIEGwe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 02:52:34 -0400
X-Greylist: delayed 406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Sep 2023 23:52:28 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D591B4
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 23:52:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 1D304CC02CC;
        Tue,  5 Sep 2023 08:45:38 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue,  5 Sep 2023 08:45:35 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id DE184CC02B3;
        Tue,  5 Sep 2023 08:45:34 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id AADCA3431A9; Tue,  5 Sep 2023 08:45:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id A9578343155;
        Tue,  5 Sep 2023 08:45:34 +0200 (CEST)
Date:   Tue, 5 Sep 2023 08:45:34 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Kyle Zeng <zengyhkyle@gmail.com>
cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        pablo@netfilter.org, edumazet@google.com
Subject: Re: Race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
In-Reply-To: <ZPZqetxOmH+w/myc@westworld>
Message-ID: <6e4a44b1-fa78-bcb3-5c2e-fcfd6489dac4@netfilter.org>
References: <ZPZqetxOmH+w/myc@westworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Kyle,

On Mon, 4 Sep 2023, Kyle Zeng wrote:

> There is a race between IPSET_CMD_ADD and IPSET_CMD_SWAP in 
> netfilter/ip_set, which can lead to the invocation of `__ip_set_put` on 
> a wrong `set`, triggering the `BUG_ON(set->ref == 0);` check in it.
> 
> More specifically, in `ip_set_swap`, it will hold the `ip_set_ref_lock`
> and then do the following to swap the sets:
> ~~~
> 	strncpy(from_name, from->name, IPSET_MAXNAMELEN);
> 	strncpy(from->name, to->name, IPSET_MAXNAMELEN);
> 	strncpy(to->name, from_name, IPSET_MAXNAMELEN);
> 
> 	swap(from->ref, to->ref);
> ~~~
> But in the retry loop in `call_ad`:
> ~~~
> 		if (retried) {
> 			__ip_set_get(set);
> 			nfnl_unlock(NFNL_SUBSYS_IPSET);
> 			cond_resched();
> 			nfnl_lock(NFNL_SUBSYS_IPSET);
> 			__ip_set_put(set);
> 		}
> ~~~
> No lock is hold, when it does the `cond_resched()`.
> As a result, `ip_set_ref_lock` (in thread 2) can swap the set with another when thread
> 1 is doing the `cond_resched()`. When it wakes up, the `set` variable
> alreays means another `set`, calling `__ip_set_put` on it will decrease
> the refcount on the wrong `set`, triggering the `BUG_ON` call.
> 
> I'm not sure what is the proper way to fix this issue so I'm asking for
> help.
> 
> A proof-of-concept code that can trigger the bug is attached.
> 
> The bug is confirmed on v5.10, v6.1, v6.5.rc7 and upstream.

Thanks for the thorough report. I think the proper fix is to change the 
reference counter at rescheduling from "ref" to "ref_netlink", which 
protects long taking procedures (originally just dumping). Could you 
verify that the patch below fixes the issue?

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e564b5174261..8a9cea8ed5ed 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -682,6 +682,15 @@ __ip_set_put(struct ip_set *set)
 /* set->ref can be swapped out by ip_set_swap, netlink events (like dump) need
  * a separate reference counter
  */
+static void
+__ip_set_get_netlink(struct ip_set *set)
+{
+	write_lock_bh(&ip_set_ref_lock);
+	set->ref_netlink++;
+	write_unlock_bh(&ip_set_ref_lock);
+}
+
+
 static void
 __ip_set_put_netlink(struct ip_set *set)
 {
@@ -1693,11 +1702,11 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 	do {
 		if (retried) {
-			__ip_set_get(set);
+			__ip_set_get_netlink(set);
 			nfnl_unlock(NFNL_SUBSYS_IPSET);
 			cond_resched();
 			nfnl_lock(NFNL_SUBSYS_IPSET);
-			__ip_set_put(set);
+			__ip_set_put_netlink(set);
 		}
 
 		ip_set_lock(set);

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
