From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: compilation warning --with-mini-gmp
Date: Tue, 9 Jan 2018 14:26:32 +0100
Message-ID: <20180109132632.xfkio5fsama4so5j@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757414AbeAIN0i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 08:26:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CA42FFF121
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 14:26:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAEB8DA84F
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 14:26:35 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We hit this since conversion to library:

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
        ^
mini-gmp.c: In function ‘mpz_ior’:
mini-gmp.c:1406:31: warning: comparison between signed and unsigned
integer expressions [-Wsign-compare]
 #define MPZ_REALLOC(z,n) ((n) > (z)->_mp_alloc   \
                               ^
mini-gmp.c:3723:8: note: in expansion of macro ‘MPZ_REALLOC’
   rp = MPZ_REALLOC (r, rn + rc);
        ^
mini-gmp.c: In function ‘mpz_xor’:
mini-gmp.c:1406:31: warning: comparison between signed and unsigned
integer expressions [-Wsign-compare]
 #define MPZ_REALLOC(z,n) ((n) > (z)->_mp_alloc   \
                               ^
mini-gmp.c:3792:8: note: in expansion of macro ‘MPZ_REALLOC’
   rp = MPZ_REALLOC (r, un + rc);
        ^
mini-gmp.c: In function ‘mpz_set_str’:
mini-gmp.c:4167:17: warning: comparison between signed and unsigned
integer expressions [-Wsign-compare]

There is a knob that removes -Wsign-compare for this file, which is a
cached copy from libgmp that we don't want to modify.

If you have some spare cycles, I'd appreciate.

Thanks Phil.
