From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] extensions: libxt_multiport: Add translation to nft
Date: Sat, 12 Mar 2016 12:48:34 +0100
Message-ID: <20160312114834.GA2229@salvia>
References: <20160311113604.GA4217@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49029 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbcCLLsm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 06:48:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1E1B64B9E2
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:48:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0A894DA380
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:48:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3CB0DDA380
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:48:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160311113604.GA4217@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 11, 2016 at 05:06:04PM +0530, Piyush Pangtey wrote:
> Added full translation for multiport
> 
> Examples :
> $ iptables-translate -A input -p tcp -m multiport --ports ssh:http -j ACCEPT
> nft add rule ip filter input ip protocol tcp tcp dport { ssh - http } tcp sport
> { ssh - http } counter accept

You can translate this as:

        nft add rule ip filter input ip protocol tcp tcp dport ssh-http ...

without the brackets.

The brackets have special semantics, they mean that the kernel will
use the set infrastructure to define the range. However, we don't need
a set for this small range since we support ranges natively.

Please, fix and resubmit, thanks.
