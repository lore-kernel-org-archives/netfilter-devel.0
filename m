From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to retrieve original source address with FTP/NAT/TPROXY
Date: Thu, 8 Feb 2018 17:55:20 +0100
Message-ID: <20180208165520.gh5qjmo6vrz2jg42@salvia>
References: <1d02f5e0-2a45-f12a-8f81-bc47e84a9455@tessares.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, matthieu.baerts@tessares.net,
        Gregory Detal <gregory.detal@tessares.net>
To: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750961AbeBHQzY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 11:55:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92A68303D11
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2018 17:55:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 800DEDA809
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2018 17:55:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1d02f5e0-2a45-f12a-8f81-bc47e84a9455@tessares.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Gregory,

On Tue, Feb 06, 2018 at 03:40:20PM +0100, Gregory Vander Schueren wrote:
> Hello,
> 
> I have the following IPv4 network:
> 
> FTPClient <-----------------> Proxy <--------------> FTPServer.
>      10.0.0.2          10.0.0.1   1.1.1.1        1.1.1.2
> 
> FTPClient connects to FTPServer in PASSIVE mode, meaning the FTPClient
> initiates the data connection towards FTPServer. Proxy performs NAT in the
> POSTROUTING chain using the iptables MASQUERADE target. On Proxy, I use the
> iptables TPROXY target to redirect the FTP data connection towards a local
> socket.
> 
> Upon accept() on this socket, the address returned by accept() is 1.1.1.1,
> not the IP of the Client (10.0.0.2) as I expected. Using getpeername() also
> returns 1.1.1.1. For other TCP connections than FTP accept() or
> getpeername() returns 10.0.0.2.
> 
> I noticed this only occurs when using the NF_CONNTRACK_FTP and NF_NAT_FTP
> kernel modules.
> 
> Note that I was able to retrieve the FTPClient IP on Proxy from
> /proc/net/ip_conntrack. I also made a quick patch to add a SO_ORIGINAL_SRC socket option
> (similar to SO_ORIGINAL_DST) which allows to retrieve the FTPClient
> IP. Since this option does not exist yet, I am wondering if this is
> relevant to add such an option?

You can use libnetfilter_conntrack to do this these days, via ctnetlink.

> Also, this does not occur in IPv6.
> 
> Is this behavior normal?

Probably it is related to your ruleset? You could post an example to
reproduce the issue and your kernel version.

Thanks.
