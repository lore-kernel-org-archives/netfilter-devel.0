From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3 v2] nftables: rule: Change the field "rule->comment"
 for an nftnl_attrbuf.
Date: Tue, 8 Mar 2016 11:13:06 +0100
Message-ID: <20160308101306.GC3390@salvia>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
 <1456763140-15121-3-git-send-email-carlosfg@riseup.net>
 <20160302183744.GB1351@salvia>
 <56DEA23B.80302@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbcCHKNK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 05:13:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A0AAFC1258
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:13:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8F2C9DA38C
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:13:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B08F4DA39E
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:13:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56DEA23B.80302@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 10:58:19AM +0100, Carlos Falgueras Garc=EDa wro=
te:
> On 02/03/16 19:37, Pablo Neira Ayuso wrote:
> >On Mon, Feb 29, 2016 at 05:25:40PM +0100, Carlos Falgueras Garc=EDa =
wrote:
> >>diff --git a/src/rule.c b/src/rule.c
> >>index 18ff592..499fa7b 100644
> >>--- a/src/rule.c
> >>+++ b/src/rule.c
> >>@@ -23,6 +23,7 @@
> >>
> >>  #include <libnftnl/common.h>
> >>  #include <libnftnl/ruleset.h>
> >>+#include <libnftnl/attr.h>
> >>  #include <netinet/ip.h>
> >>  #include <linux/netfilter.h>
> >>  #include <linux/netfilter_arp.h>
> >>@@ -366,6 +367,7 @@ struct rule *rule_alloc(const struct location *=
loc, const struct handle *h)
> >>  	rule->location =3D *loc;
> >>  	init_list_head(&rule->list);
> >>  	init_list_head(&rule->stmts);
> >>+	rule->udata =3D NULL;
> >>  	if (h !=3D NULL)
> >>  		rule->handle =3D *h;
> >>  	return rule;
> >>@@ -375,21 +377,53 @@ void rule_free(struct rule *rule)
> >>  {
> >>  	stmt_list_free(&rule->stmts);
> >>  	handle_free(&rule->handle);
> >>-	xfree(rule->comment);
> >>+	nftnl_attrbuf_free(rule->udata);
> >
> >I would rename this function to:
> >
> >         nftnl_udata_free();
> >
> >So all functions that now refer to nftnl_attrbuf_* look like:
> >
> >         nftnl_udata_*()
> >
> >then, to push/retrieve attributes, I would use the prefix:
> >
> >         nftnl_udata_attr_*()
>=20
> I renamed all functions following these rule except "nftnl_udata_attr=
_put"
> which I changed to "nftnl_udata_put" because functions like
> "nftnl_udata_attr_put_strz" would have very long name. It is ok?

Yes, that's a good idea :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
