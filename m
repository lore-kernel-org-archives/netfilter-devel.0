Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0E2C433ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Apr 2021 15:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA30601FD
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Apr 2021 15:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhDWPzY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 11:55:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:49608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231445AbhDWPzV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 11:55:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619193284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=l4gb+WUBpaPLz6C2Ib3LLhenZONdMk4LISwnpYDVs4E=;
        b=ThH7yUAmu6rFMpaVpRkBxOSV7HKmab0kJuX95p2kjh+vvplamvACDG+ZN3Fdg8g20cs2Cc
        KtG/BkhFlNp2sVQOaH+L9s3Ju+6dPHOpQPH68iocQgmA0rmd0CRShd4Fjbyjyusj1/SMcp
        IQ4SftauM1sD6pLftrba8U/UKcixB/g=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2907BB140
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Apr 2021 15:54:44 +0000 (UTC)
Date:   Fri, 23 Apr 2021 17:54:43 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: RSTs being marked as invalid because of wrong td_maxack value
Message-ID: <20210423155443.fmlbssgi6pq7nfp4@Fryzen495>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="thyjxneyzhrnuxo6"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--thyjxneyzhrnuxo6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greetings,

We are seeing the following situation, on an established connection:

1: 2049 =E2=86=92 703 [RST, ACK] Seq=3D1202969688 Ack=3D1132949130
2: [TCP Port numbers reused] 703 =E2=86=92 2049 [SYN] Seq=3D1433611541
3: [TCP Out-Of-Order] 703 =E2=86=92 2049 [PSH, ACK] Seq=3D1132949130 Ack=3D=
1202969688
4: 2049 =E2=86=92 703 [RST, ACK] Seq=3D0 Ack=3D1433611542

The RST in 4 is dropped, printing out the td_maxack value, it turns out
to be:

nf_ct_tcp: invalid RST seq:0 td_maxack:1202969688 SRC=3D10.78.206.110
DST=3D10.78.202.146 LEN=3D40 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D43722 DF =
PROTO=3DTCP
SPT=3D2049 DPT=3D703 SEQ=3D0 ACK=3D1433611542 WINDOW=3D0 RES=3D0x00 ACK RST=
 URGP=3D0

So basically the SYN in 2 resets the IP_CT_TCP_FLAG_MAXACK_SET, while
the out of order frame 3 resets it back, and we end up having again
td_maxack=3D1202969688, that is compared against Seq=3D0 and the RST is dro=
pped.

While we are still testing a proper fix, we would like to have the RST
check introduced in [1] tunable. I can send a patch to add a proc bit
for that, but I'm wondering whether or not to re-use the tcp_be_liberal
option. Please let me know which option would work best for you.

Thanks in advance.

[1] https://patchwork.ozlabs.org/project/netdev/patch/20090527143523.4649.9=
1602.sendpatchset@x2.localnet/

--=20
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5


--thyjxneyzhrnuxo6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEUaD0oMjPyY+ELqmouUVW+ByF0NUFAmCC7cAACgkQuUVW+ByF
0NU+iBAAgHYHqyWS0Yw76uYsrBO9K9eZjGP8+gqnNfZ8xQ8pq/QjnrUJuirAV4u1
nXWkKINQNpV3YoI0DKJCdicch/eVxDy7mcsF4SFo57gtLGnf3EDHfXNUw4Im+33k
rmyzw4q4Uf6bpqpBI1W0ir9DB8BKv/+xLKZAeLfkrgsEhySOUTSR/ct9RJyV+L8w
IGzE7ZeVyoeH4RX76sQ7ic7/fj4Ff3lHEL72AVRvou45Sy1eSbl89tQHnFqlb2Ty
GN8uJe7jeZAvBgMIRlm0l28Wy8e075Po6l2zSN7Vnlzqxl738/mgHTh1BCBhSIm5
ilbYEeWS+zLlbEyHpA8wVKzu0dyzlU4SiWpuiYvgUAmuuS4rp4ZUat58eNw0yFOB
LRiSEnahVDqIMrImPtkiFFfo5PUulf1yR3Zos/WtEfTBMPVl9Ld6wGWKa0s1VW5X
eWlYWC2dxPXQsvagOA0xZwlmSQU8dfGWSG/dgf7G6+f+EAaUoXoghzzk5Y+XQaqS
IDonjmNskebVoNsBLav2ORJLNIO6Gvw7j8AZt4y2F0Fq/KerZ/Z0QOmtpR6fwYzI
GEyQhsfxj6VGxT1RwQEVX0LqiY2w7FKMVdMHh3gNVEltqu1pRyXWMHs8ZRN3dj7a
R2n0FedtozARRGDB5xExVgaG3/E/CzG28iDtNvAKLTNyye5P0es=
=bC3h
-----END PGP SIGNATURE-----

--thyjxneyzhrnuxo6--
