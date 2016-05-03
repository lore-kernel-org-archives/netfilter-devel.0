From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/9] netfilter: conntrack: don't attempt to
 iterate over empty table
Date: Wed, 4 May 2016 00:27:42 +0200
Message-ID: <20160503222742.GA1196@salvia>
References: <1461863628-23350-1-git-send-email-fw@strlen.de>
 <1461863628-23350-4-git-send-email-fw@strlen.de>
 <20160503170357.GA21641@salvia>
 <20160503171744.GG2395@breakpoint.cc>
 <20160503174144.GA3782@salvia>
 <20160503175559.GJ2395@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160503175559.GJ2395@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 03, 2016 at 07:55:59PM +0200, Florian Westphal wrote:
> > Otherwise, every time we'll go container destruction path, we'll hit
> > slow path, ie.  scanning the full table.
> 
> Yes, but I see no other choice.

Fair enough, will place this in nf-next, thanks.
