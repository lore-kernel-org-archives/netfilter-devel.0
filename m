From: Patrick McHardy <kaber@trash.net>
Subject: Re: rfc: reject use of drop in nat table
Date: Mon, 04 Aug 2008 18:57:21 +0200
Message-ID: <489734F1.8040808@trash.net>
References: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59518 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYHDQ5X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:57:23 -0400
In-Reply-To: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> This just happened to be within my thoughts. Comments, declinations?

Well, first thought is the usual fear of breaking setups.

But I do agree that this makes sense, we've had a number
of "bugreports" over the years from people how tried to
do filtering in the nat table and didn't realize it only
sees the first packet of a connection.

Not sure - anyone else with an opinion? :)
