From: Patrick McHardy <kaber@trash.net>
Subject: Re: rfc: reject use of drop in nat table
Date: Wed, 13 Aug 2008 14:42:18 +0200
Message-ID: <48A2D6AA.8040201@trash.net>
References: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr> <489734F1.8040808@trash.net> <Pine.LNX.4.64.0808042050300.7375@blackhole.kfki.hu> <4897539C.1080102@trash.net> <alpine.LNX.1.10.0808101044110.1727@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41300 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYHMMmU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:42:20 -0400
In-Reply-To: <alpine.LNX.1.10.0808101044110.1727@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Reject use of DROP in nat table
> 
> Consensus is that we should warn for now.

Applied, thanks.
