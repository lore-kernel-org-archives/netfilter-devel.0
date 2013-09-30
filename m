From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH net-next 1/1] sip: introduce nf_nat_sip_hooks
Date: Mon, 30 Sep 2013 16:49:51 +0200
Message-ID: <20130930144951.GA13405@imap.eitzenberger.org>
References: <20130930135150.440707982@eitzenberger.org>
 <20130930135559.077109518@eitzenberger.org>
 <20130930140309.GA28301@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab3I3Oy7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:54:59 -0400
Content-Disposition: inline
In-Reply-To: <20130930140309.GA28301@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Thanks Holger, I wanted to do the same for a long time now. It actually
> also fixes a minor race condition, when the NAT helper is loaded or
> unloaded while a packet is processed the hooks may be invoked only
> partially.
> 
> Just one request:
> 
> > +struct nf_nat_sip_hooks {
> > +	unsigned int (* nsh_msg)(struct sk_buff *skb,
> > +				 unsigned int protoff,
> > +				 unsigned int dataoff,
> > +				 const char **dptr,
> > +				 unsigned int *datalen);
> 
> I really hate unpronouncable abbrevations, it hurts my eyes and IMO makes
> it harder to read the code. Please use something nicer or get rid of the
> prefix entirely.

Ok, I'll remove the prefix then.

However, personally I think they help grep'ing a lot, like e. g. the
ndo_ prefix with netdevice ops (still usefull even as a 'cscope'
user).

Also the function names are *shorter* with the patch, as I was able
to remove the nf_nat_ prefix.

 /Holger

