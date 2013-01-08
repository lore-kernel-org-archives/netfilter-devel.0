From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Possible arptables bug.
Date: Tue, 8 Jan 2013 11:50:48 +0100
Message-ID: <20130108105048.GA14926@1984>
References: <201301081032.53926.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3AHKux (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:50:53 -0500
Content-Disposition: inline
In-Reply-To: <201301081032.53926.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 08, 2013 at 10:32:53AM +0000, Steven Jan Springl wrote:
> Hello
> 
> arptables-save tries to convert any IP addresses to DNS names.
> Is this the expected behaviour?
> 
> If it is the expected behaviour, is there any way that it can be disabled as
> arptables-save hangs until the DNS lookup times out if DNS is not available?

Like iptables, use -n together with -L.

BTW, please, for user oriented question user go to
netfilter@vger.kernel.org.
