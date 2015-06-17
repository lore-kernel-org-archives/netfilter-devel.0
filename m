From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: iptables nftables compat weirdness
Date: Wed, 17 Jun 2015 12:28:02 +0200 (CEST)
Message-ID: <1558445263.13356.1434536882066.JavaMail.zimbra@tpip.net>
References: <1424744661.225751.1433848590972.JavaMail.zimbra@tpip.net> <20150616160725.GA7165@salvia> <1383987357.13271.1434536355883.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:47947 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbbFQK2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 06:28:08 -0400
In-Reply-To: <1383987357.13271.1434536355883.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- Original Message -----
> From: "Andreas Schultz" <aschultz@tpip.net>
> To: "Pablo Neira Ayuso" <pablo@netfilter.org>
> Cc: netfilter-devel@vger.kernel.org
> Sent: Wednesday, June 17, 2015 12:19:15 PM
> Subject: Re: iptables nftables compat weirdness

> Hi,
> 
> ----- Original Message -----
>> From: "Pablo Neira Ayuso" <pablo@netfilter.org>
>> To: "Andreas Schultz" <aschultz@tpip.net>
>> Cc: netfilter-devel@vger.kernel.org
>> Sent: Tuesday, June 16, 2015 6:07:25 PM
>> Subject: Re: iptables nftables compat weirdness
> 
> [...]
> 
>> Could you help me diagnosing this problem? The nf_tables kernel side
>> is rejecting this with -EINVAL. Is this a new bug in the 4.1-rc
>> series?

Seems to be an old bug. I was able to reproduce it on Ubuntu 15.10, Kernel 3.19
with nftables 0.4 and libnftnl-dev 1.0.3 packages and iptables from git head.

Test sequence:

# nft delete table filter
# iptables-compat -N test
# iptables-compat -A INPUT -j test
# iptables-compat -A test -j MARK --set-mark 0x80000000/0x80000000
# iptables-compat -A INPUT -j test
iptables: Invalid argument. Run `dmesg' for more information.

Andreas
