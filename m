From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] NFQUEUE: Fix bug with order of fanout and bypass
Date: Fri, 15 Apr 2016 12:44:05 +0200
Message-ID: <20160415104405.GA10807@salvia>
References: <20160414152557.GA5338@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33958 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbcDOKoM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:44:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A7346114816
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:44:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 95FE59D0F7
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:44:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DC6C1C21A2
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:44:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414152557.GA5338@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 08:55:58PM +0530, Shivani Bhardwaj wrote:
> NFQUEUE had a bug with the ordering of fanout and bypass options which
> was arising due to same and odd values for flags and bypass when used
> together. Because of this, during bitwise ANDing of flags and
> NFQ_FLAG_CPU_FANOUT, the value always evaluated to false (since
> NFQ_FLAG_CPU_FANOUT=0x02) and led to skipping of fanout option
> whenever it was used before bypass because then flags would be 1.
> 
> Before this patch,
> 
> $ sudo iptables -A FORWARD -j NFQUEUE -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout --queue-bypass
>
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass
> 
> After this patch,
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> NFQUEUE    tcp  --  anywhere             anywhere             tcp spt:http NFQUEUE balance 0:3 bypass cpu-fanout
> 
> Closes bugzilla entry: http://bugzilla.netfilter.org/show_bug.cgi?id=939

Shivani, thanks for following up on this.

Would you also update extensions/libxt_NFQUEUE.t to add a test so we
make sure this regression doesn't happen ever again?

Thanks.
