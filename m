From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [TEXTSEARCH]: Fix Boyer Moore initialization bug
Date: Fri, 25 Aug 2006 15:09:33 -0700
Message-ID: <20060825220933.GG26692@kroah.com>
References: <44EA66FD.8050502@trash.net>
	<20060822.004534.88338145.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bunk@stusta.de, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	stable@kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Queued to -stable, thanks.

greg k-h
