From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: Re: [nf-next] netfilter: extend SRH match to support matching
 previous, next and last SID
Date: Mon, 23 Apr 2018 22:16:00 +0200
Message-ID: <20180423221600.4d373f3961a1bbe91743b998@gmail.com>
References: <1524480503-1883-1-git-send-email-amsalam20@gmail.com>
        <1524480503-1883-2-git-send-email-amsalam20@gmail.com>
        <20180423173047.gsf2xjlmpichyvte@salvia>
        <20180423220148.03800031d0cb8e8a7a83dc31@gmail.com>
        <20180423200844.bq3ksj262brrifnj@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        dav.lebrun@gmail.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423200844.bq3ksj262brrifnj@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 23 Apr 2018 22:08:44 +0200
Florian Westphal <fw@strlen.de> wrote:

> Ahmed Abdelsalam <amsalam20@gmail.com> wrote:
> > > > @@ -50,6 +62,12 @@ struct ip6t_srh {
> > > >  	__u8                    segs_left;
> > > >  	__u8                    last_entry;
> > > >  	__u16                   tag;
> > > > +	struct in6_addr		psid_addr;
> > > > +	struct in6_addr		nsid_addr;
> > > > +	struct in6_addr		lsid_addr;
> > > > +	struct in6_addr		psid_msk;
> > > > +	struct in6_addr		nsid_msk;
> > > > +	struct in6_addr		lsid_msk;
> > > 
> > > This is changing something exposed through UAPI, so you will need a
> > > new revision for this.
> > 
> > Could you please advice what should be done in this case? 
> 
> You need to add
> struct ip6t_srh_v1 {
> 	/* copy of struct ip6t_srh here */
> 
> 	/* new fields go here */
> };
> 
> 
> Look at xt_conntrack.c, conntrack_mt_reg[] for an example of
> multi-revision match.
> 
> You can probably re-origanise code to avoid too much duplication.
> See 5a786232eb69a1f870ddc0cfd69d5bdef241a2ea in nf.git for an example,
> it makes v0 into a v1 struct at runtime and re-uses new v1 code
> for old v0.
> 
> 

Thanks Florian!  

-- 
Ahmed Abdelsalam <amsalam20@gmail.com>
