From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter 01/06: Move linux/in.h and linux/in6.h inclusions
 outside of
Date: Mon, 18 Aug 2008 12:57:13 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808181253010.3180@fbirervta.pbzchgretzou.qr>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain> <20080818165149.18978.80469.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51078 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYHRQ5O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:57:14 -0400
In-Reply-To: <20080818165149.18978.80469.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-08-18 12:51, Patrick McHardy wrote:

>netfilter: Move linux/in.h and linux/in6.h inclusions outside of #ifde=
f __KERNEL__
>
>netfilter.h can't be used in userspace without including linux/in.h
>and linux/in6.h first. netfilter.h includes its own linux/in.h and
>linux/in6.h include statements, these are stripped by make
>headers-install because they are inside #ifdef __KERNEL__ however.
>Move them out to fix this.

Humm - no, I do not think this is right.


$ cat test2.c=20
#include <netinet/in.h>

/* simulate netfilter.h as proposed */
#include <linux/in.h>
struct nf_inet_addr {
        struct in_addr inet4;
};
/* end simul */

int main(void)
{
}

yields:

In file included from test2.c:2:
/usr/include/linux/in.h:26: error: redeclaration of enumerator =E2=80=98=
IPPROTO_IP=E2=80=99
/usr/include/netinet/in.h:34: error: previous definition of =E2=80=98IP=
PROTO_IP=E2=80=99 was
/here
[...many more...]


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
