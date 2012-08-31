From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Fri, 31 Aug 2012 02:19:36 +0200
Message-ID: <2118331.Ka640JXjym@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <10622350.k1HJ7t2ROS@gentoovm> <20120830183950.GB13190@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:41006 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab2HaATS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:19:18 -0400
In-Reply-To: <20120830183950.GB13190@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 30 August 2012 20:39:50 Pablo Neira Ayuso wrote:
> Interesting, how are those assumptions fulfilled?

Well, timing of course ;) - essentially, traffic paths are ensured longer than 
the actual time for replication of conntrack state.


> Agreed. But I don't come with any netfilter change that may result in
> that problem you're reporting. You'll have to debug this and get back
> to me with more information.

You can disregard this, turned out to be due to the unfortunate fact that 
net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is of course replaced by 
net.netfilter.nf_conntrack_tcp_be_liberal under 3.4

Please feel free to send me your latest rework of the patch and I will be 
happy to test it out.

Kind Regards,
Oliver
