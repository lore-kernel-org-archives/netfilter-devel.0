From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 libnfntl] Fix nftnl_*_set_str
Date: Wed, 6 Jul 2016 17:19:20 +0200
Message-ID: <20160706151741.GA31894@salvia>
References: <20160705123125.GA27152@salvia>
 <1467738917-17597-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45644 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbcGFPT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 11:19:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7CB34190F2B
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 17:19:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6B663FAB4E
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 17:19:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 546EFFAB4E
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 17:19:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467738917-17597-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 07:15:16PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> These lengths must be one character longer to take account the null
> character

Applied, thanks Carlos.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
