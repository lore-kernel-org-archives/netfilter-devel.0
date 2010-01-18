From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_hashlimit: simplify seqfile code
Date: Mon, 18 Jan 2010 08:15:16 +0100
Message-ID: <4B540A84.9000204@trash.net>
References: <20100116184900.GA24605@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47637 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0ARHPU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:15:20 -0500
In-Reply-To: <20100116184900.GA24605@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Simply pass hashtable to seqfile iterators, proc entry itself is not needed.

Applied, thanks.

