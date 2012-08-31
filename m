From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race
 condition against ctnetlink_del_conntrack
Date: Fri, 31 Aug 2012 11:27:20 +0200
Message-ID: <20120831092720.GA7139@1984>
References: <7353554.n89QJXU3eh@gentoovm>
 <10622350.k1HJ7t2ROS@gentoovm>
 <20120830183950.GB13190@1984>
 <2118331.Ka640JXjym@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47216 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2HaJ12 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:27:28 -0400
Content-Disposition: inline
In-Reply-To: <2118331.Ka640JXjym@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 31, 2012 at 02:19:36AM +0200, Oliver wrote:
> On Thursday 30 August 2012 20:39:50 Pablo Neira Ayuso wrote:
> > Interesting, how are those assumptions fulfilled?
> 
> Well, timing of course ;) - essentially, traffic paths are ensured longer than 
> the actual time for replication of conntrack state.

I see.

> > Agreed. But I don't come with any netfilter change that may result in
> > that problem you're reporting. You'll have to debug this and get back
> > to me with more information.
> 
> You can disregard this, turned out to be due to the unfortunate fact that 
> net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is of course replaced by 
> net.netfilter.nf_conntrack_tcp_be_liberal under 3.4

$ ls /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal 
/proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal

Probably you forgot to set CONFIG_NF_CONNTRACK_PROC_COMPAT=y

We haven't remove it yet, although it should be bad to schedule this
for removal.

> Please feel free to send me your latest rework of the patch and I will be 
> happy to test it out.

Will do.
