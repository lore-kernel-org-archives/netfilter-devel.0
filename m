From: =?ISO-8859-1?Q?Bj=F8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Problem compiling nftables kernel
Date: Thu, 19 Sep 2013 11:28:31 +0200
Message-ID: <CAJO99T=QRpNUmmdfXVj6xfNp_gDqRszfAzjSkygGsoyCKhJN=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33924 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3ISJ2d convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:28:33 -0400
Received: by mail-lb0-f172.google.com with SMTP id x18so7586369lbi.17
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2013 02:28:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

git: 6b92ef23eb12021c5ffe3ff03f60f6e0359c02c2

x86_64

net/netfilter/nft_meta.c: In function =91nft_meta_eval=92:
net/netfilter/nft_meta.c:82:17: error: incompatible types when
assigning to type =91u32=92 from type =91kuid_t=92
net/netfilter/nft_meta.c:88:17: error: incompatible types when
assigning to type =91u32=92 from type =91kgid_t=92

--=20
Bj(/)rnar
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
