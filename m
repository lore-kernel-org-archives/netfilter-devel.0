From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix: support ipv6header match on packets ending
 with NEXTHDR_NONE
Date: Tue, 05 May 2009 15:33:36 +0200
Message-ID: <4A004030.8080902@trash.net>
References: <1240938311-22978-1-git-send-email-christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41763 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZEENdn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 09:33:43 -0400
In-Reply-To: <1240938311-22978-1-git-send-email-christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph Paasch wrote:
> As packets ending with NEXTHDR_NONE don't have a last extension header,
> the check for the length needs to be after the check for NEXTHDR_NONE.

Applied, thanks Christoph.
