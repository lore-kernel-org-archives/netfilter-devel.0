From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: iptables nftables compat weirdness
Date: Wed, 17 Jun 2015 12:19:15 +0200 (CEST)
Message-ID: <1383987357.13271.1434536355883.JavaMail.zimbra@tpip.net>
References: <1424744661.225751.1433848590972.JavaMail.zimbra@tpip.net> <20150616160725.GA7165@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:36118 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbbFQKTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 06:19:23 -0400
In-Reply-To: <20150616160725.GA7165@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

----- Original Message -----
> From: "Pablo Neira Ayuso" <pablo@netfilter.org>
> To: "Andreas Schultz" <aschultz@tpip.net>
> Cc: netfilter-devel@vger.kernel.org
> Sent: Tuesday, June 16, 2015 6:07:25 PM
> Subject: Re: iptables nftables compat weirdness

[...]
 
> Could you help me diagnosing this problem? The nf_tables kernel side
> is rejecting this with -EINVAL. Is this a new bug in the 4.1-rc
> series?

I've only worked with this on 4.1-rc5. I'm currently rebuilding the
system for testing with 3.19 and 4.0, but this will take some time.

I did inject some debug printk's and was able to track the -EINVAL
to nft_target_validate. It seems that this validate is only
executed when then target chain contains some rules. The validation
is not executed when the target chain is empty.

> 
> Thank you.

Andreas
