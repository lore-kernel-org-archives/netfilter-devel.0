Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D1EC43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2415264EBA
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353457AbhCDAEq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:04:46 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:4284 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239766AbhCCQ5P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 11:57:15 -0500
Received: from zimbra63-e11.priv.proxad.net (unknown [172.20.243.213])
        by smtp1-g21.free.fr (Postfix) with ESMTP id B0408B0053D;
        Wed,  3 Mar 2021 17:56:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1614790585;
        bh=ouYDnguAyhV1KX7LepdxM2apKqjnquZuIirV3g0AHuE=;
        h=Date:From:To:Cc:In-Reply-To:Subject:From;
        b=pO3fQhL95qqDODSGmGSyKVR2F28p1xBOilv3x4zigNNrIuVzQX5L04JnMeR45FW9k
         5HV9/fTKHCMdfrm2YcfM/4C7H7oms2i8UX6GBKmcLuY8FBXEj52+9OMur7Dxp6LWWu
         o1+mOXG2K37QHpqtso3qnskf/9YBhJlO9xWD/EQDpzCO5Zu21D6fvpgMTSC9c35I9+
         mMywgLk8BWG7uRcCJorjlZsp0WeIsz6HW6u/IFhjCdstuoaTmMj+6TnMSHutxGQSZB
         xG+bXIUtGiS1t8OX9Bgq6Hhr25EORWsqO/kTbUKnmyUy5Pt4g7YLzlzRoPaFLX1AaF
         yiklKjlBcB1vw==
Date:   Wed, 3 Mar 2021 17:56:25 +0100 (CET)
From:   linuxludo@free.fr
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Message-ID: <1709326502.137229418.1614790585426.JavaMail.root@zimbra63-e11.priv.proxad.net>
In-Reply-To: <20210303163322.GA17445@salvia>
Subject: Re: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [82.64.212.11]
X-Mailer: Zimbra 7.2.0-GA2598 (ZimbraWebClient - GC88 (Win)/7.2.0-GA2598)
X-Authenticated-User: linuxludo@free.fr
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am using this module to establish GRE tunnels.
Previously, I had this in my ip6tables rules:

ip6tables -N FW6-IN
ip6tables -A FW6-IN -m conntrack --ctstate established, related -j LOG --lo=
g-prefix '[FW6-IN-1-A]'
ip6tables -A FW6-IN -m conntrack --ctstate established, related -j RETURN
ip6tables -A FW6-IN -m conntrack --ctstate invalid -j LOG --log-prefix '[FW=
6-IN-2-D]'
ip6tables -A FW6-IN -m conntrack --ctstate invalid -j DROP
ip6tables -A FW6-IN -p gre -j LOG --log-prefix '[FW6-IN-3-A]'
ip6tables -A FW6-IN -p gre -j RETURN
ip6tables -A FW6-IN -p icmp -j LOG --log-prefix '[FW6-IN-4-A]'
ip6tables -A FW6-IN -p icmp -j RETURN
ip6tables -A FW6-IN -j LOG --log-prefix '[FW6-IN-DEFAULT-D]'
ip6tables -A FW6-IN -j DROP
ip6tables -A INPUT  -j FW6-IN


Then a GRE interface:
ip link add name tun0 type ip6gre remote 2001:db8:1000::1 local 2001:db8:10=
00::2
ip address add 10.0.0.2/30 dev tun0
ip link set up dev tun0


When I enabled the GRE tunnel interface, I got a reject of GRE packets:

Mar  1 09:09:56 router1 kernel: [  303.025798] [FW6-IN-2-D] IN=3Deth0 OUT=
=3D MAC=3D0c:d8:6a:66:03:00:0c:d8:6a:b7:90:00:86:dd SRC=3D2001:0db8:1000:00=
00:0000:0000:0000:0002 DST=3D2001:0db8:1000:0000:0000:0000:0000:0001 LEN=3D=
136 TC=3D0 HOPLIMIT=3D64 FLOWLBL=3D825134 PROTO=3D47

This unconditionally matched the invalid packets rule.

With the proposed patch, the rule '[FW6-IN-3-A]' is well matched when activ=
ating the GRE tunnel interface.
Likewise, the rule '[FW6-IN-1-A]' is matched for the flow passing through t=
he GRE tunnel.


Regards,



----- Mail original -----
De: "Pablo Neira Ayuso" <pablo@netfilter.org>
=C3=80: linuxludo@free.fr
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org, co=
reteam@netfilter.org
Envoy=C3=A9: Mercredi 3 Mars 2021 17:33:22
Objet: Re: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module

Hi,

On Wed, Mar 03, 2021 at 11:21:11AM +0100, linuxludo@free.fr wrote:
> Dear,
>=20
> I would provide you a small patch in order to fix a BUG when GRE over IPv=
6 is used with netfilter/conntrack module.
>=20
> This is my first contribution, not knowing the procedure well, thank you =
for being aware of this request.
>=20
> Regarding the proposed patch, here is a description of the encountered bu=
g.
> Indeed, when an ip6tables rule dropping traffic due to an invalid packet =
(aka w/ conntrack module) is placed before a GRE protocol permit rule, the =
latter is never reached ; the packet is discarded via the previous rule.=20
>=20
> The proposed patch takes into account both IPv4 and IPv6 in conntrack mod=
ule for GRE protocol.
> You will find this one at the end of this email.

The GRE protocol helper is tied to the PPTP conntrack helper which
does not support for IPv6. How are you using this update in your
infrastructure?

Thanks.

> --- nf_conntrack_proto_gre.c.orig       2021-03-03 05:03:37.034665100 -05=
00
> +++ nf_conntrack_proto_gre.c    2021-03-02 17:42:53.000000000 -0500
> @@ -219,7 +219,7 @@ int nf_conntrack_gre_packet(struct nf_co
>                             enum ip_conntrack_info ctinfo,
>                             const struct nf_hook_state *state)
>  {
> -       if (state->pf !=3D NFPROTO_IPV4)
> +       if (state->pf !=3D NFPROTO_IPV4 && state->pf !=3D NFPROTO_IPV6)
>                 return -NF_ACCEPT;
>=20
>         if (!nf_ct_is_confirmed(ct)) {
>=20
