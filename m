From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH/RFC 00/10] Transparent proxying patches version 4
Date: Wed, 3 Jan 2007 20:33:27 +0100
Message-ID: <20070103193327.GA8331@xi.wantstofly.org>
References: <20070103163357.14635.37754.stgit@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20070103163357.14635.37754.stgit@nienna.balabit>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 03, 2007 at 05:33:57PM +0100, KOVACS Krisztian wrote:

> The following set of patches implement transparent proxying support
> loosely modeled on the Linux 2.2 transparent proxying functionality.

In a transparent http proxy server I wrote a while ago, we used to use
tproxy for making outgoing connections appear to be originating from a
foreign IP address, but moved to inserting an iptables nat rule from
the proxy app every time an outgoing connection needs to be made, due
to the pain of having to patch in the tproxy patches every time we
needed to do a kernel update.

I'd love to see working tproxy functionality merged upstream for that
reason alone.

I'd also love to see the old tproxy API go away entirely.  It was
always a bit of a pain to use.
