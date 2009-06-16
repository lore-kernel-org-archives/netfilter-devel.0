From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnl: initial cache fill
Date: Tue, 16 Jun 2009 13:42:12 +0200
Message-ID: <4A378514.1080100@trash.net>
References: <200906161311.38251.volker@openbios.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Volker Poplawski <volker@openbios.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36539 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZFPLmO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:42:14 -0400
In-Reply-To: <200906161311.38251.volker@openbios.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Volker Poplawski wrote:
> Why is
> nl_cache_request_full_dump ()
> not part of the public api of libnl?
> 
> Or do i miss the intended way for an initial cache fill when using the cache-
> manager? 

I think you should use nl_cache_mngr_add(), which will dump the
current contents from the kernel and keep the cache up to date
using event messages. IIRC nl_cache_resync() is intended to be
used after receiving an ENOBUFS from the kernel (indicating that
an event message was lost) to trigger a resync. This is an expensive
operation however and may lead to event loss itself, so it probably
makes sense to slightly delay it after receiving an ENOBUFS to make
sure you don't make things worse.

> And BTW: What actually is part of the public api?
> The doxygen docs on libnl give no clue about what is for applications and what 
> is used internally.

Everything declared in one of the headers under include/netlink/
can be considered part of the public API.

