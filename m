Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13C2C38145
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Sep 2022 15:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiIBPH5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Sep 2022 11:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbiIBPHe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2022 11:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320B51616AD
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2022 07:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662129348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rQy3yK1lRR3g9jlxl2BAePcE/UJ+buGU4pZ/9O362tI=;
        b=GanjJcGSPaKsc4+yVaX5N7Mks+iaQaUoxFK3XY7YbO5wcFccstdL7yFlR1IL7o4V4gnlOn
        izJlPfSRNNHXaWHkZZd/6UFOcAdnwhC8/E6R7jIg29n9K21lslQqE8HeJ2adQ1Dih6aIfd
        6PGrQ+t7JausaiTPZNW8q3KdyFVNCNU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-Mh_g_gvGP2KIvw8hWCk1hg-1; Fri, 02 Sep 2022 10:35:47 -0400
X-MC-Unique: Mh_g_gvGP2KIvw8hWCk1hg-1
Received: by mail-ed1-f71.google.com with SMTP id m18-20020a056402511200b0044862412596so1533513edd.3
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Sep 2022 07:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rQy3yK1lRR3g9jlxl2BAePcE/UJ+buGU4pZ/9O362tI=;
        b=XJqxW17KbU6AqGhpWyGd09sz3HBC6XAwECwnnuxTLuscay08Gd7DvpWjEiJF6HRfeh
         m0O2mhcF88JkVpHp+Zt9PyjK0EkQEN/bdQuMIsshDCfrddmUO7eqnqvGV8OnRcTkT6ve
         Hziszuixkl30dVJtu2MdC6Cv1A+kLbMJmbFDuiPUsqKwfcrU5DnVzQnR7w/JcA0pa9WU
         yi/So3GYNKM25D6qB0zQO27s+8D9x4LPOalSZXVzpWlcDuvk1VW8ZZYeJawRaOJzjnJG
         kEjsaXtKCekYF98M/Vu00K7WPB7f/lWVa/LnkHMp5Tq8z5Fu0/e05CznaB/g0QPTAlUG
         gKQg==
X-Gm-Message-State: ACgBeo138dP7mA1nlrT6cwN/5JEkYzIGGYK1oROsIbYNkt/3HZJg7d7D
        6od3C19c3TkxhUxgWQ4B9gbgIi0V+xizsxpgLzcjN9XCL/9sbcqWQNXKAPqXyIYTf72trwND+bn
        b4yhBrHvD5oKG8oGc8OAe8aAFs4f1
X-Received: by 2002:a05:6402:3714:b0:445:d91b:b0aa with SMTP id ek20-20020a056402371400b00445d91bb0aamr32057399edb.313.1662129346049;
        Fri, 02 Sep 2022 07:35:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7YezHUCI5TCIZeHPJc6VvezJkhFWBlWGHL+t6CMw/agujoYPKl4Rr8ZBoGEQNhy7FkSVgboA==
X-Received: by 2002:a05:6402:3714:b0:445:d91b:b0aa with SMTP id ek20-20020a056402371400b00445d91bb0aamr32057370edb.313.1662129345774;
        Fri, 02 Sep 2022 07:35:45 -0700 (PDT)
Received: from localhost (net-93-71-3-16.cust.vodafonedsl.it. [93.71.3.16])
        by smtp.gmail.com with ESMTPSA id r13-20020a056402034d00b00447c89a63f4sm1562865edw.35.2022.09.02.07.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 07:35:45 -0700 (PDT)
Date:   Fri, 2 Sep 2022 16:35:43 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, brouer@redhat.com,
        toke@redhat.com, memxor@gmail.com
Subject: Re: [PATCH bpf-next 0/4] Introduce bpf_ct_set_nat_info kfunc helper
Message-ID: <YxIUvxY8S256TTUf@lore-desk>
References: <cover.1662050126.git.lorenzo@kernel.org>
 <aec3e8d1-6b80-c344-febe-809bbb0308eb@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kc5vxWvF7S0yYZdP"
Content-Disposition: inline
In-Reply-To: <aec3e8d1-6b80-c344-febe-809bbb0308eb@iogearbox.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--kc5vxWvF7S0yYZdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sep 02, Daniel Borkmann wrote:
> On 9/1/22 6:43 PM, Lorenzo Bianconi wrote:
> > Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> > destination nat addresses/ports in a new allocated ct entry not inserted
> > in the connection tracking table yet.
> > Introduce support for per-parameter trusted args.
> >=20
> > Kumar Kartikeya Dwivedi (2):
> >    bpf: Add support for per-parameter trusted args
> >    selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation
> >=20
> > Lorenzo Bianconi (2):
> >    net: netfilter: add bpf_ct_set_nat_info kfunc helper
> >    selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
> >=20
> >   Documentation/bpf/kfuncs.rst                  | 18 +++++++
> >   kernel/bpf/btf.c                              | 39 ++++++++++-----
> >   net/bpf/test_run.c                            |  9 +++-
> >   net/netfilter/nf_conntrack_bpf.c              | 49 ++++++++++++++++++-
> >   .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
> >   .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++-
> >   tools/testing/selftests/bpf/verifier/calls.c  | 38 +++++++++++---
> >   7 files changed, 156 insertions(+), 25 deletions(-)
> >=20
>=20
> Looks like this fails BPF CI, ptal:
>=20
> https://github.com/kernel-patches/bpf/runs/8147936670?check_suite_focus=
=3Dtrue

Hi Daniel,

it seems CONFIG_NF_NAT is not set in the kernel config file.
Am I supposed to enable it in bpf-next/tools/testing/selftests/bpf/config?

Regards,
Lorenzo

>=20
> [...]
>   All error logs:
>   test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
>   test_bpf_nf_ct:PASS:iptables 0 nsec
>   test_bpf_nf_ct:PASS:start_server 0 nsec
>   connect_to_server:PASS:socket 0 nsec
>   connect_to_server:PASS:connect_fd_to_fd 0 nsec
>   test_bpf_nf_ct:PASS:connect_to_server 0 nsec
>   test_bpf_nf_ct:PASS:accept 0 nsec
>   test_bpf_nf_ct:PASS:sockaddr len 0 nsec
>   test_bpf_nf_ct:PASS:bpf_prog_test_run 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for NULL bpf_tuple 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for reserved not set to 0 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for netns_id < -1 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for len__opts !=3D NF_BPF_CT_OPTS_SZ 0 =
nsec
>   test_bpf_nf_ct:PASS:Test EPROTO for l4proto !=3D TCP or UDP 0 nsec
>   test_bpf_nf_ct:PASS:Test ENONET for bad but valid netns_id 0 nsec
>   test_bpf_nf_ct:PASS:Test ENOENT for failed lookup 0 nsec
>   test_bpf_nf_ct:PASS:Test EAFNOSUPPORT for invalid len__tuple 0 nsec
>   test_bpf_nf_ct:PASS:Test for alloc new entry 0 nsec
>   test_bpf_nf_ct:PASS:Test for insert new entry 0 nsec
>   test_bpf_nf_ct:PASS:Test for successful lookup 0 nsec
>   test_bpf_nf_ct:PASS:Test for min ct timeout update 0 nsec
>   test_bpf_nf_ct:PASS:Test for max ct timeout update 0 nsec
>   test_bpf_nf_ct:PASS:Test for ct status update  0 nsec
>   test_bpf_nf_ct:PASS:Test existing connection lookup 0 nsec
>   test_bpf_nf_ct:PASS:Test existing connection lookup ctmark 0 nsec
>   test_bpf_nf_ct:FAIL:Test for source natting unexpected Test for source =
natting: actual -22 !=3D expected 0
>   test_bpf_nf_ct:FAIL:Test for destination natting unexpected Test for de=
stination natting: actual -22 !=3D expected 0
>   #16/1    bpf_nf/xdp-ct:FAIL
>   test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
>   test_bpf_nf_ct:PASS:iptables 0 nsec
>   test_bpf_nf_ct:PASS:start_server 0 nsec
>   connect_to_server:PASS:socket 0 nsec
>   connect_to_server:PASS:connect_fd_to_fd 0 nsec
>   test_bpf_nf_ct:PASS:connect_to_server 0 nsec
>   test_bpf_nf_ct:PASS:accept 0 nsec
>   test_bpf_nf_ct:PASS:sockaddr len 0 nsec
>   test_bpf_nf_ct:PASS:bpf_prog_test_run 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for NULL bpf_tuple 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for reserved not set to 0 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for netns_id < -1 0 nsec
>   test_bpf_nf_ct:PASS:Test EINVAL for len__opts !=3D NF_BPF_CT_OPTS_SZ 0 =
nsec
>   test_bpf_nf_ct:PASS:Test EPROTO for l4proto !=3D TCP or UDP 0 nsec
>   test_bpf_nf_ct:PASS:Test ENONET for bad but valid netns_id 0 nsec
>   test_bpf_nf_ct:PASS:Test ENOENT for failed lookup 0 nsec
>   test_bpf_nf_ct:PASS:Test EAFNOSUPPORT for invalid len__tuple 0 nsec
>   test_bpf_nf_ct:PASS:Test for alloc new entry 0 nsec
>   test_bpf_nf_ct:PASS:Test for insert new entry 0 nsec
>   test_bpf_nf_ct:PASS:Test for successful lookup 0 nsec
>   test_bpf_nf_ct:PASS:Test for min ct timeout update 0 nsec
>   test_bpf_nf_ct:PASS:Test for max ct timeout update 0 nsec
>   test_bpf_nf_ct:PASS:Test for ct status update  0 nsec
>   test_bpf_nf_ct:PASS:Test existing connection lookup 0 nsec
>   test_bpf_nf_ct:PASS:Test existing connection lookup ctmark 0 nsec
>   test_bpf_nf_ct:FAIL:Test for source natting unexpected Test for source =
natting: actual -22 !=3D expected 0
>   test_bpf_nf_ct:FAIL:Test for destination natting unexpected Test for de=
stination natting: actual -22 !=3D expected 0
>   #16/2    bpf_nf/tc-bpf-ct:FAIL
>   #16      bpf_nf:FAIL
> [...]
>=20

--kc5vxWvF7S0yYZdP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYxIUvwAKCRA6cBh0uS2t
rBOmAQDNQplnGz8wNNOJ7l4QtQuCiYHNhZnV7tGcZqzkS/GcywEA5UHn3ORhVyzT
V7XdOgqTJfr1bRLtSE1gSr4anjAZsgY=
=qZ9v
-----END PGP SIGNATURE-----

--kc5vxWvF7S0yYZdP--

