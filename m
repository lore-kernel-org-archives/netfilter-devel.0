From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] nftables: Fix memory leak linearizing user data
Date: Wed, 25 May 2016 10:46:58 +0200
Message-ID: <20160525084658.GC4024@salvia>
References: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
 <1463500816-26155-3-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46838 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbcEYIrJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 04:47:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DC7D6178EA8
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:47:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CD4D215D620
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:47:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C1BD815D634
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 10:47:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463500816-26155-3-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2016 at 06:00:16PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> nftnl_rule_set_data makes a copy of the user data which receives, it =
is not
> necessary make a copy before call it.

Applied.

Please, don't include the name of the project you're targeting the
patch to in the subject, so instead of:

        [PATCH 2/2] nftables: Fix memory leak linearizing user data

this should be something like:

        [PATCH 2/2 nft] netlink_linearize: Fix memory leak in user data

=46or reference, have a look at what we have in the repository and
trying to make it look similar.

Anyway, I have reworded this subject. This leak is happening after the
change you made in the library, so yes there is now a leak, but we are
actually adapting this to the new interface before we release nftables
0.6.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
