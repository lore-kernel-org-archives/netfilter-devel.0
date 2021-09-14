Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B49C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 12:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FA56113B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 12:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhINM4q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 08:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhINM4q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 08:56:46 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E474C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Sep 2021 05:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CVpnoRjHsT8MK1U+JNOt0leK6ID9h1btU4BMri0NfAk=; b=tQ6+81yCAqq/ADr29g/JgWIdzB
        suCz+Ds7/0tIdFF6IFLaEujLUvqHJQK347WDwFLPtw8OeJKUuv2y02RGONAC7VN36OTQAb6Zkd/uQ
        BQUq1NBG0iPanZNglnKbweq3WmG2XwQTDKwS6RuBh6BAH0jN+nwSAOtDLSOPhkZsSHYxuk1M6V84Z
        EvH4zJSBY6kTy5WOiVMZMvPopaui6LXWl9WqzXwgQifabpmGXedb88UiB2D+v2Tz6PRfL/xEQEjw/
        l+hWP9lfqWdkAiOWwHAz2h/gbqB/1BHYlgkjTZZp2VgPvEGgYtaTG4bFheBjEV7x/V4eoobosiI3C
        NmhOqT1g==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mQ7y7-00008P-Hf; Tue, 14 Sep 2021 13:55:23 +0100
Date:   Tue, 14 Sep 2021 13:55:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     kaskada@email.cz
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [xtables-addons] xt_ipp2p: fix compatibility with pre-5.1 kernels
Message-ID: <YUCburIOx/ykC+gJ@azazel.net>
References: <20210913194607.134775-1-jeremy@azazel.net>
 <2By.aVMy.1uKNcS{}pM6.1XG5DC@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PpkUpB/s4ds207iw"
Content-Disposition: inline
In-Reply-To: <2By.aVMy.1uKNcS{}pM6.1XG5DC@seznam.cz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--PpkUpB/s4ds207iw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-09-14, at 09:46:20 +0200, kaskada@email.cz wrote:
> On 13. 9. 2021, at 21:53:43, Jeremy Sowden wrote:
> > `ip_transport_len` and `ipv6_transport_len` were introduced in 5.1.
> > They are both single-statement static inline functions, so add
> > fall-back implementations for compatibility with older kernels.
>
> now it is possible to compile the source on Debian 10 (kernel
> 4.19.0-17-amd64), but when I run:
>
>   $ ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
>
> I still get this error:
>
>   ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such file or =
directory
>   Try `ip6tables -h' or 'ip6tables --help' for more information.
>
> When I run it with strace:
>
>   $ strace ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
>   [...]
>   stat("/usr/lib/x86_64-linux-gnu/xtables/libip6t_ipp2p.so", 0x7fff3562de=
a0) =3D -1 ENOENT (Adres=C3=A1=C5=99 nebo soubor neexistuje)
>
> It says this (it seems that
> "/usr/lib/x86_64-linux-gnu/xtables/libip6t_ipp2p.so" is missing, which
> is a bit suspicious).

It tries libip6t_ipp2p.so first, which fails, ...

>   stat("/usr/lib/x86_64-linux-gnu/xtables/libxt_ipp2p.so", {st_mode=3DS_I=
FREG|0755, st_size=3D33512, ...}) =3D 0
>   brk(NULL)                               =3D 0x562ecafdb000
>   brk(0x562ecaffc000)                     =3D 0x562ecaffc000
>   openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/xtables/libxt_ipp2p.so", O_=
RDONLY|O_CLOEXEC) =3D 3

=2E.. and then libxt_ipp2p.so, which succeeds.

>   read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\20\0\0\0\0\0\0=
"..., 832) =3D 832
>   fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D33512, ...}) =3D 0
>   mmap(NULL, 16680, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =3D 0x7f9=
02e63a000
>   mmap(0x7f902e63b000, 4096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|M=
AP_DENYWRITE, 3, 0x1000) =3D 0x7f902e63b000
>   mmap(0x7f902e63c000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRI=
TE, 3, 0x2000) =3D 0x7f902e63c000
>   mmap(0x7f902e63d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|=
MAP_DENYWRITE, 3, 0x2000) =3D 0x7f902e63d000
>   close(3)                                =3D 0
>   mprotect(0x7f902e63d000, 4096, PROT_READ) =3D 0
>   socket(AF_INET6, SOCK_RAW, IPPROTO_RAW) =3D 3
>   fcntl(3, F_SETFD, FD_CLOEXEC)           =3D 0
>   lstat("/proc/net/ip6_tables_names", {st_mode=3DS_IFREG|0440, st_size=3D=
0, ...}) =3D 0
>   statfs("/proc/net/ip6_tables_names", {f_type=3DPROC_SUPER_MAGIC, f_bsiz=
e=3D4096, f_blocks=3D0, f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0=
, f_fsid=3D{val=3D[0, 0]}, f_namelen=3D255, f_frsize=3D4096, f_flags=3DST_V=
ALID|ST_NOSUID|ST_NODEV|ST_NOEXEC|ST_RELATIME}) =3D 0
>   getsockopt(3, SOL_IPV6, IP6T_SO_GET_REVISION_MATCH, 0x7fff3562ddb0, [30=
]) =3D -1 ENOENT (Adres=C3=A1=C5=99 nebo soubor neexistuje)

This is the problem.  The kernel is reporting that it could not find an
ipv6 version.  That's because I forgot to add an ipv6 module alias.  I
will send a patch shortly.

J.

--PpkUpB/s4ds207iw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFAm6oACgkQKYasCr3x
BA0DHw/8Dlqnimul/Az32vIUhWuWBlKFGo+oZ1gK2Nhy5QUzwjygeqCILrLs4SuK
Z2MXEsJ/WHjpsGcNTtUPZ31OsdsFVRYtIfvHGAqWQky0G0k8rylGcFC6Ol66LuFP
a35JoTIQWV4723rcOzbjtO6UWwAhRZpnQPMCfN0kkzkw4BKLSErI5KK9iXRBmnmA
icD9jUkPpEhNAM7XIN4D98vdBEVriUHCOG7Hrl6TrA3evRiUA/xqPZkyRqCFbKDD
UsvrEri4TlC+3wBzWwtPrtzkbmssBvPp6l71lSq6xjXV4qBsXTAb0HONqModZQmu
eq9WThWxU918stp0BIMjUJQrBFYkd+ZHKx6UeJyUVLH+pUnjRb0edaeO4UgnE+Jp
V7m9vh3bLys/vrpSM2tlhhXvOH4gK9WzRYV4cT5VAUQezsncdfX4lDw1q4yizUcz
MiSIsUk3eRumajPTPaCNCbtLiHxUrwmEi/n0tdeT39TKxhfQ3RTBX2NXBPUFFLic
Iclzws/SHuzoVDRk6QdHfUZ/2/p7F5WIcGRwUDCafFuE99Z68fhLiO4mQSKIX9ry
3iuPacBkDzQYZbZNqM0lt8mdY9teLYpmhqtr2Kh+gfC/Eo9y8AABqcNdRxG0+m80
WtqkIs1yUpl1W6Cl0gfqmrfhLfeHlD8cWNcyns6D+rNtAWfk+1Y=
=6/fz
-----END PGP SIGNATURE-----

--PpkUpB/s4ds207iw--
