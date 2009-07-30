From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: logging
Date: Thu, 30 Jul 2009 14:42:14 +0200
Message-ID: <4A719526.5060508@trash.net>
References: <4A70C3D1.7040809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63036 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZG3MmQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:42:16 -0400
In-Reply-To: <4A70C3D1.7040809@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> from iptables I'm used to see the logging output in the default syslog
> files, with nftables this seams to be different.
> My rule looks like this:
> 
> [...]
> ct state new log prefix "start: " accept
> 
> but there are no log entries in the syslog file.
> Where does nftables writes its logs?
> 
> The nft_log module is loaded:
> lsmod|grep nft_l
> nft_log                 1952  1
> nf_tables              25540  43
> nft_meta,nft_log,nft_payload,nft_ct,nft_rbtree,nft_hash,nf_tables_ipv4
> 
> For testing it would be very handy to have a working logging setup.
> 
> Is there already a way to dump the current rules from the kernel to
> stdout (like iptables -vnL) - if this is even possible?

nftables uses the netfilter logging API, which needs a backend
to actually make something out of the entries. You can either
load ipt_LOG/ip6t_LOG or use nfnetlink_log.
