From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_match()
Date: Thu, 25 Jan 2018 00:50:56 +0100
Message-ID: <20180124235056.ahubcyqostttvtbx@salvia>
References: <1516834188.3715.35.camel@gmail.com>
 <20180124231952.GC14192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180124231952.GC14192@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 25, 2018 at 12:19:52AM +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > It looks like syzbot found its way into netfilter territory.
> 
> Excellent.  This will sure allow to find and fix more bugs :-)
> 
> > Issue here is that @name comes from user space and might
> > not be null terminated.
> 
> Indeed, thanks for fixing this Eric.
> 
> xt_find_target() and xt_find_table_lock() might have similar issues.

I'm going to keep back this patch then, it would be good if we can
find this in one single patch.

Thanks.
