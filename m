From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [IPTABLES 0/2] iptables-compat fixes
Date: Thu, 23 Jul 2015 16:58:17 +0200
Message-ID: <20150723145817.GA5242@salvia>
References: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59697 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbbGWOwd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2015 10:52:33 -0400
Content-Disposition: inline
In-Reply-To: <1437486342-6917-1-git-send-email-twoerner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 21, 2015 at 03:45:40PM +0200, Thomas Woerner wrote:
> Here are the first patches from my tests with iptables-compat and firewalld:
> 
> The first patch is enabling to insert a rule into rule_count+1 position. 
> # iptables-compat -t filter -S INPUT
> -P INPUT ACCEPT
> [0:0] -A INPUT -s 1.2.3.4/32 -j DROP
> # iptables-compat -t filter -I INPUT 2 -s 1.2.3.5 -j DROP 
> # iptables-compat -t filter -S INPUT
> -P INPUT ACCEPT
> [0:0] -A INPUT -s 1.2.3.4/32 -j DROP
> [0:0] -A INPUT -s 1.2.3.5/32 -j DROP
> This is possible with iptables, but not possible with iptables-compat.
> Maybe it would be good to add nft_rule_list_count or similar and use it here.
> 
> The second patch fixes the rule number handling in nft_rule_find and 
> __nft_rule_list. The rule number is only valid in the selected table and chain 
> and therefore may not be increased for other tables or chains. With this patch 
> the correct rule will be removed with -D <name> i and listed with -S <name> i.

Series applied, thanks Thomas!
