From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3 v2] libnftnl: rule: Change the "userdata" attribute
 to use new TLV buffer.
Date: Tue, 8 Mar 2016 11:12:25 +0100
Message-ID: <20160308101225.GB3390@salvia>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
 <1456763140-15121-2-git-send-email-carlosfg@riseup.net>
 <20160302184129.GC1351@salvia>
 <56DEA233.5000907@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46244 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbcCHKMp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 05:12:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9DA92C106D
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:12:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8F0BEDA8F9
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:12:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCDFCDA3AD
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:12:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56DEA233.5000907@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 10:58:11AM +0100, Carlos Falgueras Garc=EDa wro=
te:
> On 02/03/16 19:41, Pablo Neira Ayuso wrote:
> >You can consolidate these two functions into one using the NFTNL_BUF=
_*
> >API.
>=20
> If I wrap these functions in this patch, the new code structure will =
differ
> from the one already there. Maybe it is better if I do a complete ref=
actor
> in a different patch?

OK, you follow up to clean up/consolidate this code.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
