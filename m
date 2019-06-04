Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6F2C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 18:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B3F72075B
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 18:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="B5cQETlz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFDSob (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 14:44:31 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:50527 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFDSob (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 14:44:31 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jun 2019 14:44:30 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 91D64CC0104;
        Tue,  4 Jun 2019 20:34:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1559673250; x=1561487651; bh=nM34Cvskyu
        wdt2g5GxnlM0hjhnRJ3M7sBf30FrWjSr8=; b=B5cQETlziAxTdLZMg7g52AyKL2
        sEgaIhc/MuaWjLW09h6oUv/2I5kzlEEgBBfqRp0PGt3Hqp5YfMIL1oxlxprJRDAf
        MLEM2ja1RPRVQ2A43lcRY1eJ/QCLoUr/hKRXiW02VI8v/PiOH0i19WqtP4BGnV7o
        8SSyDr0jSy3LHiwu8=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue,  4 Jun 2019 20:34:10 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 5F819CC0102;
        Tue,  4 Jun 2019 20:34:10 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 21AD222026; Tue,  4 Jun 2019 20:34:10 +0200 (CEST)
Date:   Tue, 4 Jun 2019 20:34:10 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     NOYB <JunkYardMail1@Frontier.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipset: Fix memory accounting for hash types on resize
In-Reply-To: <70ff6b512f8a6e9fc70a0e2b001d6278d31a1c96.1558884459.git.sbrivio@redhat.com>
Message-ID: <alpine.DEB.2.20.1906042033170.17677@blackhole.kfki.hu>
References: <70ff6b512f8a6e9fc70a0e2b001d6278d31a1c96.1558884459.git.sbrivio@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Sun, 26 May 2019, Stefano Brivio wrote:

> If a fresh array block is allocated during resize, the current in-memory
> set size should be increased by the size of the block, not replaced by it.
> 
> Before the fix, adding entries to a hash set type, leading to a table
> resize, caused an inconsistent memory size to be reported. This becomes
> more obvious when swapping sets with similar sizes:
> 
>   # cat hash_ip_size.sh
>   #!/bin/sh
>   FAIL_RETRIES=10
> 
>   tries=0
>   while [ ${tries} -lt ${FAIL_RETRIES} ]; do
>   	ipset create t1 hash:ip
>   	for i in `seq 1 4345`; do
>   		ipset add t1 1.2.$((i / 255)).$((i % 255))
>   	done
>   	t1_init="$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"
> 
>   	ipset create t2 hash:ip
>   	for i in `seq 1 4360`; do
>   		ipset add t2 1.2.$((i / 255)).$((i % 255))
>   	done
>   	t2_init="$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"
> 
>   	ipset swap t1 t2
>   	t1_swap="$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"
>   	t2_swap="$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"
> 
>   	ipset destroy t1
>   	ipset destroy t2
>   	tries=$((tries + 1))
> 
>   	if [ ${t1_init} -lt 10000 ] || [ ${t2_init} -lt 10000 ]; then
>   		echo "FAIL after ${tries} tries:"
>   		echo "T1 size ${t1_init}, after swap ${t1_swap}"
>   		echo "T2 size ${t2_init}, after swap ${t2_swap}"
>   		exit 1
>   	fi
>   done
>   echo "PASS"
>   # echo -n 'func hash_ip4_resize +p' > /sys/kernel/debug/dynamic_debug/control
>   # ./hash_ip_size.sh
>   [ 2035.018673] attempt to resize set t1 from 10 to 11, t 00000000fe6551fa
>   [ 2035.078583] set t1 resized from 10 (00000000fe6551fa) to 11 (00000000172a0163)
>   [ 2035.080353] Table destroy by resize 00000000fe6551fa
>   FAIL after 4 tries:
>   T1 size 9064, after swap 71128
>   T2 size 71128, after swap 9064
> 
> Reported-by: NOYB <JunkYardMail1@Frontier.com>
> Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Excellent, thanks! Patch is applied in ipset git tree and a new release is 
on the way.

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 01d51f775f12..623e0d675725 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -625,7 +625,7 @@ mtype_resize(struct ip_set *set, bool retried)
>  					goto cleanup;
>  				}
>  				m->size = AHASH_INIT_SIZE;
> -				extsize = ext_size(AHASH_INIT_SIZE, dsize);
> +				extsize += ext_size(AHASH_INIT_SIZE, dsize);
>  				RCU_INIT_POINTER(hbucket(t, key), m);
>  			} else if (m->pos >= m->size) {
>  				struct hbucket *ht;
> -- 
> 2.20.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
