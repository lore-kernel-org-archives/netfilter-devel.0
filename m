From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Thu, 11 Jun 2009 16:08:52 +0200
Message-ID: <4A310FF4.2070207@trash.net>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53467 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760892AbZFKOIz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:08:55 -0400
In-Reply-To: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)

Its usually frowned upon to reserve IDs that are not used yet.
We can certainly coordinate so nftables and ipset won't clash
unless we add a different subsystem (we actually did, OSF is
new in nf-next-2.6.git). But is there a reason for adding the
IPSET id at this time instead of waiting until we merge it?

