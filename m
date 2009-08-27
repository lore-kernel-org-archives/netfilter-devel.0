From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: netns fix re reliable conntrack
 event delivery
Date: Thu, 27 Aug 2009 11:21:34 +0200
Message-ID: <4A96501E.5020907@netfilter.org>
References: <20090826222425.GA7523@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37747 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZH0JVm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:21:42 -0400
In-Reply-To: <20090826222425.GA7523@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Conntracks in netns other than init_net dying list were never killed.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
