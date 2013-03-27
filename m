From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] libmnl: Add filtering support to library as a
 convienience
Date: Wed, 27 Mar 2013 08:55:57 -0400
Message-ID: <20130327125557.GA1395@hmsreliant.think-freely.org>
References: <1364307643-21747-1-git-send-email-nhorman@tuxdriver.com>
 <20130326205028.GA7117@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Florian Weimer <fweimer@redhat.com>,
	Hushan Jia <hushan.jia@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45577 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3C0M4D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:56:03 -0400
Content-Disposition: inline
In-Reply-To: <20130326205028.GA7117@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 26, 2013 at 09:50:28PM +0100, Pablo Neira Ayuso wrote:
> Hi Neil,
> 
> On Tue, Mar 26, 2013 at 10:20:43AM -0400, Neil Horman wrote:
> > Theres been recent discussion about detecting and discarding unwanted netlink
> > messages in libmnl, so that we can avoid having applications get spoofed by user
> > space processes sending messages with malformed netlink headers.  Commonly
> > applications want to be able to only receive messages from the kernel, but
> > libmnl currently doesn't offer a mechanism to do that.  This patch adds such a
> > mechanism.  It creates a function mnl_socket_recvfrom_filter, that adds an
> > extra function pointer parameter which is used to interrogate recieved frames
> > and filter them based on a desired criteria.  It also adds a convieninece
> > function mnl_recvfrom_filter_user which can be passed as the filter agrument in
> > mnl_socket_recvfrom_filter, so as to prevent individual applications from
> > re-inventing the wheel over and over again.
> 
> I remember that report from Florian. After some discussion, I proposed
> this solution:
> 
> commit 20e1db19db5d6b9e4e83021595eab0dc8f107bef
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Thu Aug 23 02:09:11 2012 +0000
> 
>     netlink: fix possible spoofing from non-root processes
> 
> Basically, it disables netlink-to-netlink communications between
> non-root processes (with the exception of NETLINK_USERSOCK), so
> non-root processes cannot spoof messages anymore.
> 
> Regards.
> 
Ah, thank you pablo, wish Florian or I had seen this previously.

Regards
Neil

