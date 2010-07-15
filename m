From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: nfnetlink_queue: add definition of	aligned_be64
 for user-space apps
Date: Thu, 15 Jul 2010 13:59:21 +0200
Message-ID: <4C3EF819.8080801@netfilter.org>
References: <20100712165241.4026.83949.stgit@decadence> <20100712170019.4026.55069.stgit@decadence> <4C3ED2A7.1090300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38142 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758410Ab0GOL70 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 07:59:26 -0400
In-Reply-To: <4C3ED2A7.1090300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15/07/10 11:19, Patrick McHardy wrote:
> Am 12.07.2010 19:00, schrieb Pablo Neira Ayuso:
>> Currently, libnl and libnetfilter_queue include in one of their
>> user-space header files an ad-hoc definition of aligned_be64.
>> However, applications that use the BSD socket API to communicate
>> via Netlink sockets (ie. those that do not use these libraries)
>> would need to define this type by hand if they include the
>> kernel-space header nfnetlink_queue.h.
>>
>> This patch adds the definition of aligned_bed64 for user-space
>> applications in the kernel header. Otherwise, they have to define
>> it to avoid the following compilation problem:
>>
>> /usr/include/linux/netfilter/nfnetlink_queue.h:28: error: expected s=
pecifier-qualifier-list before =E2=80=98aligned_be64=E2=80=99
>=20
> Why can't these applications simply include linux/types.h?

Including it doesn't fix the problem here:

#include <linux/types.h>
#include <linux/netfilter/nfnetlink_queue.h>

I still get:

/usr/include/linux/netfilter/nfnetlink_queue.h:28: error: expected
specifier-qualifier-list before =E2=80=98aligned_be64=E2=80=99

aligned_be64 is only define in the kernel (it's included under the
__KERNEL__ definition).

>> I know, this is ugly but I think that user-space Netlink application=
s
>> should compile with the only need of including the kernel-space
>> header that contains the protocol definitions.
>=20
> I disagree, it makes no sense to re-define this for every header file=
=2E
> They can either include linux/types.h, or we could automatically incl=
ude
> it in the files requiring it.

This is how it looks now in user-space:

#include <...>
#ifndef aligned_be64
#define aligned_be64 u_int64_t __attribute__((aligned(8)))
#endif
#include <linux/netfilter/nfnetlink_queue.h>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
