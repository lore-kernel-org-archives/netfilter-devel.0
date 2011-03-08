From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter:ipset: fix the compile warning in ip_set_create
Date: Tue, 08 Mar 2011 15:38:11 +0100
Message-ID: <4D763F53.3010109@trash.net>
References: <4D70960B.2040209@cn.fujitsu.com> <alpine.DEB.2.00.1103040956050.29227@blackhole.kfki.hu> <4D70CC89.5020604@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59744 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab1CHOiP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:38:15 -0500
In-Reply-To: <4D70CC89.5020604@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 04.03.2011 12:27, schrieb Shan Wei:
>> > Thanks, I applied your patch in my tree.
>> >=20
>> > Patrick, please apply it too.
>> >=20
>> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>> >=20
> Thanks for your review.
> Bad sob in first patch, fix it in new one.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [PATCH v2] netfilter:ipset: fix the compile warning in ip_set_create
>=20
> net/netfilter/ipset/ip_set_core.c:615: warning: =E2=80=98clash=E2=80=99=
 may be used uninitialized in this function
>=20
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
