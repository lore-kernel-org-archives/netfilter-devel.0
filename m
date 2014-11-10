From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-compat: homogenize error messages with 'R'
 option
Date: Mon, 10 Nov 2014 18:16:54 +0100
Message-ID: <20141110171654.GA26973@salvia>
References: <1415202394-11031-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41433 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbaKJRPK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:15:10 -0500
Content-Disposition: inline
In-Reply-To: <1415202394-11031-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 05, 2014 at 04:46:34PM +0100, Ana Rey wrote:
> There is a difference between error messages in iptables and
> iptables-compat:
> 
>  # iptables -R INPUT 23 -s 192.168.2.140 -j ACCEPT
> iptables: Index of replacement too big.
>  # iptables-compat -R INPUT 23 -s 192.168.2.140 -j ACCEPT
> iptables: No chain/target/match by that name.
> 
> Now, iptables-compat shows the same error message than iptables in
> this case.

Applied, thanks.
