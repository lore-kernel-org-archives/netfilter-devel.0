From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: devgroup: fix showing and saving of dst-group
Date: Tue, 4 Nov 2014 14:41:18 +0100
Message-ID: <20141104134118.GA9818@salvia>
References: <1414686386-7681-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, axinchan@cnrouter.com
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56082 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKDNjw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:39:52 -0500
Content-Disposition: inline
In-Reply-To: <1414686386-7681-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 30, 2014 at 05:26:26PM +0100, Ana Rey wrote:
> Closes bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=985
> 
> The --dst-group parameter in devgroup extensions lists and saves
> incorrectly its value. --dst-group always shows "0x0/0x0".
> 
> This is an example:
> 
>  # iptables -I FORWARD -m devgroup --dst-group 200 -j ACCEPT
> 
>  # iptables -L FORWARD
>  Chain FORWARD (policy ACCEPT)
>  target     prot opt source               destination
>  ACCEPT     all  --  anywhere             anywhere     src-group 0x64 dst-group 0x0/0x0
> 
>  # iptables -S FORWARD
>  -P FORWARD ACCEPT
>  -A FORWARD -m devgroup --dst-group 0x0/0x0 -j ACCEPT

Applied, thanks Ana.
