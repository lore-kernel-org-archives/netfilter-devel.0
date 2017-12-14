From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Fix handling of verdicts after NF_QUEUE
Date: Thu, 14 Dec 2017 18:39:34 +0100
Message-ID: <20171214173934.GA10610@kroah.com>
References: <20171213203337.314-1-dbanerje@akamai.com>
 <20171214123008.jae4xa4nnpqdeoli@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Debabrata Banerjee <dbanerje@akamai.com>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171214123008.jae4xa4nnpqdeoli@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 14, 2017 at 01:30:08PM +0100, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> I'd appreciate if you can take this patch into 4.9-stable. There is no
> similar patch in tree, so this is not a backport.
> 
> On Wed, Dec 13, 2017 at 03:33:37PM -0500, Debabrata Banerjee wrote:
> > A verdict of NF_STOLEN after NF_QUEUE will cause an incorrect return value
> > and a potential kernel panic via double free of skb's
> > 
> > This was broken by commit 7034b566a4e7 ("netfilter: fix nf_queue handling")
> > and subsequently fixed in v4.10 by commit c63cbc460419 ("netfilter:
> > use switch() to handle verdict cases from nf_hook_slow()"). However that
> > commit cannot be cleanly cherry-picked to v4.9
> > 
> > Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Thanks a lot!

Now applied, thanks.

greg k-h
