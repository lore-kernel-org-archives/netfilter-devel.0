From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: avoid compile warnings for iptc_insert_chain
Date: Mon, 23 Mar 2009 13:51:34 +0100
Message-ID: <49C785D6.3010604@trash.net>
References: <49C202EA.40006@trash.net> <d69a2a7d86c4224396091673aefc59cf25d55713.1237460727.git.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37998 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZCWMvk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 08:51:40 -0400
In-Reply-To: <d69a2a7d86c4224396091673aefc59cf25d55713.1237460727.git.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph Paasch wrote:
> iptc_insert_chain is too big to get inlined and so it generates
> a warning while compiling.

Applied, thanks. But please include the compiler messages in the
changelog when fixing warnings.
