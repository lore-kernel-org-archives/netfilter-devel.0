From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] netfilter: use krealloc() in nf_conntrack_extend.c V2
Date: Thu, 22 May 2008 22:07:11 +0300
Message-ID: <4835C45F.5030201@cs.helsinki.fi>
References: <Pine.LNX.4.64.0805222145320.6071@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805222155150.6294@sbz-30.cs.Helsinki.FI> <4835C41E.2010502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, mpm@selenic.com, clameter@sgi.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47166 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYEVTJV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 15:09:21 -0400
In-Reply-To: <4835C41E.2010502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Unfortunately this means we'll always have to reallocate, even
> if there's still some room left from the previous allocation.
> Any chance to avoid that?

No, no, krealloc() avoids reallocation if there's enough room in the 
buffer to fit newlen.
