From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] gmputil: turn mpz_printf into mpz_vfprintf to
 restore --with-mini-gmp
Date: Wed, 22 Nov 2017 20:40:17 +0100
Message-ID: <20171122194017.GA3356@salvia>
References: <20171122193616.31755-1-pablo@netfilter.org>
 <20171122193616.31755-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751681AbdKVTkW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 14:40:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 210AE20A526
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 20:40:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 127E7DA848
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 20:40:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171122193616.31755-2-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 22, 2017 at 08:36:16PM +0100, Pablo Neira Ayuso wrote:
> 2535ba7006f2 ("src: get rid of printf") uses gmp_vfprintf() which
> doesn't exists in mini-gmp.c, this breaks compilation with --mini-gmp.
> 
> This patch implements poor man's gmp_vfprintf that takes one single
> argument which is what we need.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Phil: We're still hitting a compilation warning, since libnftables is
>        in place, it seems -Wno-sign-compare is ignored.

mini-gmp.c: In function ‘mpn_get_str_bits’:
mini-gmp.c:1176:17: warning: comparison between signed and unsigned
integer expressions [-Wsign-compare]
       if (shift >= GMP_LIMB_BITS && ++i < un)
                 ^
mini-gmp.c: In function ‘mpz_and’:
mini-gmp.c:1406:31: warning: comparison between signed and unsigned
integer expressions [-Wsign-compare]
 #define MPZ_REALLOC(z,n) ((n) > (z)->_mp_alloc   \
                               ^
mini-gmp.c:3650:8: note: in expansion of macro ‘MPZ_REALLOC’
   rp = MPZ_REALLOC (r, rn + rc);
