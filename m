From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 libnfntl] Fix nftnl_*_get to set data_len
Date: Wed, 6 Jul 2016 17:21:00 +0200
Message-ID: <20160706152058.GB31894@salvia>
References: <20160705123125.GA27152@salvia>
 <1467738917-17597-1-git-send-email-carlosfg@riseup.net>
 <1467738917-17597-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46042 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbcGFPVP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 11:21:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 75EE4190F29
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 17:21:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 660B16446A
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 17:21:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E681AFAB55
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 17:21:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467738917-17597-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 07:15:17PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> All getters must set the output parameter 'data_len'

Then, send me a v2 that also replaces strlen(x) + 1 to strlen(x)
from getters.

I can see several spots in src/expr/ that return strlen(x) + 1.  So we
leave this in consistent state in one go.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
