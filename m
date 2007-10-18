From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-save and /proc/net/ip_tables_names
Date: Thu, 18 Oct 2007 16:23:02 +0200
Message-ID: <47176C46.70307@trash.net>
References: <200710181616.00944.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Victor Stinner <victor.stinner@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbXJROX3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:23:29 -0400
In-Reply-To: <200710181616.00944.victor.stinner@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Victor Stinner wrote:
> Hi,
> 
> I found a bug in iptables-save: when fopen("/proc/net/ip_tables_names") fails, 
> iptables-save just exit with code 0 (success). I expected an error to make 
> this command works together:
>   $ iptables-save > /tmp/iptables-backup
>   $ iptables (...)
>   $ iptables-restore > /tmp/iptables-backup
> 
> The problem is that ip_tables module is not loaded before first iptables 
> command.
> 
> Workaround: load iptables kernel modules before calling iptables-save or check 
> that iptables-save is not empty.
> 
> Bugfix in iptables-save: exit with error code (1) on fopen failure => see 
> attached patch proposition. The error message could be "iptables kernel 
> module is not loaded (unable to open ...)" or something better. The most 
> important point is the exit code to make my bash script work :-)


Applied with a similar change for ip6tables-restore. Thanks Victor.
