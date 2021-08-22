Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1052DC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 11:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08CC6126A
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 11:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhHVLv1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 07:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbhHVLv0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 07:51:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2493DC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 04:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p9cr5zaiGEy1OoinICfGBcGN/bFc7NwIXwjz5hFXl18=; b=lwpUwAtSLcHAr0VMm5sA/26bgz
        fTQY2YNyp3H/a1Us2LqjumCRWHvxKlpRl2IxsAA1U4+jqDkBx9AI6ppJDZwOhrTAEPIEGFSh2q0Hl
        8ee4cltAjUC0YuLwg1w4bp0VfXU56DfiC1NgLGhMXT5vWK2ZEjIR3uWiWb7TpkQcT6PvU/fs9D+Dz
        BDng9AFf7Sm2UKMIQpsxhIzOKNBYht/DohFPpM74sUVaOn/FNWyogSnQbEtd5OlJyyRfz9pMcPqy0
        hQOaajve6N/q3TFhpHf97RAKdTKtUFSuglPgjF6LgxoWLzHErasgkpa6Br5vxYgMUbqzsDZXL+mXK
        0LOopptw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHlzu-008IJM-OU; Sun, 22 Aug 2021 12:50:42 +0100
Date:   Sun, 22 Aug 2021 12:50:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Grzegorz =?utf-8?Q?Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xtables-addons 3.18 condition - Improved network
 namespace support
Message-ID: <YSI6ESSy9ScNsuWE@azazel.net>
References: <a2e36a8e-939f-453d-8a0d-d6ef61bbf280@interia.eu>
 <7q54s2p2-7o57-3rq-9012-np5o3sr1s416@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r+Ek3gfXheMmYmeP"
Content-Disposition: inline
In-Reply-To: <7q54s2p2-7o57-3rq-9012-np5o3sr1s416@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--r+Ek3gfXheMmYmeP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-08-22, at 13:19:46 +0200, Jan Engelhardt wrote:
> On Friday 2021-08-20 20:24, Grzegorz Kuczy=C5=84ski wrote:
> > A few years ago I add network namespace to extension condition.
> > I review this changes again and make changes again.
> > This is better version.
>
> It does not apply. Your mail software mangled the patch.
>
> I would also wish for a more precise description what causes
> these lines to need removal.
>
> >-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cnet->after_clear)
> >-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return;
>
> >-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (--var->refcount =3D=3D 0) {
> >+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (--var->refcount =3D=3D 0 && !l=
ist_empty_careful(&cnet->conditions_list)) {

I've been looking at this, and I don't think it works.

The idea is to do away with a separate flag whose purpose is to indicate
that condition_mt_destroy is being called during the tear-down of a
name-space.

Currently we have:

  static void __net_exit condition_net_exit(struct net *net)
  {
    struct condition_net *condition_net =3D condition_pernet(net);
    struct list_head *pos, *q;
    struct condition_variable *var =3D NULL;

    remove_proc_subtree(dir_name, net->proc_net);
    mutex_lock(&proc_lock);
    list_for_each_safe(pos, q, &condition_net->conditions_list) {
      var =3D list_entry(pos, struct condition_variable, list);
      list_del(pos);
      kfree(var);
    }
    mutex_unlock(&proc_lock);
    condition_net->after_clear =3D true;
  }

and:

  static void condition_mt_destroy(const struct xt_mtdtor_param *par)
  {
    const struct xt_condition_mtinfo *info =3D par->matchinfo;
    struct condition_variable *var =3D info->condvar;
    struct condition_net *cnet =3D condition_pernet(par->net);

    if (cnet->after_clear)
      return;

    mutex_lock(&proc_lock);
    if (--var->refcount =3D=3D 0) {
      list_del(&var->list);
      remove_proc_entry(var->name, cnet->proc_net_condition);
      mutex_unlock(&proc_lock);
      kfree(var);
      return;
    }
    mutex_unlock(&proc_lock);
  }

Since pernet_operations destructors are called in the reverse of the
order in which they are registered, the destructor for xt_condition will
be called before the destructor for the table which deletes all the
rules.  The `after_clear` flag serves to indicate during the call of
condition_mt_destroy that condition_net_exit has already been called and
freed all the variables.  Replacing it with a check whether list of
variables is empty could work, but not after we've checked the ref-count
of a variable that we have already freed.  Based on what I've seen in
other modules, I'd be more inclined to do something like this:

  static void __net_exit condition_net_exit(struct net *net)
  {
    struct condition_net *condition_net =3D condition_pernet(net);

    remove_proc_subtree(dir_name, net->proc_net);
    condition_net->proc_net_condition =3D NULL;
  }

and:

  static void condition_mt_destroy(const struct xt_mtdtor_param *par)
  {
    const struct xt_condition_mtinfo *info =3D par->matchinfo;
    struct condition_variable *var =3D info->condvar;
    struct condition_net *cnet =3D condition_pernet(par->net);

    mutex_lock(&proc_lock);
    if (--var->refcount =3D=3D 0) {
      list_del(&var->list);
      if (condition_net->proc_net_condition)
        remove_proc_entry(var->name, cnet->proc_net_condition);
      kfree(var);
    }
    mutex_unlock(&proc_lock);
  }

J.

--r+Ek3gfXheMmYmeP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEiOhEACgkQKYasCr3x
BA2szg/9EMNRnj6zegs8CI23HcC2DJEOHzrnsPuzioM/lYSJw3ibld9PCxQiEyl+
FcnY+cGk+Hwdh74pO71JvCREPlwsMYUADszXy/ng3qwX5aDz8OqsXzJqyLLhYnEx
h0S36IOIev6NfhDVWMEak7uRcWGokNfN95/uIDnxqHkhMFOXt2ZETbLVLGwUovvs
6eDcZUq4YgcNI900fXW53VDQ5erjaJZv8FdryeS9dy71Lug2BAi2815tPaoKxM/Z
XqE6WyDCGF7+xDOwNjtIC1D8+FfEACcE7Qf+ECu0qOcjzNBG+XgdpEPSIqJBL55l
hu5egr+iiCnp+cSZTjrWgpHOpibEi/76WTJABvYd1wuTMDejNcy8WbfUNYADD8VY
TQ3XqX84oLnYYq09OeVuV7U52YkiD7B9q/VoTSEPeK1hHrJT3ufBpaZeDO3OaQpE
QHVKRvlLSRaAYn/36DcOaBmz3wHK5zNMlkGnDvWcShx9iFRu37kyJSjFWDQwTI3W
MHX9FgH2s5BKP+fAz0mU9ZBmXJY18r5qYNiIDManMf7M4+qPzKXR+OwE3yI1Sd7Y
waGuo2WYupIdDFTTIo2a/6Wl/qySORko1lvStu3qeWMVzHZ94pBBO60j3joe8nx+
kz9juAbx6s1b+CDqW3gypJOPzU3wMuj12dGBVeoSO6ewkAf8Ak8=
=w4m2
-----END PGP SIGNATURE-----

--r+Ek3gfXheMmYmeP--
