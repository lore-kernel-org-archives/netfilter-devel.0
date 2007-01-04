From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH/RFC 00/10] Transparent proxying patches version 4
Date: Thu, 4 Jan 2007 13:16:15 +0100
Message-ID: <20070104121615.GB30287@xi.wantstofly.org>
References: <20070103163357.14635.37754.stgit@nienna.balabit> <20070103193327.GA8331@xi.wantstofly.org> <200701041313.27894@nienna>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <200701041313.27894@nienna>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 04, 2007 at 01:13:27PM +0100, KOVACS Krisztian wrote:

> > I'd also love to see the old tproxy API go away entirely.  It was
> > always a bit of a pain to use.
> 
>   It's gone with these patches: all you need is to bind() to foreign 
> addresses, like in the Linux 2.2 days.

That's how I understood it.  Great.
