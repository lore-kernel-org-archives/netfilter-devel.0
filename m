From: Arif Hossain <aftnix@gmail.com>
Subject: ipv6 address comparison
Date: Sat, 21 Jul 2012 18:09:26 +0600
Message-ID: <1342872161.3431.13.camel__33843.7770879411$1342873202$gmane$org@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: kernelnewbies@kernelnewbies.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2GUMT4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jul 2012 08:19:56 -0400
Received: by pbbrp8 with SMTP id rp8so7794537pbb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jul 2012 05:19:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

My module uses ipv6_addr_cmp() from <linux/ipv6.h>.=20

<linux/ipv6.h>
static inline int ipv6_addr_cmp(const struct in6_addr *a1, const struct
in6_addr *a2)
{
	return memcmp(a1, a2, sizeof(struct in6_addr));
}

I've included <linux/ipv6.h>. But when i try to build the module i get
following error:

net/netfilter/xt_ipaddr.c:81: error: implicit declaration of function
=E2=80=98ipv6_addr_cmp=E2=80=99

Although before the call to ipv6_addr_cmp, i have a casting to struct
ipv6hdr *iph. So the definitions from ipv6.h should be available to my
module.

cheers.
aft

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
