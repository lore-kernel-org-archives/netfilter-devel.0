From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4 V6 nft] Implement deleting rule by description
Date: Mon, 22 Aug 2016 18:13:29 +0200
Message-ID: <20160822161329.GB5023@salvia>
References: <20160821212210.26161-1-carlosfg@riseup.net>
 <20160821212210.26161-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755256AbcHVQNj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:13:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB6041F18DF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA444100A68
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2741FF2C7
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:13:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160821212210.26161-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 11:22:08PM +0200, Carlos Falgueras García wrote:
> This patch introduces deletion in a similar fashion as in iptables, thus,
> we can delete the first rule that matches our description, for example:
> 
> 	$ nft list -a ruleset
> 	table ip t {
> 		chain c {
> 			ip saddr 1.1.1.1 counter packets 0 bytes 0 # handle 1
> 			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 2
> 			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 3
> 			ip saddr 1.1.1.4 counter packets 0 bytes 0 # handle 4
> 		}
> 	}
> 	$ nft delete rule table chain ip saddr 1.1.1.2 counter
> 	$ nft list -a ruleset
> 	table ip t {
> 		chain c {
> 			ip saddr 1.1.1.1 counter packets 0 bytes 0 # handle 1
> 			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 3
> 			ip saddr 1.1.1.4 counter packets 0 bytes 0 # handle 4
> 		}
> 	}
> 
> The parser rule 'ruleid_spec' is now of the type 'struct rule' in order to
> hold a rule description. When rule is identified with its handle a dummy
> 'struct rule' is allocated to hold the specified handle.

Applied, thanks Carlos.
