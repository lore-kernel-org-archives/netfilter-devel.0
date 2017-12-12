From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix handling of verdicts after NF_QUEUE
Date: Tue, 12 Dec 2017 23:42:29 +0100
Message-ID: <20171212224229.GA17187@salvia>
References: <20171211233024.18303-1-dbanerje@akamai.com>
 <20171212002318.GA7681@salvia>
 <3187cfae08f34dd89201f0d2265ab306@usma1ex-dag1mb2.msg.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: "Banerjee, Debabrata" <dbanerje@akamai.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3187cfae08f34dd89201f0d2265ab306@usma1ex-dag1mb2.msg.corp.akamai.com>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Dec 12, 2017 at 12:36:35AM +0000, Banerjee, Debabrata wrote:
> > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > On Mon, Dec 11, 2017 at 06:30:24PM -0500, Debabrata Banerjee wrote:
> > > +	} else {
> > > +		/* Implicit handling for NF_STOLEN, as well as any other
> > > +		 * non conventional verdicts.
> > > +		 */
> > > +		ret = 0;
> > 
> > Another possibility (more simple?) would be this:
> > 
> > int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state) {
> >         struct nf_hook_entry *entry;
> >         unsigned int verdict;
> > -       int ret = 0;
> > +       int ret;
> > 
> >         entry = rcu_dereference(state->hook_entries);
> > next_hook:
> > +       ret = 0;
> > 
> > Basically, make sure ret is set to zero when jumping to the next_hook label.
> 
> Many ways to fix it, but I thought including the comment was appropriate.
> Happy to change it if we want simpler instead.

OK, let's take this one.

Please, send a patch in git-format-patch, that we can pass to -stable.

Cc netfilter-devel@vger.kernel.org and stable@vger.kernel.org should
be fine, you can also include gregkh@linuxfoundation.org since he
maintains 4.9-stable.

I'll ack this by when you send it.

Thanks!
