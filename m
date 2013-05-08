From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables upgrade: netmask parsing trouble
Date: Wed, 8 May 2013 15:10:16 +0200
Message-ID: <20130508131016.GA3921@localhost>
References: <1548294.4rj9RFaJ57@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51828 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab3EHNK3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 09:10:29 -0400
Content-Disposition: inline
In-Reply-To: <1548294.4rj9RFaJ57@storm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 08, 2013 at 10:17:59AM +0200, Thomas Jarosch wrote:
> Hi,
> 
> I've just updated from iptables 1.4.8 to 1.4.18 (git HEAD to be precise)
> and now face some trouble with netmask parsing:
> 
> This used to work with 1.4.8:
> -A foo -m policy --mode tunnel --dir in --tunnel-src 192.168.123.0/255.255.255.0 -j RETURN
> 
> With git HEAD I get:
> iptables-restore v1.4.18: policy: bad value for option "--tunnel-src", or out of range (0-32)
> 
> 
> This of course works:
> -A foo -m policy --mode tunnel --dir in --tunnel-src 192.168.123.0/24 -j RETURN
> 
> Any reason why we don't accept the full format anymore?

No. Things that used to work have to work indeed. Just sent a patch to
fix it.

Thanks for the report Thomas.
