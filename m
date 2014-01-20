From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftable atomic rule replacement/update/restore?
Date: Mon, 20 Jan 2014 23:30:55 +0000
Message-ID: <20140120233055.GA17034@macbook.localnet>
References: <A2B302C7-AD8B-4239-BD8E-8E0FA29721B7@halon.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anders Berggren <anders@halon.se>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33383 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaATXbA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:31:00 -0500
Content-Disposition: inline
In-Reply-To: <A2B302C7-AD8B-4239-BD8E-8E0FA29721B7@halon.se>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 20, 2014 at 10:10:50PM +0100, Anders Berggren wrote:
> I apologise if this isn't the appropriate mailing list. Also, congratulations on the 3.13 inclusion, and 0.99 release!
> 
> After browsing the code I didn't find any atomic ruleset update/restore functionality, as described by http://marc.info/?l=netfilter-devel&m=135959066918397&w=2 and present in iptables-restore and possibly pfctl -f ...
> 
> If it's not currently implemented, I would suggest something like:
> 
> # nft -f myruleset
> # cat rulesetset
> table filter {
> 	chain input {
> 		type filter hook input priority 0;
> 		ct state established accept
> 		...
> 
> so that the user can have a nicely formated firewall configuration file, applied by a simple command.--

Yeah, that's exactly what we do. Basically the ruleset you get by
nftables list table ... is formated like this and can be parsed using
nft -f.
