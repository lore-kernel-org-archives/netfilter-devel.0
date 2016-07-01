From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 libnftnl] set: Add new attribute into 'set' to store
 user data
Date: Fri, 1 Jul 2016 16:24:35 +0200
Message-ID: <20160701142435.GA8972@salvia>
References: <20160627170523.6560-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60387 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbcGAOY5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 10:24:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 99E2E1B1DFA
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:24:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8AE7EFAB48
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:24:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 99F98FAB53
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:24:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160627170523.6560-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 27, 2016 at 07:05:22PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> The new structure 'user' holds a pointer to user data and its length.=
 The
> kernel must have the flag NFTA_SET_USERDATA to support this feature.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
