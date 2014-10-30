From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-compat: homogenize error messages
Date: Thu, 30 Oct 2014 18:11:50 +0100
Message-ID: <20141030171150.GA18055@salvia>
References: <1414657916-21718-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41915 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161116AbaJ3RKM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:10:12 -0400
Content-Disposition: inline
In-Reply-To: <1414657916-21718-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 30, 2014 at 09:31:56AM +0100, Ana Rey wrote:
> There are some differences between error messages in iptables and
> iptables-compat:
> 
>  # iptables -C INPUT -s 192.168.2.102 -j ACCEPT
> iptables: Bad rule (does a matching rule exist in that chain?).
>  # iptables-compat -C INPUT -s 192.168.2.102 -j ACCEPT
> iptables: No chain/target/match by that name.
> 
>  # iptables -N new_chain
>  # iptables -N new_chain
> iptables: Chain already exists.
>  # iptables-compat -N new_chain
>  # iptables-compat -N new_chain
> iptables: File exists.
> 
> Now, iptables-compat shows the same error messages than iptables in
> those cases.

Applied, thanks Ana.
