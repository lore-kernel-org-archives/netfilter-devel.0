From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 nft] set_elem: Use libnftnl/udata to store set
 element comment
Date: Mon, 30 May 2016 11:47:50 +0200
Message-ID: <20160530094750.GB29143@salvia>
References: <1464361015-14755-1-git-send-email-carlosfg@riseup.net>
 <1464361015-14755-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41246 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbcE3Jr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:47:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AEE231D92CE
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:47:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A094F15D633
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:47:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9B97315D633
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:47:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464361015-14755-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 27, 2016 at 04:56:55PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> The set element comment is stored in nftnl_set_elem->user.data using
> libnftnl/udata infrastructure. This allows store multiple variable le=
ngth
> user data into set element.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
