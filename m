From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: arptables: add mcmangle target
Date: Tue, 10 Feb 2009 00:13:00 +0100
Message-ID: <4990B87C.5040001@netfilter.org>
References: <20090128145801.7501.44459.stgit@Decadence> <499047A3.9000505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35201 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753435AbZBIXNQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:13:16 -0500
In-Reply-To: <499047A3.9000505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Great name. Took me a bit to realize the connection to "multicast" :)

I thought about mcnugget target, but it seems to be already copyrighted ;)

> Continuing the idea of a generic ARP address mangling target,
> this would have to be done in userspace using SIOCADDMULTI.
> 
> I would also prefer that approach because the multicast mangling
> seems a bit like a hack which only works when the requesting
> host accepts a multicast MAC address in the ARP reply.

Indeed, I didn't know about SIOCADDMULTI, great. I'll do it like you
have proposed. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
