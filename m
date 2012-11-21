From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: Fix range bug in hash:ip,port,net
Date: Wed, 21 Nov 2012 23:53:48 +0100
Message-ID: <20121121225347.GA19941@1984>
References: <alpine.DEB.2.00.1211191550450.22583@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54999 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab2KVUkg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:40:36 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211191550450.22583@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 19, 2012 at 05:42:21PM +0100, Jozsef Kadlecsik wrote:
[...]
> Due to the missing ininitalization at adding/deleting entries, when
> a plain_ip,port,net element was the object, multiple elements were
> added/deleted instead. The bug came from the missing dangling
> default initialization.
> 
> The error-prone default initialization is corrected in all hash:* types.

Applied, thanks Jozsef!
