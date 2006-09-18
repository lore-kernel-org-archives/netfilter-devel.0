From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [TEXTSEARCH]: Fix Boyer Moore initialization bug
Date: Mon, 18 Sep 2006 19:26:43 +0200
Message-ID: <20060918172643.GN3463@stusta.de>
References: <44EA66FD.8050502@trash.net>
	<20060822.004534.88338145.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20060822.004534.88338145.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 22, 2006 at 12:45:34AM -0700, David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 22 Aug 2006 04:07:57 +0200
> 
> > this fixes an initialization bug in the bm textsearch
> > algorithm affecting the netfilter string match (the
> > only user AFAIK). Please apply to 2.6.18, thanks.
> > 
> > @stable maintainers: the bm_ts author asked me to also
> > submit this to -stable, please apply.
> 
> Applied and Ack'd for -stable.

Thanks, applied to 2.6.16.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
