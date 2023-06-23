Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AC9EB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jun 2023 18:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjFWSbC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jun 2023 14:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjFWSbB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2023 14:31:01 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DF22705
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2023 11:30:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id A0ABA67400EA;
        Fri, 23 Jun 2023 20:30:45 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 23 Jun 2023 20:30:43 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (host-94-248-211-167.kabelnet.hu [94.248.211.167])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 3029067400E2;
        Fri, 23 Jun 2023 20:30:41 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id C1CCD8E4; Fri, 23 Jun 2023 20:30:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mentat.rmki.kfki.hu (Postfix) with ESMTP id B6A29754;
        Fri, 23 Jun 2023 20:30:40 +0200 (CEST)
Date:   Fri, 23 Jun 2023 20:30:40 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: ipset hash:net:port:net
In-Reply-To: <CAEmTpZGTbHcd84vA5VL6FfDc8+n+E0VMt+GpPkVLw5Vijp5iLA@mail.gmail.com>
Message-ID: <4d4b3ca0-e994-3f29-e5da-a828d6a1c13@netfilter.org>
References: <CAEmTpZGTbHcd84vA5VL6FfDc8+n+E0VMt+GpPkVLw5Vijp5iLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1393428146-1108618937-1687545040=:7658"
X-deepspam: maybeham 7%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1393428146-1108618937-1687545040=:7658
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, 22 Jun 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=
=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:

> 1. In the latest ipset, adding "1.2.3.4/0,tcp:0,1.2.3.0/24" is not
> allowed. I would like it to be allowed. It should match on any TCP
> traffic that matches source and destination.
> 2. The same for protocol number 0. I want  "1.2.3.4/0,0:0,1.2.3.0/24"
> to match all traffic that matches source and destination.
>=20
> These requirements come from the real cases, where an administrator add=
s=20
> rules to control access to his networks.
>=20
> Is it possible to make such changes? TCP port 0 is not real thing, as=20
> well as IP protocol 0. So we can give them special meaning in IPSets.
>=20
> although icmp:0 is not so clear in this case. Possibly allow to set -1 =
?=20
> as protocol or port for matching any ?

Sorry, no. It could ony be implemented with the price of doubling the=20
lookup time in the set.

Why don't you simply use a hash:net,net type of set?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--1393428146-1108618937-1687545040=:7658--
