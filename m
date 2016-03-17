From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: include/mini-gmp.h is not included at "make dist"
Date: Thu, 17 Mar 2016 16:40:43 +0100
Message-ID: <20160317154043.GA5349@salvia>
References: <56EA81C8.1080408@westermo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Magnus =?iso-8859-1?Q?=D6berg?= <magnus.oberg@westermo.se>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49376 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbcCQPky (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 11:40:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BAF01114F5E
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:40:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AD323DA8F8
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:40:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4AFA0DA8FB
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:40:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56EA81C8.1080408@westermo.se>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 17, 2016 at 11:07:04AM +0100, Magnus =D6berg wrote:
> Added missing dist. file mini-gmp.h in include/Makefile.am

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
