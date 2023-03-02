Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACE5C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 14:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCBO3z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 09:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjCBO3x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 09:29:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AE4392A6
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 06:29:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXjwI-0001co-It; Thu, 02 Mar 2023 15:29:46 +0100
Date:   Thu, 2 Mar 2023 15:29:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Major =?iso-8859-15?Q?D=E1vid?= <major.david@balasys.hu>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: CPU soft lockup in a spin lock using tproxy and nfqueue
Message-ID: <20230302142946.GB309@breakpoint.cc>
References: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Major Dávid <major.david@balasys.hu> wrote:
> Hi all, Hi Pablo,
> 
> Following comments on bug: https://bugzilla.netfilter.org/show_bug.cgi?id=1662
>
> I researched a little bit further. I started to use older kernels from
> Ubuntu mainline PPA to get a rough estimate about affected kernel versions.
> At kernel version v3.18.140 still getting a soft lockup, I spun up a good
> oldie' Ubuntu Precise VM environment to test older kernels. No nftables
> support in Precise so I ported my test ruleset to iptables:
> 
> iptables -t mangle -F
> iptables -t mangle -X

Thanks, this is a bug in nft_tproxy.c.

Can you test following fix?

Thanks!

Subject: netfilter: tproxy: fix deadlock due to missing BH disable

The xtables packet traverser performs an unconditional
local_bh_disable(), but the nf_tables evaluation loop does not.

Functions that are called from either xtables or nftables must assume
that they can be called in process context.

inet_twsk_deschedule_put() assumes that no softirq interrupt can occur.
If tproxy is used from nf_tables its possible that we'll deadlock
trying to aquire a lock already held in process context.

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -17,6 +17,13 @@ static inline bool nf_tproxy_sk_is_transparent(struct sock *sk)
 	return false;
 }
 
+static inline void nf_tproxy_twsk_deschedule_put(struct inet_timewait_sock *tw)
+{
+	local_bh_disable();
+	inet_twsk_deschedule_put(tw);
+	local_bh_enable();
+}
+
 /* assign a socket to the skb -- consumes sk */
 static inline void nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
 {
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -38,7 +38,7 @@ nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
 					    hp->source, lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -63,7 +63,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 					    lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
