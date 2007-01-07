From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH/RFC 00/10] Transparent proxying patches version 4
Date: Sun, 7 Jan 2007 17:11:06 +0100
Message-ID: <20070107161106.GA13717@xi.wantstofly.org>
References: <20070103163357.14635.37754.stgit@nienna.balabit> <20070107141134.GA13543@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>,
	netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20070107141134.GA13543@prithivi.gnumonks.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 07, 2007 at 03:11:34PM +0100, Harald Welte wrote:

> > So instead of using NAT to dynamically redirect traffic to local
> > addresses, we now rely on "native" non-locally-bound sockets and do
> > early socket lookups for inbound IPv4 packets. 
> 
> It's good to see a solid implementation of this 'old idea'.  
> 
> Just as a quick historical note to netdev:  This is the way how the
> netfilter project  advised the balabit guys to implement fully
> transparent proxy support, after having seen the complexity of the old
> nat-based TPROXY patches.

Didn't rusty tell the balabit guys to use the NAT approach?
