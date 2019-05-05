Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4CEC004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 13:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248332082F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 13:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Yd43FOgj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfEENjb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 09:39:31 -0400
Received: from kadath.azazel.net ([81.187.231.250]:34886 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfEENjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 09:39:31 -0400
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 May 2019 09:39:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nDy/v0l3Qu7FA+znYTKZ1Eq3OJcCTKQbaU9IqPeXyM8=; b=Yd43FOgjpR1m/uSfQ4DutXNyOM
        hoA28aw8RpNDVGeePggWdD3Ed51Gl/UL2ZieoeNxBtnvHeuad9WnpIk0mTTJrZpDdTcW03U5ORI5H
        9h/3ky9fio7/F1u++nJeX9kEMqJ03fXarVwM0sUFgpdqt6AHt+J9Hnsznjp9HQQxJp3YRjRpGuyxB
        GJxWjHhLSHcY3OqNlbQKjF3REVh0GpacdZva1Vrik7oXcM/nRqnOJVUO042d+7JNQ/LswWtue7CUA
        WCY/WhHNoij9c5QGkr0nk7TajU94eJEP7rrHrWBeORqEzaJjy9YzRpPvL1N6cuxRh4CPuKbcW2+7T
        ncm1wlRA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hNH7d-0006go-3R; Sun, 05 May 2019 14:24:05 +0100
Date:   Sun, 5 May 2019 14:24:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     =?utf-8?B?U3TDqXBoYW5l?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
Message-ID: <20190505132403.GC4383@azazel.net>
References: <107c7e2d-dd8a-38d3-7386-f4ea56082edd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <107c7e2d-dd8a-38d3-7386-f4ea56082edd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-05-04, at 19:35:41 +0200, St=C3=A9phane Veyret wrote:
> This patch allows to add, list and delete expectations via nft objref
> infrastructure and assigning these expectations via nft rule.
>
> Signed-off-by: St=C3=A9phane Veyret <sveyret@gmail.com>
> ---
> include/uapi/linux/netfilter/nf_tables.h | 15 ++-
> net/netfilter/nft_ct.c | 124 ++++++++++++++++++++++-
> 2 files changed, 136 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h
> b/include/uapi/linux/netfilter/nf_tables.h
> index f0cf7b0f4f35..0a3452ca684c 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -968,6 +968,7 @@ enum nft_socket_keys {
> * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
> * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntra=
ck
> * @NFT_CT_ID: conntrack id
> + * @NFT_CT_EXPECT: connection tracking expectation
> */
> enum nft_ct_keys {
> NFT_CT_STATE,
> @@ -995,6 +996,7 @@ enum nft_ct_keys {
> NFT_CT_DST_IP6,
> NFT_CT_TIMEOUT,
> NFT_CT_ID,
> + NFT_CT_EXPECT,
> __NFT_CT_MAX
> };
> #define NFT_CT_MAX (__NFT_CT_MAX - 1)

Your patch has been mangled.

J.

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAlzO4/MACgkQ0Z7UzfnX
9sPRKA//Y/6WnVVLe5nXNaeiQFwUg10Ivc9OEzfW+Udv+jBKrGILf+4bCCWIBa8G
GZDg3LqSObdsxY3mJJrZvG/G97nZ07Td4Il7jTy2ZLMMDdRo2+6PW9bL8/RGX7CE
1PaACYPulL5iTcmAjTlAyK2Zm3GSLv+zugBqK2LMovf5SY2bBtzRiYNofayxwEnG
6My+GpOMdJXFJHnVkUn63NMfHt6un2MS6gWYaNOVKIc9siBld2+ntdjynp0N0nOH
OQqtNuJDtGnIvxtY9vZ/l00+ppTTT2sAtVuLGvwwvU/2aSBNLXK1Rb4lQMggGE4f
WxBVvltlpBDJo2HwrIoz+t9IncvalZpkmF8lHFQemdKqpqoKlI277+4ulUogzC7d
KhBPpaEkKwfL3H8nzljFzL5ZbuV4EjzVuU84XTt0WsbzXMuZw6cmJoJT5ZQUOSQg
Fw77XUilDqg0lUWNufWS+Vgb6ummv4QUvk8M7eRHaQL4ese7epVTStm1kEyWbyL+
ZMZd8O6xFF8K17AJygMt8ybKD9kdGJ1SyaeK61PCOYfXGkErgGHAfcNjkm1d4Jnn
F5XaZTNXsYzfFbXtoOTkJsJXSUz4DFINJcoMKnYqlVfU9EvDA+4X0eBIVloAo6GE
xD+LoKX3S2G+ozOOuLj5hzyExmFnLOGIJGE3zlnnOZSkFXPZ37k=
=R1IZ
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
