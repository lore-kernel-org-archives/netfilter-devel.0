From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [OOPS,TPROXY,xt_owner]: Oops accessing socket in owner_mt()
Date: Mon, 28 Apr 2014 18:43:17 +0200
Message-ID: <20140428164317.GA14615@imap.eitzenberger.org>
References: <20140415133220.GG6576@imap.eitzenberger.org>
 <20140428155731.GA29816@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:61503 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbaD1QnT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:43:19 -0400
Content-Disposition: inline
In-Reply-To: <20140428155731.GA29816@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Not your fault, but I think we should also check for ...
> 
>         ... || skb->sk->sk_state == TCP_TIME_WAIT)
> 
> since early demux was introduced, we may have skb->sk pointing to a
> timewait socket.

Ok, I'll cook a 2nd version of this patch later.

 /Holger

