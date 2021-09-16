Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52C0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 19:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B74610D1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 19:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhIPTJb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhIPTJa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 15:09:30 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83BC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 12:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dCLVL4YdK2PyyFwP8A4WsrfPU9dlvAdsThpna0rZ97g=; b=ORWC/4DSxAiFtBP6N70r5NBk32
        l8EUYyrEWG1wQb/IZmYxN4X8c4F+aprJaIiueZ49Gu+JSYgbjonTip7jvbWbpG/52neiR1ccJq7Ks
        gSZJVJrbck+e332mzEEWWPymfmTnIGK4JWT+EVrqbupr1FX5CX/dR4RZAyuuKBE8PiiUXlrRQwvPX
        K/rZi7JGGkghsX5mw/MKksL3WRtPqjvx9mu/mW4z/L+0lzuYe9zxnxZG/kURypSQy9LrvDGQNYdXm
        0lAI54mESLWL0CPJWI2ADaeAfjefk1xFKDy/5NvieFF1p2XdFpnJcjeXVtsVmgp7h7Ix26QVS/D0H
        OVrrakZQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mQwju-002TgN-FN; Thu, 16 Sep 2021 20:08:06 +0100
Date:   Thu, 16 Sep 2021 20:08:05 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     kaskada@email.cz
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias
Message-ID: <YUOWFQUquE59aamm@azazel.net>
References: <FA.Zu6V.5ytypyKnDSO.1XGXsj@seznam.cz>
 <20210914140934.190397-1-jeremy@azazel.net>
 <33D.aVMp.3L4gqjighB0.1XGFsS@seznam.cz>
 <YUIJW3DPDsmmjYPA@azazel.net>
 <sqos9337-n8n6-1os2-s7qr-n4364on33nqp@vanv.qr>
 <14d.aVM5.6eKrJXfu}0l.1XGpUS@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1e9g0r+HE+4qIc7e"
Content-Disposition: inline
In-Reply-To: <14d.aVM5.6eKrJXfu}0l.1XGpUS@seznam.cz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--1e9g0r+HE+4qIc7e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-16, at 14:25:00 +0200, kaskada@email.cz wrote:
> How can I check where iptables/ip6tables searches for plugins/modules
> please?
>
> Actually the problem is not with iptables but with ip6tables. I can
> use IPP2P module on the same Debian with no problems with iptables,
> but ip6tables give this error (still the same):
>
> ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
> ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such file or
> directory
>
> Try `ip6tables -h' or 'ip6tables --help' for more information.
>
> BTW I`m using legacy (not nf_tables) iptables and ip6tables (changed
> with update-alternatives --config iptables, update-alternatives
> --config ip6tables).

xtables-addons installs the following kernel modules:

  /lib/modules/4.19.0-17-amd64/extra/compat_xtables.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_ACCOUNT.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_CHAOS.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_condition.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_DELUDE.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_DHCPMAC.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_DNETMAP.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_ECHO.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_fuzzy.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_geoip.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_iface.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_IPMARK.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_ipv4options.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_length2.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_LOGMARK.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_lscan.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_pknock.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_PROTO.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_psd.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_quota2.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_SYSRQ.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_TARPIT.ko

and the following user-space libraries:

  /usr/lib/x86_64-linux-gnu/xtables/libxt_ACCOUNT.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_CHAOS.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_condition.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_DELUDE.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_dhcpmac.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_DHCPMAC.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_DNETMAP.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_ECHO.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_fuzzy.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_geoip.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_gradm.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_iface.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_IPMARK.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_ipp2p.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_ipv4options.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_length2.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_LOGMARK.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_lscan.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_pknock.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_PROTO.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_psd.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_quota2.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_SYSRQ.so
  /usr/lib/x86_64-linux-gnu/xtables/libxt_TARPIT.so

Make sure you're not using the xt_ipp2p.ko kernel module:

  $ sudo ip6tables-legacy -F -t mangle
  $ sudo iptables-legacy -F -t mangle

Make sure you don't have xt_ipp2p.ko loaded:

  $ sudo modprobe -r xt_ipp2p

Make sure the files don't exists on your box:

  $ sudo rm /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko
  $ sudo rm /usr/lib/x86_64-linux-gnu/xtables/libxt_ipp2p.so

Run depmod:

  $ sudo depmod -av | awk '$1 ~ /xt_ipp2p/'

Make sure you've got the latest source checked out and pristine:

  $ git clean -d -f -x
  $ git reset --hard master
  HEAD is now at f144c2e xt_ipp2p: replace redundant ipp2p_addr
  $ git pull --rebase origin master
  From https://git.inai.de/xtables-addons
   * branch            master     -> FETCH_HEAD
  Already up to date.
  Current branch master is up to date.
  $ git log -1
  commit f144c2ebba17aa4c6b8d402623d53b655945be76 (HEAD -> master, origin/master, origin/HEAD)
  Author: Jan Engelhardt <jengelh@inai.de>
  Date:   Tue Sep 14 17:07:58 2021 +0200

      xt_ipp2p: replace redundant ipp2p_addr

Build and install it:

  $ ./autogen.sh
  $ ./configure
  $ make -j3
  $ sudo make install

Run depmod:

  $ sudo depmod -av | awk '$1 ~ /xt_ipp2p/'
  /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko needs "xt_unregister_matches": /lib/modules/4.19.0-17-amd64/kernel/net/netfilter/x_tables.ko
  /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko needs "HX_memmem": /lib/modules/4.19.0-17-amd64/extra/compat_xtables.ko

Use the extension:

  $ sudo ip6tables-legacy -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
  $ sudo ip6tables-legacy -t mangle -L PREROUTING
  Chain PREROUTING (policy ACCEPT)
  target     prot opt source               destination
  ACCEPT     all      anywhere             anywhere             -m ipp2p  --dc

J.

--1e9g0r+HE+4qIc7e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFDlf0ACgkQKYasCr3x
BA3cMw//eFcJTFaSXebyclk2ZRlGVMvHaGCJ2NLnaFnujTDQ/XWpoF7lbn2nJ4/A
LquvPTowGotBTF97/Gd7a+p58zT5qUXNc+cSMuaRozG5BcPFIjt971/dSJCJcrJa
gvHQM9LW6Lg1FJSzhOFt4XaVR9S8I/87iq00VTcK9kCIjEEmhYNcjWRP7twgb8Qp
WzqXvGW276C8IiGzokrr3fJLUFtOIjmO9IXYxs3vcNfd2fxN+IoUitjdx4PnNdu3
9WgZ0yoLYrOAo/GMDdrbBk3qgWP/ofqJ4WDKxr3wrgdiyjEimYDWbBifdx67Jv3J
TWkQmInttl8tzQSvi3XT6G9zAZB8hSi3x8nrwegAVrVU4k2r40mQmfU+EGQl3iFR
vhZGa2Mzpfuly7njAUMmIXVWZna+4s6NhGWfbYf2oYPl8TEqvYJeDZhpG1c3/lmi
R685/LUx+aHG6jfAhhsMWZowYgPpWXUHonYatqEcAU/vuV0kre1j0MHJ3hnPzoUQ
y/YFU4DYH61JMuiRSFW1wJo8V7HFRX8M+HGgRdtCrIiraLHgKSOSL8Fkag4HwoWt
bSXZqA4+JFeYR9LrBcBDSxOoSaWym+5mCul9pRuwSnpNU2JJ52s0U83s9LDuZRpz
0z+ncx5HjibVrJJOFWInfd//0uHn54mt9vVNPmA0/X7xdvCOSMs=
=TamC
-----END PGP SIGNATURE-----

--1e9g0r+HE+4qIc7e--
