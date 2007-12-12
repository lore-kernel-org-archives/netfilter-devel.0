From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/5] ctnetlink updates
Date: Wed, 12 Dec 2007 10:03:47 +0100
Message-ID: <475FA3F3.2010705@trash.net>
References: <475C3025.3060307@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbXLLJDv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:03:51 -0500
In-Reply-To: <475C3025.3060307@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset contains several updates for ctnetlink:
> 
> [PATCH 1/5] Add support for NAT sequence adjustments
> [PATCH 2/5] Add support for SCTP
> [PATCH 3/5] Add support for master tuple event notification and dumping
> [PATCH 4/5] Set expected bit for related conntracks
> [PATCH 5/5] Add support for secmark


BTW, multiple of your patches added trailing whitespace, which
makes my scripts complain when exporting the patches for
upstream merging. Please run git-apply --check --whitespace=warn
or something similar on your patches before sending them.
