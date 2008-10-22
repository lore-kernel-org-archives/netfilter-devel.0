From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-save and ip6tables-save exit code with no tables
Date: Wed, 22 Oct 2008 08:29:47 +0200
Message-ID: <48FEC85B.5020406@trash.net>
References: <200810211136.49892.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Victor Stinner <victor.stinner@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41052 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYJVG3t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:29:49 -0400
In-Reply-To: <200810211136.49892.victor.stinner@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Victor Stinner wrote:
> When I setup the firewall rules, I would like to be able to "rollback" to the 
> previous valid state. I'm using this pseudo-code:
>  iptables-save > previous_rules
>  iptables-restore < new_rules
>  on error:
>     iptables-restore < previous_rules
> 
> First problem is that iptables-save doesn't load the needed kernel modules to 
> get the table list. Second problem is that iptables-save (with no argument) 
> exit with code 0 (success) even if /proc/net/ip_tables_names is empty.
> 
> In my pseudo-code: if previous_rule is empty, "iptables-restore < 
> previous_rules" doesn't restore the previous status (iptables-restore does 
> nothing with empty input). I have to check iptables-save exit code *and* that 
> previous_rules is not empty.
> 
> If the kernel module ip_tables is loaded, /proc/net/ip_table_names exists but 
> is empty. The module iptable_filter is needed to 
> fill /proc/net/ip_table_names.
> 
> Same problems with ip6tables-save with /proc/net/ip6_tables_names, and modules 
> ip6_tables and ip6table_filter.

Its actually ip_tables and ip6_tables that are needed to create this
file.

> Attached patch change iptables-save and ip6tables-save behaviour: if there is 
> no table, print the message:
>   iptables-save v1.4.1: /proc/net/ip_tables_names is empty
> and the exit code is 1 (error).
> 
> The message may be changed for a better message :-)

I don't think we should treat this as an error, but simply output
nothing. Regarding rollback, iptables-save/restore can't know about
not-loaded tables, so what you should do is either load the table
modules manually or use the "-t" parameter to iptables-save.
