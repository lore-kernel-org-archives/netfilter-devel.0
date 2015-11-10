From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft,v2] src: add interface wildcard matching
Date: Tue, 10 Nov 2015 23:43:55 +0100
Message-ID: <20151110224355.GA2438@salvia>
References: <1446464915-2407-1-git-send-email-pablo@netfilter.org>
 <CAJO99TnYBByUPE4_2ACL-tcPVv5z2VROxCaQyWp6AVkZXt92hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54742 "EHLO salida-rhel7.int"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbbKJWoF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 17:44:05 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by salida-rhel7.int (Postfix) with ESMTP id E0EF51714ED
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 23:44:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CDC449DC82
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 23:44:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DF7F8D1909
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 23:44:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAJO99TnYBByUPE4_2ACL-tcPVv5z2VROxCaQyWp6AVkZXt92hA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 10, 2015 at 06:18:24PM +0100, Bj=F8rnar Ness wrote:
> 2015-11-02 12:48 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > Contrary to iptables, we use the asterisk character '*' as wildcard=
=2E
> >
> >  # nft --debug=3Dnetlink add rule test test iifname eth\*
>=20
> Any reason this is not iifprefix instead of iifname..

We can use this approach from any key using a string datatype,
eg. ct helper.

If we do this at key level, we'll have to add whateverprefix for every
key where we want to support string prefixes.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
