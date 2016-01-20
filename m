From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 2/2] conntrack: fix expectation entry creation
Date: Wed, 20 Jan 2016 15:10:13 +0100
Message-ID: <20160120141013.GB441@salvia>
References: <1452887264-26064-1-git-send-email-ast@fiberby.dk>
 <1452887264-26064-2-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu, netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36351 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbcATOKY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 09:10:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B42843EBA8C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 15:10:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A3888DA804
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 15:10:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7E0ECDA811
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 15:10:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452887264-26064-2-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 15, 2016 at 07:47:44PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Store tuple-src and tuple-dst in exptuple,
> as used by the EXP_CREATE case.
>=20
> Verified with doc/cli/test.sh
>=20
> Also reorder the cases, so the netmask case is last.

Also applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
