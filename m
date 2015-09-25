From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fetching interface name
Date: Fri, 25 Sep 2015 15:53:50 +0200
Message-ID: <20150925135350.GA19255@salvia>
References: <5604D75E.8000809@oracle.com>
 <20150925102252.GA3768@salvia>
 <5605412B.4000505@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, eric@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Vikas <vikas.c.kumar@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60405 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbbIYNrA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 09:47:00 -0400
Content-Disposition: inline
In-Reply-To: <5605412B.4000505@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 25, 2015 at 06:12:19PM +0530, Vikas wrote:
> Have two questions wrt to the recent code changes, specially function:
> iface_cache_update().
> 
> 1. Inside iface_cache_update(), I see lot of socket
> calls(open/bind/sendto/recvfrom) and also list_add() inside callback:
> data_cb(). Are these calls not impacting performace?
> We didn't wanted to use if_indextoname() for the fact that it was kernel
> operation. Performance & traffic wise how iface_cache_update() is different
> from if_indextoname()?

I guess you'll have a daemon, so you cache it once and then reuse.

nft is a command line tool, we get the cache once to look up for as
many ifindex as we need, thus we save quite a lot of traffic.

> 2. Looks like iface_cache_update() is called only once(since there is
> boolean flag: iface_cache_init). But even if we update the cache but there
> is no surity that interface index will not change post update.

You have to subscribe to netlink event notifications, to keep the
cache up to date incrementally.

There's also other code in our tree that is doing this:

http://git.netfilter.org/libnfnetlink/tree/src/iftable.c

As I said, it should be very easy to implement an example daemon for
libmnl that initially creates and ifindex cache and then it updates it
based on netlink event notification.
