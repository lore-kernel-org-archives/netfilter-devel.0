From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_LOG: Avoid to print the default log
 level in the translation
Date: Thu, 10 Mar 2016 19:36:50 +0100
Message-ID: <20160310183650.GA10249@salvia>
References: <20160310181537.GA16699@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47805 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbcCJSgx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:36:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D6E4DC9ED5
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:36:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C80C0DA38B
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:36:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEA01DA385
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:36:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160310181537.GA16699@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 07:15:40PM +0100, Laura Garcia Liebana wrote:
> Avoid to print the log level in the translation when the level is the
> default value.
> 
> Example:
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 10 -j LOG
> nft add rule ip filter INPUT icmp type != router-solicitation counter log

Applied, thanks Laura.
