From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_limit: fix a wrong
 translation to nft rule
Date: Mon, 23 May 2016 19:27:35 +0200
Message-ID: <20160523172735.GA1098@salvia>
References: <1463825236-33317-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbcEWR1p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2016 13:27:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8150FC1256
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2016 19:27:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6D92E15D62F
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2016 19:27:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36BBD15D647
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2016 19:27:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463825236-33317-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 21, 2016 at 06:07:16PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> The default burst value is 5 in iptables limit extension while it is 0 in
> nft limit expression, if the burst value is default, it will not be
> displayed when we dump the rules. But when we do translation from iptables
> rules to nft rules, we should keep the limit burst value unchanged, even if
> it is not displayed in iptables rules.
> 
> And now, if the limit-burst value in the iptables rule is 5 or 0, they are
> all translated to nft rule without burst, this is wrong:
> 
> $ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 5
> nft add rule ip filter INPUT limit rate 10/second counter
> $ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 0
> nft add rule ip filter INPUT limit rate 10/second burst 0 packets counter
> 
> Apply this patch, translation will become:
> 
> $ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 5
> nft add rule ip filter INPUT limit rate 10/second burst 5 packets counter
> $ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 0
> nft add rule ip filter INPUT limit rate 10/second counter

Applied, thanks.
