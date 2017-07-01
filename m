From: Greg KH <greg@kroah.com>
Subject: Re: [4.9.y,netfilter] please, cherry-pick 2638fd0f92d4
Date: Sat, 1 Jul 2017 16:11:24 +0200
Message-ID: <20170701141124.GB8136@kroah.com>
References: <20170629150021.GA5346@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629150021.GA5346@salvia>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 29, 2017 at 05:00:21PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> Please, cherry-pick this commit:
> 
> commit 2638fd0f92d4397884fd991d8f4925cb3f081901
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Mon Apr 3 10:55:11 2017 -0700
> 
>     netfilter: xt_TCPMSS: add more sanity tests on tcph->doff
> 
> People are experiencing crashes in production without this patch:
> 
> http://marc.info/?l=linux-netdev&m=149759912312430&w=2
> 
> [ Note for other stable maintainers: This patch applies cleanly here
>   from 3.16 onwards. ]

Now applied, thanks!

greg k-h
