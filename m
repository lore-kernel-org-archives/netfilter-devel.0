From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/4] netfilter: xtables: don't register hooks by
 default
Date: Wed, 2 Mar 2016 20:15:03 +0100
Message-ID: <20160302191503.GA4099@salvia>
References: <1456391318-11601-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ebiederm@xmission.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44050 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbcCBTPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 14:15:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5857680FF
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:15:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 48DB6DA8F9
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:15:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C942FDA8F7
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 20:15:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456391318-11601-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 25, 2016 at 10:08:34AM +0100, Florian Westphal wrote:
> This work changes xtables to register tables only
> when the ip(6)tables/arptables command is invoked inside a netns.
> Also changes br_netfilter to not add its sabotage hooks until
> a bridge is created inside the netns.
> 
> The initial namespace isn't affected; hooks are still registered
> on module load time there.
> 
> netperf receiver running in netns 1.
> init ns with empty mangle+filter table.
> 
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> From ns2 (empty mangle + filter table):
> 87380  16384  16384    180.00   22034.90
> 87380  16384  16384    180.00   22355.71
> 87380  16384  16384    180.00   21906.88
> 
> from ns3, no iptables invocations:
> 87380  16384  16384    180.00   23103.76
> 87380  16384  16384    180.00   22975.47
> 87380  16384  16384    180.00   22880.08
> 
> -> ~4% delta.
> 
> Changes since last iteration:
>  - dropped the conntrack changes for now
>  - split patch #2 to make review a bit easier

I have placed this in the nf-next tree, thanks Florian.
