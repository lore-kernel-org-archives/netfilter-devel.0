From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack can't update mark on icmp connection
Date: Fri, 23 Mar 2012 02:11:43 +0100
Message-ID: <20120323011143.GA20298@1984>
References: <20120214001644.2e3a0d4c@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: abirvalg@lavabit.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46679 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab2CWBLs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:11:48 -0400
Content-Disposition: inline
In-Reply-To: <20120214001644.2e3a0d4c@wwwwww-701SD>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 14, 2012 at 12:16:44AM +0200, abirvalg@lavabit.com wrote:
> Hello,
> As root I try to set marks on all packets originating from my machine with
> 
> conntrack -U -s 192.168.1.114 --mark 10
> 
> It does set marks on some udp connections but ignores the icmp one.
> Upon the issue of this command it lists all updated udp connections with mark=10 and \
>                 eventually gives
> ...
> conntrack v0.9.14 (conntrack-tools): Operation failed: invalid parameters
> 
> After that conntrack -L shows that all udp connections that preceed in the list the icmp one \
> where updated, but the icmp connection and all udp connections following it in the \
> list were not updated. Seems like conntrack choked on icmp.
> 
> Could you please help me.
> uname -a
> Linux 2.6.35-30-generic #60-Ubuntu SMP Mon Sep 19 20:45:08 UTC 2011 i686 \
> GNU/Linux

The problem seems to be in libnetfilter_conntrack.

I have pushed the following patch, it seems to resolve the issue here
for me.

commit 3a39278a56d12ad13a41973cd0b50238206f11ef
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri Mar 23 02:07:41 2012 +0100

    conntrack: fix wrong building of ICMP reply tuple
