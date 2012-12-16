From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nfnetlink_log mac address for 6in4 tunnels
Date: Sun, 16 Dec 2012 23:47:47 +0100
Message-ID: <20121216224747.GA4167@1984>
References: <000601cdd958$76ea7a00$64bf6e00$@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Bob Hockney <bhockney@ix.netcom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50122 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2LPWrv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:47:51 -0500
Content-Disposition: inline
In-Reply-To: <000601cdd958$76ea7a00$64bf6e00$@ix.netcom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 13, 2012 at 10:37:02AM -0700, Bob Hockney wrote:
> 
> For tunneled ipv6in4 packets, the LOG target (xt_LOG.c) adjusts the start of
> the mac field to start at the ethernet header instead of the ipv4 header for
> the tunnel.  This patch conforms what is passed by the NFLOG target through
> nfnetlink to what the LOG target does.  Code borrowed from xt_LOG.c.
> 
> Here are before and after log lines.  The kernel: lines are with the LOG
> target, the ulogd lines are with NFLOG, ulogd and its SYSLOG  plugin:
> 
> Log lines for the same packet, before patch:
> 
> Dec  3 09:07:22 gateway kernel: [   69.268396] INVALID IN=he-ipv6 OUT=eth1
> MAC=00:50:8d:bf:02:01:68:ef:bd:f0:7d:d9:08:00:45:00:00:5c:00:00:40:00:fa:29:
> 64:c2:42:dc:12:2a:18:31:ae:7f TUNNEL=66.220.18.42->w.x.y.z SRC= ...
> Dec  3 09:07:22 gateway ulogd[1628]: INVALID  IN=he-ipv6 OUT=eth1
> MAC=45:00:00:5c:00:00:40:00:fa:29:64:c2:42:dc:12:2a:18:31:ae:7f:68:00:00:00:
> 00:20:06:35:2a:03:28:80:00:10 SRC= ...
> 
> Log lines after patch:
> 
> Dec  3 09:08:44 gateway kernel: [   32.998288] INVALID IN=he-ipv6 OUT=eth1
> MAC=00:50:8d:bf:02:01:68:ef:bd:f0:7d:d9:08:00:45:00:00:5c:00:00:40:00:fa:29:
> 64:c2:42:dc:12:2a:18:31:ae:7f TUNNEL=66.220.18.42->w.x.y.z SRC= ...
> Dec  3 09:08:45 gateway ulogd[1488]: INVALID  IN=he-ipv6 OUT=eth1
> MAC=00:50:8d:bf:02:01:68:ef:bd:f0:7d:d9:08:00:45:00:00:5c:00:00:40:00:fa:29:
> 64:c2:42:dc:12:2a:18:31:ae:7f SRC= ...

Applied.

Please, next time you have to base your patch on some recent linux
kernel tree. You can get it via git or just some snapshot via
kernel.org, I'm telling this because I had to rebase this patch upon
current.

Thanks Bob.
