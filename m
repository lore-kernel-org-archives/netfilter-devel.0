Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF34C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 23:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505A823BA7
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 23:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404371AbgLJWb3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 17:31:29 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:37149 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405142AbgLJW2Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 17:28:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id E108F67401BE;
        Thu, 10 Dec 2020 23:19:21 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 10 Dec 2020 23:19:19 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 9C03767401BB;
        Thu, 10 Dec 2020 23:19:19 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 70B21340D5D; Thu, 10 Dec 2020 23:19:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 6C4E8340D5C;
        Thu, 10 Dec 2020 23:19:19 +0100 (CET)
Date:   Thu, 10 Dec 2020 23:19:19 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Ed W <lists@wildgooses.com>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: ipset 7.9 compilation fix on kernel 4.14
In-Reply-To: <701adbbb-202a-4ee4-ce2e-ecaaed6dc3b5@wildgooses.com>
Message-ID: <alpine.DEB.2.23.453.2012102309430.14614@blackhole.kfki.hu>
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu> <c4778467-3abe-b40f-c4f7-945576fa097f@wildgooses.com> <alpine.DEB.2.23.453.2012071419590.30865@blackhole.kfki.hu> <701adbbb-202a-4ee4-ce2e-ecaaed6dc3b5@wildgooses.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-271306815-1607638759=:14614"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-271306815-1607638759=:14614
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 10 Dec 2020, Ed W wrote:

> There remains a compile warning, just wanted to bring to your attention=
:
>=20
> /var/tmp/portage/net-firewall/ipset-7.9/work/ipset-7.9/kernel/net/netfi=
lter/ips
> et/ip_set_core.c: In function 'ip_set_rename':
> /var/tmp/portage/net-firewall/ipset-7.9/work/ipset-7.9/kernel/net/netfi=
lter/ips
> et/ip_set_core.c:1359:2: warning: 'strncpy' specified bound 32 equals
> destination size [-Wstringop-truncation]
> =C2=A01359 |=C2=A0 strncpy(set->name, name2, IPSET_MAXNAMELEN);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
> =C2=A0 LD [M]=C2=A0/var/tmp/portage/net-firewall/ipset-7.9/work/ipset-7=
.9/kernel/net/netfilter/ips
> et/ip_set.o

That's a false warning: name2 comes from a netlink attribute which size=20
is limited to IPSET_MAXNAMELEN-1, including NUL. The compiler can't figur=
e=20
it out though.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-271306815-1607638759=:14614--
