From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] netfilter: ipvs: Convert timers to use timer_setup()
Date: Thu, 2 Nov 2017 15:42:48 +0100
Message-ID: <20171102144247.yz2yupsj4cjctvio@verge.net.au>
References: <20171024084521.GA23684@beast>
 <alpine.LFD.2.20.1710242203100.2078@ja.home.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <lvs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.20.1710242203100.2078@ja.home.ssi.bg>
Sender: lvs-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 24, 2017 at 10:07:03PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 24 Oct 2017, Kees Cook wrote:
> 
> > In preparation for unconditionally passing the struct timer_list pointer to
> > all timer callbacks, switch to using the new timer_setup() and from_timer()
> > to pass the timer pointer explicitly.
> > 
> > Cc: Wensong Zhang <wensong@linux-vs.org>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Julian Anastasov <ja@ssi.bg>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: netdev@vger.kernel.org
> > Cc: lvs-devel@vger.kernel.org
> > Cc: netfilter-devel@vger.kernel.org
> > Cc: coreteam@netfilter.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> 	Looks good to me,
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Signed-off-by: Simon Horman <horms@verge.net.au>

Pablo, could you take this?
