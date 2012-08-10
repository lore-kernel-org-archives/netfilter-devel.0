From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: nf_ct_expect: fix re-insertion in expect
 list if timer refresh fails
Date: Fri, 10 Aug 2012 02:00:31 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208100135090.26308@stinky-local.trash.net>
References: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
 <1344553332-8536-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33834 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2HJAAc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:00:32 -0400
In-Reply-To: <1344553332-8536-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 10 Aug 2012, pablo@netfilter.org wrote:

> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> This patch fixes __nf_ct_expect_check to return 0 in case that the
> expectation timer refresh fails. If the expectation is dying, we have
> to make sure that we don't re-insert it again in the list.
>
> This problem becomes more noticeable with permanent expectations, used
> by the conntrack SIP helper.
>
> RIP: 0010:[<ffffffffa00b6ce2>]  [<ffffffffa00b6ce2>] flush_expectations.clone.15+0x72/0x9b
> [nf_conntrack_sip]
> RSP: 0018:ffff88013fc03970  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dead000000100100 RCX: ffff88011aaced68
> RDX: 0000000000000000 RSI: ffff88013fc03950 RDI: ffff88009a411f78
> RBP: ffff88013fc03990 R08: dead000000200200 R09: dead000000100100
> R10: dead000000200200 R11: ffff88013fc03950 R12: ffff88013fc03a01
> R13: 0000000000000001 R14: dead000000100100 R15: 0000000000000157
> [...]
> [<ffffffffa00b6e6a>] process_invite_response+0x66/0x6b [nf_conntrack_sip]
> [<ffffffffa00b65a1>] process_sip_msg.clone.11+0x1db/0x236 [nf_conntrack_sip]
> [<ffffffffa00b6e04>] ? process_update_response+0x6b/0x6b [nf_conntrack_sip]
> [<ffffffffa00b68a6>] sip_help_udp+0x8c/0x97 [nf_conntrack_sip]
> [<ffffffffa007aa15>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
> [<ffffffff812e54bc>] nf_iterate+0x43/0x78
>
> Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> net/netfilter/nf_conntrack_expect.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 45cf602..ec8bb0d 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -398,7 +398,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
> 	hlist_for_each_entry(i, n, &net->ct.expect_hash[h], hnode) {
> 		if (expect_matches(i, expect)) {
> 			/* Refresh timer: if it's dying, ignore.. */
> -			if (refresh_timer(i)) {
> +			if (!refresh_timer(i)) {
> 				ret = 0;
> 				goto out;
> 			}

Actually that also doesn't look correct. If we managed to refresh the 
timer (indicated by return value 1), there's nothing left to do and
we exit without an error. If the expectation is indeed dying (indicated
by return value 0), we continue looking for an alive expectation and
if none is found, we try to insert the new one. This basically covers
the rare condition that an expectation is dying at the exact moment
where a matching one is reinstated.

This can't be the problem though, the dying expectation won't vanish
while the SIP helper is walking the list since its using RCU for
destruction, and the SIP helper will ignore it since the timer can't
be deleted twice.

Is this problem reproducable and are there dumps showing what exactly
is happening?
