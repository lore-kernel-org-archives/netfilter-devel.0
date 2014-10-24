From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2 v2] evaluate: reject: enhance the error support
 throwing message with more details
Date: Fri, 24 Oct 2014 12:04:27 +0200
Message-ID: <20141024100427.GB4806@salvia>
References: <1414085817-9059-1-git-send-email-alvaroneay@gmail.com>
 <1414085817-9059-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbaJXKCz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:02:55 -0400
Content-Disposition: inline
In-Reply-To: <1414085817-9059-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2014 at 07:36:57PM +0200, Alvaro Neira Ayuso wrote:
> If we add a rule like:
> 
> nft add rule bridge filter input ether type ip reject with icmpv6 type no-route
> 
> We throw an error like:
> 
> <cmdline>:1:44-49: Error: conflicting protocols specified: ip vs ip6
> add rule bridge filter input ether type ip reject with icmpv6 type no-route
> 
> Now, we are going to show in which part of the rule, we have the conflict:
> 
> <cmdline>:1:51-75: Error: conflicting protocols specified: ip vs ip6
> add rule bridge filter input ether type ip reject with icmpv6 type no-route
>                              ~~~~~~~~~~~~~        ^^^^^^^^^^^^^^^^^^^^^^^^^

Applied, thanks.
