Return-Path: <SRS0=x4zc=76=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871BDC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 19:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3736D212CC
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 19:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="FPcWgjMx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgFQTMY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 15:12:24 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:38953 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQTMX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 15:12:23 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 15:12:23 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 13F8367400F5;
        Wed, 17 Jun 2020 21:07:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1592420817; x=1594235218; bh=NqAWAZX19l
        97L7STgyElQleVfxMALy3GAIls32zqY9I=; b=FPcWgjMxjioQHQmjEHcxYlWg95
        13Nm2lChCk8gkj1PpM5ppKpMkM7LfKWw1W/giXUoQTu4h5j2nWC8Y8ODdnc5GjvY
        CZUOkGqZSobOIJmGHo+hIFhPgFG65wCwyGtL8isyXEosNq2VZ3QzC4sCEa/HsOTU
        +elajdH5ogCNqRdBs=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 17 Jun 2020 21:06:57 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id C3F4767400F2;
        Wed, 17 Jun 2020 21:06:57 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 91BCC20DFA; Wed, 17 Jun 2020 21:06:57 +0200 (CEST)
Date:   Wed, 17 Jun 2020 21:06:57 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ipset restore for bitmap:port terrible slow
In-Reply-To: <ffe689dd-63d8-1b8f-42f2-20c875d124b6@thelounge.net>
Message-ID: <alpine.DEB.2.22.394.2006172102360.27120@blackhole.kfki.hu>
References: <ffe689dd-63d8-1b8f-42f2-20c875d124b6@thelounge.net>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-538369666-1592420817=:27120"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-538369666-1592420817=:27120
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Wed, 17 Jun 2020, Reindl Harald wrote:

> the restore of a "bitmap:port" ipset with a lot of entries is *terrible*=
=20
> slow, when you add a port-range like 42000=E2=80=9342999 it ends in 999 "=
add=20
> PORTS_RESTRICTED" lines in the save-file and restore takes virtually=20
> ages
>=20
> the cpu-time below is the whole systemd-unit which restores iptables,=20
> ipset and configures the network with 3 nics, a bridge and wireguard
>=20
> why is this *that much* inefficient given that the original command with
> port ranges returns instantly?
>=20
> on a datacenter firewall that makes the difference of 5 seconds or 15
> seconds downtime at reboot
> ---------------------------
>=20
> Name: PORTS_RESTRICTED
> Type: bitmap:port
> Header: range 1-55000
>=20
> ---------------------------
>=20
> /usr/sbin/ipset -file /etc/sysconfig/ipset restore
>=20
> CPU: 9.594s - Number of entries: 5192
> CPU: 6.246s - Number of entries: 3192
> CPU: 1.511s - Number of entries: 53
>=20
> ---------------------------

I cannot reproduce the issue. What is your ipset version (both userspace=20
tool and kernel modules)?
=20
> 42000=E2=80=9342999 looks in /etc/sysconfig/ipset like below and frankly =
either
> that can be speeded up or should be saved as ranges wherever it's
> possible like hash:net prefers cidr

The bitmap port type does not support ranges, just individual port=20
elements.=20

In my test restoring a set with 10000 elements took less than 1s.

Best regars,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-538369666-1592420817=:27120--
