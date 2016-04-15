From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4 v6] libnftnl: rule: Change the "userdata" attribute
 to use new TLV buffer
Date: Fri, 15 Apr 2016 12:38:05 +0200
Message-ID: <20160415103805.GA10438@salvia>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
 <1458675987-32398-2-git-send-email-carlosfg@riseup.net>
 <20160413235918.GA12737@salvia>
 <570FD99E.7040708@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32797 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbcDOKiJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:38:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0C4DCED060
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:38:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F130A9D0F7
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:38:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D5097C21A1
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:38:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <570FD99E.7040708@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 07:55:42PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> I don't understand. With the modification to the patch [4/4 v6] you m=
ade,
> there is still a data copy and it is passed in the same way. This cop=
y has
> moved from libnftnl to nft, but it still exists.

This is an old bug, it's been there for a while.

> There are another 'frees' I think is better to change it for
> 'nftnl_udata_buf_free', although in practice it is the same.

There is no value in using nftnl_udata_buf_free().

nftnl_udata_buf_*() functions are helpers to build the sequence of
TLVs, once this is done, I don't see any good reason to use out of
that context.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
