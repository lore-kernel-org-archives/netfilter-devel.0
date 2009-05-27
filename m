From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: nfnetlink_log: fix wrong skbuff size	calculation
Date: Wed, 27 May 2009 15:50:04 +0200
Message-ID: <4A1D450C.1080508@trash.net>
References: <20090527125242.11366.70215.stgit@Decadence> <20090527125401.11366.31677.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50364 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZE0NuG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 09:50:06 -0400
In-Reply-To: <20090527125401.11366.31677.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This problem was introduced in 72961ecf84d67d6359a1b30f9b2a8427f13e1e71
> since no space was reserved for the new attributes NFULA_HWTYPE,
> NFULA_HWLEN and NFULA_HWHEADER.

Applied, thanks Pablo.
