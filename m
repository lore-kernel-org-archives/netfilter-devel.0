From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 nft] parser: Check commentaries length
Date: Mon, 30 May 2016 19:40:11 +0200
Message-ID: <20160530174011.GB4361@salvia>
References: <1464626140-3449-1-git-send-email-carlosfg@riseup.net>
 <1464626140-3449-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39450 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161249AbcE3RkQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 13:40:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0E9D91B5CA5
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:40:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0AC51B3226
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:40:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F19661B3226
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 19:40:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464626140-3449-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 30, 2016 at 06:35:40PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> Checks the commentary maximum length and reports to user in case of e=
rror.

Also applied and I have rewritten the subject and description too to
indicate why we need this check.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
