From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 01/03: nf_conntrack_tcp: decrease timeouts while data
 in unacknowledged
Date: Fri, 26 Jun 2009 17:14:35 +0200
Message-ID: <4A44E5DB.8000304@trash.net>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain> <20080731063313.18150.27237.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0906261627500.2240@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33499 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZFZPOg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:14:36 -0400
In-Reply-To: <alpine.LNX.1.10.0906261627500.2240@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> This patch kills long living ftp transfers from one of my hosts. I'm not 
> able to transfer large files if it takes more than 
> net.netfilter.nf_conntrack_tcp_timeout_unacknowledged seconds.
> 
> After logging to the remote host and issuing any FTP command (ls or 
> put/get for example) tuple's timeout is reduced. Additional commands are 
> able to bump it but only upto 
> net.netfilter.nf_conntrack_tcp_timeout_unacknowledged.
> 
> It seems that IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED flag is never cleard.
> 
> Tested on 2.6.28.10.

Interesting, are you using the FTP NAT helper?

I'm guessing there is some bad interaction between sequence number
adjustments when changing the packet sizes and sequence number
tracking in conntrack.
