Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D878C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 21:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiCOVZZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 17:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbiCOVZZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 17:25:25 -0400
X-Greylist: delayed 487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Mar 2022 14:24:10 PDT
Received: from st43p00im-ztfb10071701.me.com (st43p00im-ztfb10071701.me.com [17.58.63.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332DF5B3F8
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 14:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=sig1; t=1647378961;
        bh=BWCoKHSIQElQuZlEKDCIBnkuh2EL3qQfUYhTM2o2kes=;
        h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To;
        b=qKf3uNqW/E8UWAXK/UMpYBUfrYvyTj49x2WU2EAmcIlPjW3Q7j6yVkrVPgBfIBE/O
         FJQTCkzZqzEHQIc1RsB6flTkYXkWuR125+dHSHsEjpBnLUKmXBvjBr+PTPNsxc4rKZ
         yCGphLzdqxWsH0iFIjrwoNgeDQaochWU4RhX5H1v/QzTh+igmSAXUcsCxM34JkoXwK
         9L3bbYbjQwdVZDRpt15EUGm4jXyoCUDhrhA/X8JxpyeU+7Sn4MtY3SS1J09EgMO7Ct
         atleya2NY/DOfkzJfkigeJdEBGP2eTu40WAt39yktZx1elWuaWpfOw3iStlpZXhjTh
         6bIEslxNSKhaQ==
Received: from smtpclient.apple (st43p00im-dlb-asmtp-mailmevip.me.com [17.42.251.41])
        by st43p00im-ztfb10071701.me.com (Postfix) with ESMTPSA id C0AB0A0B22
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 21:16:00 +0000 (UTC)
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_42091E2D-686C-4F4D-A7B5-F95199096DE6";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Feature Request: nft: support non-immediate second operand
Message-Id: <5893CB79-E204-42CA-98A1-7D3C2FCCE532@darbyshire-bryant.me.uk>
Date:   Tue, 15 Mar 2022 21:15:58 +0000
To:     netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 clxscore=1030 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=767 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2203150125
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Apple-Mail=_42091E2D-686C-4F4D-A7B5-F95199096DE6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi there,

I=E2=80=99m trying to migrate to using nftables and hitting some good =
things but also a bad thing.  I have a firewall that makes use of =
conntrack marks that get bit-wise manipulated by iptables.  I don=E2=80=99=
t appear to be able to get the same functionality in nftables.  eg:


The following stores the DSCP into the conntrack mark and sets another =
bit as a flag.  Unfortunately it destroys any prior value stored in say =
the upper 16 bits.

meta nfproto ipv4 ct mark set @nh,8,6 or 0x200 counter

What I=E2=80=99d like to do instead is something more like:

meta nfproto ipv4 ct mark set ct mark or @nh,8,6 ct mark set ct mark or =
0x200 counter


Thanks for your time.


Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_42091E2D-686C-4F4D-A7B5-F95199096DE6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAmIxAg4ACgkQs6I4m53i
M0oC1A//eKsCFPBERYDr6J0XUaJnt+5kYGOFnS748YFfWNXulGMqJJzi13Ius4q2
T57ImUzKV1xKKwjcNIBtXMKwZDjNmxK4YkO+puaDGJPFDj2Xjyps0hPeXZdlxZb8
zbjcauScCmtzqcud2aeBnqLI9cd0YoNpumWhHnQV7V2PYWhYFliI1qSFvlVb0yBR
GSAPIF8bb1AcC8bXUjwX+2LqSOBtnzy7jpfC3d0brl2EE1qyIgjbthLNi4P+wC6z
csDYC10qx9JDf3qV12AKbowXg2eGN7kC/zS1JOSQN4lKfV8Y9dR9oWtEd2dV1gcq
W4377NLTV724Ar49aOc5ky/m4qd4+IypZFBmK8eFup4ENMvs/ozMaqoAK/iRd2IF
8jtWzgLkAOh4kPX6laFL4ob7KZYPMl9DBvoYY76fYD2XqRI8BQDGRsqTQMdK/fJF
FvpVtQomCdk4xAPDQPU/tzNRnlE6oNNA73GRo/9cJa39erswNm0pi6n/8LHVSysm
bextsb1HwJYJvLLHjBFWDOCtH/AzbPoThoxj8TkRZdIgRRpxP5rOH8B8PmJdhj6V
U1hepwdDONfwvbtobOMJ4Zm3ZRs/CEFd9UEO7QT2XH4uWlAB/5jH6NQdwk3qdq7v
n8trevX0qRH87+HGFEInJrhYsbCruOASCsndkMc7EGAovBWRDGA=
=TdA4
-----END PGP SIGNATURE-----

--Apple-Mail=_42091E2D-686C-4F4D-A7B5-F95199096DE6--
