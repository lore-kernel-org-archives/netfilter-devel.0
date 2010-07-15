From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: nfnetlink_queue: add definition of	aligned_be64
 for user-space apps
Date: Thu, 15 Jul 2010 11:19:35 +0200
Message-ID: <4C3ED2A7.1090300@trash.net>
References: <20100712165241.4026.83949.stgit@decadence> <20100712170019.4026.55069.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40016 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0GOJTh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:19:37 -0400
In-Reply-To: <20100712170019.4026.55069.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 12.07.2010 19:00, schrieb Pablo Neira Ayuso:
> Currently, libnl and libnetfilter_queue include in one of their
> user-space header files an ad-hoc definition of aligned_be64.
> However, applications that use the BSD socket API to communicate
> via Netlink sockets (ie. those that do not use these libraries)
> would need to define this type by hand if they include the
> kernel-space header nfnetlink_queue.h.
>=20
> This patch adds the definition of aligned_bed64 for user-space
> applications in the kernel header. Otherwise, they have to define
> it to avoid the following compilation problem:
>=20
> /usr/include/linux/netfilter/nfnetlink_queue.h:28: error: expected sp=
ecifier-qualifier-list before =E2=80=98aligned_be64=E2=80=99

Why can't these applications simply include linux/types.h?

> I know, this is ugly but I think that user-space Netlink applications
> should compile with the only need of including the kernel-space
> header that contains the protocol definitions.

I disagree, it makes no sense to re-define this for every header file.
They can either include linux/types.h, or we could automatically includ=
e
it in the files requiring it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
