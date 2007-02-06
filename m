From: David Miller <davem@davemloft.net>
Subject: Re: IP_FREEBIND and CAP_NET_ADMIN
Date: Tue, 06 Feb 2007 11:46:59 -0800 (PST)
Message-ID: <20070206.114659.107250775.davem@davemloft.net>
References: <20070103163627.14635.88250.stgit@nienna.balabit>
	<45A48BEB.2070207@trash.net>
	<200702061536.18800@nienna>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@lists.netfilter.org,
	netdev@vger.kernel.org
To: hidden@balabit.hu
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <200702061536.18800@nienna>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: KOVACS Krisztian <hidden@balabit.hu>
Date: Tue, 6 Feb 2007 15:36:18 +0100

> Neither of these require IP_FREEBIND as core functionality, and will 
> probably work if IP_FREEBIND would be bound to CAP_NET_ADMIN.
> 
> So the question is: shall we take the IP_FREEBIND approach, this would 
> change a hardly ever used interface by requiring CAP_NET_ADMIN 
> capabilities, or we should try finding all the scattered places in the 
> Linux IP stack which does a route lookup?

We're not going to remove functionality from the user for the
sake of convenience of something you are trying to write.

If it was some security hole, then fine, but it's not so it
can stay and it does have legitimate uses.

This freebind behavior should actually be the default, but we had to
put the socket option and sysctl there because allowing freebind by
default makes several test suites fail that try to purposely bind to a
non-local address and expect an error return.

It allows servers to bind when your on-demand connection is down.
