From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: changed generic l4 protocol number
Date: Mon, 26 Jan 2009 16:15:23 +0100
Message-ID: <497DD38B.9060109@trash.net>
References: <200901241622.36634.christoph.paasch@student.uclouvain.be> <497DB865.8050003@trash.net> <200901261557.15172.christoph.paasch@student.uclouvain.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZAZPP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:15:26 -0500
In-Reply-To: <200901261557.15172.christoph.paasch@student.uclouvain.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph Paasch wrote:
> 0 is used by Hop-by-hop header and so this may cause confusion.
> 255 is stated as 'Reserved' by IANA.

Applied, thanks.
