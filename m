Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B350C2BB48
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 17:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6709E238E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 17:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgLQRNX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgLQRNX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 12:13:23 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FEDC0617B0
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 09:12:42 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id F419F3C801EE;
        Thu, 17 Dec 2020 18:12:37 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 17 Dec 2020 18:12:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 979773C8015A;
        Thu, 17 Dec 2020 18:12:35 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 935AF340D5D; Thu, 17 Dec 2020 18:12:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 91C41340D5C;
        Thu, 17 Dec 2020 18:12:35 +0100 (CET)
Date:   Thu, 17 Dec 2020 18:12:35 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Vasily Averin <vvs@virtuozzo.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] netfilter: ipset: fix shift-out-of-bounds in
 htable_bits()
In-Reply-To: <e954ad22-83dc-e553-37a3-f0adb11cebb2@virtuozzo.com>
Message-ID: <alpine.DEB.2.23.453.2012171812090.2216@blackhole.kfki.hu>
References: <4d915d3a-6a95-7784-4057-2faa17a061@blackhole.kfki.hu> <e954ad22-83dc-e553-37a3-f0adb11cebb2@virtuozzo.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 17 Dec 2020, Vasily Averin wrote:

> htable_bits() can call jhash_size(32) and trigger shift-out-of-bounds
> 
> UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:151:6
> shift exponent 32 is too large for 32-bit type 'unsigned int'
> CPU: 0 PID: 8498 Comm: syz-executor519
>  Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>  htable_bits net/netfilter/ipset/ip_set_hash_gen.h:151 [inline]
>  hash_mac_create.cold+0x58/0x9b net/netfilter/ipset/ip_set_hash_gen.h:1524
>  ip_set_create+0x610/0x1380 net/netfilter/ipset/ip_set_core.c:1115
>  nfnetlink_rcv_msg+0xecc/0x1180 net/netfilter/nfnetlink.c:252
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:600
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This patch replaces htable_bits() by simple fls(hashsize - 1) call:
> it alone returns valid nbits both for round and non-round hashsizes.
> It is normal to set any nbits here because it is validated inside
> following htable_size() call which returns 0 for nbits>31.
> 
> Fixes: 1feab10d7e6d("netfilter: ipset: Unified hash type generation")
> Reported-by: syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_hash_gen.h | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 521e970..7d01086 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -143,20 +143,6 @@ struct net_prefixes {
>  	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
>  }
>  
> -/* Compute htable_bits from the user input parameter hashsize */
> -static u8
> -htable_bits(u32 hashsize)
> -{
> -	/* Assume that hashsize == 2^htable_bits */
> -	u8 bits = fls(hashsize - 1);
> -
> -	if (jhash_size(bits) != hashsize)
> -		/* Round up to the first 2^n value */
> -		bits = fls(hashsize);
> -
> -	return bits;
> -}
> -
>  #ifdef IP_SET_HASH_WITH_NETS
>  #if IPSET_NET_COUNT > 1
>  #define __CIDR(cidr, i)		(cidr[i])
> @@ -1520,7 +1506,11 @@ struct mtype_resize_ad {
>  	if (!h)
>  		return -ENOMEM;
>  
> -	hbits = htable_bits(hashsize);
> +	/* Compute htable_bits from the user input parameter hashsize.
> +	 * Assume that hashsize == 2^htable_bits,
> +	 * otherwise round up to the first 2^n value.
> +	 */
> +	hbits = fls(hashsize - 1);
>  	hsize = htable_size(hbits);
>  	if (hsize == 0) {
>  		kfree(h);
> -- 
> 1.8.3.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
