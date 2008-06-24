From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnfnetlink: mark functions as extern C
Date: Tue, 24 Jun 2008 18:13:50 +0200
Message-ID: <48611D3E.7020909@trash.net>
References: <alpine.LNX.1.10.0806230959020.22994@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57507 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYFXQNy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:13:54 -0400
In-Reply-To: <alpine.LNX.1.10.0806230959020.22994@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 079ff9c9c82629115711410d52bc88b84bbc3a8e
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Jun 23 09:58:34 2008 +0200
> 
> mark functions as extern C
> 
> This is needed when #included from C++.

Applied, thanks.
