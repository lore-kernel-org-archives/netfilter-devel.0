From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_match()
Date: Wed, 24 Jan 2018 17:13:11 -0800
Message-ID: <1516842791.3715.38.camel@gmail.com>
References: <1516834188.3715.35.camel@gmail.com>
         <20180124231952.GC14192@breakpoint.cc>
         <20180124235056.ahubcyqostttvtbx@salvia>
         <20180125001336.ilboagwlcpck54ip@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180125001336.ilboagwlcpck54ip@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2018-01-25 at 01:13 +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 25, 2018 at 12:50:56AM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Jan 25, 2018 at 12:19:52AM +0100, Florian Westphal wrote:
> > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > > 
> > > > It looks like syzbot found its way into netfilter territory.
> > > 
> > > Excellent.  This will sure allow to find and fix more bugs :-)
> > > 
> > > > Issue here is that @name comes from user space and might
> > > > not be null terminated.
> > > 
> > > Indeed, thanks for fixing this Eric.
> > > 
> > > xt_find_target() and xt_find_table_lock() might have similar issues.
> > 
> > I'm going to keep back this patch then, it would be good if we can
> > find this in one single patch.
> 
> s/find/fix/
> 
> Sorry.


Ok, but apparently you partially fixed this recently :/

Commits 78b79876761b8 and b301f25387599 took care of
xt_find_table_lock() it seems.

I'll send a V2 including xt_request_find_target()
