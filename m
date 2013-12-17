From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC nf_conntrack_tcp] Export ip_ct_tcp_state variables to
 userspace
Date: Tue, 17 Dec 2013 14:16:40 +0100
Message-ID: <20131217131640.GA8894@localhost>
References: <1387039571-6110-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35019 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3LQNQp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:16:45 -0500
Content-Disposition: inline
In-Reply-To: <1387039571-6110-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Kristian,

On Sat, Dec 14, 2013 at 05:46:11PM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> Several of the TCP state variables tracked by conntrack are interesting for
> userspace applications. This patch adds additional netlink attributes and
> exports the rest of the variables contained in the ip_ct_tcp_state-struct, as
> well as retrans from struct ip_ct_tcp. The size of the netlink message
> increases, but as protoinfo is only called on get/dump, I don't think the
> increased buffer requirement should be a problem.

We have limited bandwidth in the event path and this information would
be also included in those messages.

> One example of a use case for these variables is to make monitoring of TCP
> connections on middleboxes easier and more efficient.  Applications would no
> longer have to detect and keep track of TCP connections them self, they could
> rather rely on the information provided by conntrack. By monitoring the
> development of the sequence numbers and the window size, and using snapshots of
> retrans, one could for example detect the type of tcp flow (thin/thick) and say
> something about the quality of the link.

Looking at the existing Netfilter userspace software that we have now,
I cannot see how we can benefit from this proposed feature.
