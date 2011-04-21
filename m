From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ctnetlink: fix timestamp support for new conntracks
Date: Thu, 21 Apr 2011 10:55:56 +0200
Message-ID: <4DAFF11C.7040602@trash.net>
References: <20110420122213.3000.14349.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42084 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab1DUIz7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:55:59 -0400
In-Reply-To: <20110420122213.3000.14349.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.04.2011 14:22, Pablo Neira Ayuso wrote:
> This patch fixes the missing initialization of the start time if
> the timestamp support is enabled.
> 
> libnetfilter_conntrack/utils# conntrack -E &
> libnetfilter_conntrack/utils# ./conntrack_create
> tcp      6 109 ESTABLISHED src=1.1.1.1 dst=2.2.2.2 sport=1025 dport=21 packets=0 bytes=0 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=21 dport=1025 packets=0 bytes=0 mark=0 delta-time=1303296401 use=2
> 

Applied, thanks Pablo.
