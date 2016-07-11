From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/6] netfilter: nat: convert nat bysrc hash to
 rhashtable
Date: Mon, 11 Jul 2016 12:08:32 +0200
Message-ID: <20160711100832.GA18328@salvia>
References: <1467713244-8555-1-git-send-email-fw@strlen.de>
 <1467713244-8555-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43482 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694AbcGKKIn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:08:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 059E617AB67
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:08:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE5BB9EBD3
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:08:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 65F379EBD6
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:08:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467713244-8555-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 12:07:24PM +0200, Florian Westphal wrote:
> It did use a fixed-size bucket list plus single lock to protect add/d=
el.
>=20
> Unlike the main conntrack table we only need to add and remove keys.
> Convert it to rhashtable to get table autosizing and per-bucket locki=
ng.
>=20
> The maximum number of entries is -- as before -- tied to the number o=
f
> conntracks so we do not need another upperlimit.
>=20
> The change does not handle rhashtable_remove_fast error, only possibl=
e
> "error" is -ENOENT, and that is something that can happen legitimetel=
y,
> e.g. because nat module was inserted at a later time and no src manip
> took place yet.
>=20
> Tested with http-client-benchmark + httpterm with DNAT and SNAT rules
> in place.

Applied, thanks.

I'm fixing this minor glitch here.

  CC [M]  net/netfilter/nf_nat_core.o
net/netfilter/nf_nat_core.c: In function =E2=80=98nf_nat_proto_clean=E2=
=80=99:
net/netfilter/nf_nat_core.c:555:6: warning: unused variable =E2=80=98er=
r=E2=80=99
[-Wunused-variable]
  int err;
      ^

No need to resend.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
