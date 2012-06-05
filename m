From: Aft nix <aftnix@gmail.com>
Subject: What happened to struct xt_match_param
Date: Tue, 5 Jun 2012 18:09:07 +0600
Message-ID: <CAGuaRCunyPyyot8jqYj_U_Fh041Y_v9LdcxPfx_37RmNF-F6nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47509 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2FEMJI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:09:08 -0400
Received: by ghrr11 with SMTP id r11so4189338ghr.19
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jun 2012 05:09:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

It seems in both 2.6 and mainline git tree, there is no reference to
struct xt_match_param. I verified in lxr, it seems older kernels like
2.6.32 has struct xt_match_param in <linux/netfilter/x_tables.h>

Cheers.

- --
- -aft

-----BEGIN PGP SIGNATURE-----
Version: OpenPGP.js v0.1
Comment: http://openpgpjs.org

wsBcBAEBAgAQBQJPzfbcCRCJVJ6A/SK8awAAB9UH/j0q6LiY4Wl7L0obPtu5
lOpDtD+KyLW8MDwwxU0d9VyllJ1LJkt5wdVvTYBBdoPumOqwSfnfOeW4XyIz
rpsMsmt2aaRhma0VIjDo4QddxldSNsBJ6Fmem3KBX5emCxJ2ujcRZg+/XYAd
Sj8LYubvcy1IKHGhnF+flgzv9YoLX9YuzRz/4rzkZn9MxST7fsLKErq0BRsy
OkXw8dRuC+exh5EtotVXMhUB53ou6xegza0uDdv5Y/wVhaUFv7UKmb5ZWwAA
W5a/MSe/reGnJucTH03qNZJE84tuWAAtPIfjvrLLUKg1hk6yYC4DZi9Uiyiu
7+cjtm5f7TA84ufe25cNHs0=
=4WId
-----END PGP SIGNATURE-----
