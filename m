From: Borislav Petkov <bp@alien8.de>
Subject: Re: __nf_register_net_hook jump label splat
Date: Mon, 1 Oct 2018 22:57:53 +0200
Message-ID: <20181001205753.GH7269@zn.tnic>
References: <20180929230409.GA27207@zn.tnic>
 <20180930173930.kyciz5vll23vpjw2@breakpoint.cc>
 <20180930183119.GB32234@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180930183119.GB32234@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Sep 30, 2018 at 08:31:19PM +0200, Borislav Petkov wrote:
> On Sun, Sep 30, 2018 at 07:39:30PM +0200, Florian Westphal wrote:
> > Strange, these static keys have been there for years.
> > Any chance you could send your .config or bisect this?
> 
> .config attached. Lemme try to bisect it, see how far I'll get.

Hmm, so I can't reproduce anymore. Maybe it was something I fat-fingered
here. In any case, rc6 + tip/master boots fine and I'll watch out in the
next days whether it really is gone.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
