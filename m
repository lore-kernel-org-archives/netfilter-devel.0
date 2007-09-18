From: mirq-linux@rere.qmqm.pl
Subject: Re: xt_time 20070915
Date: Tue, 18 Sep 2007 13:42:36 +0200
Message-ID: <20070918114236.GA21713@rere.qmqm.pl>
References: <Pine.LNX.4.64.0709151806080.24423@fbirervta.pbzchgretzou.qr>
	<46EE86FA.10604@trash.net>
	<Pine.LNX.4.64.0709171616070.4516@fbirervta.pbzchgretzou.qr>
	<46EFA035.6060409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46EFA035.6060409@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Sep 18, 2007 at 11:53:57AM +0200, Patrick McHardy wrote:
> Jan Engelhardt wrote:
> > Conclusion: It is not really a race, it just depends on what you
> > measure time relative against, i.e. whether xt_time is relative to
> > the packet timestamp or the actual processing {point in time}.
> As a user I would expect that it uses the point in time at which
> the packet is processed.

Suppose you have two rules:

1. match before 10:00 am
2. match after 10:00 am

If you match against processing time it may happen, that the same packet
matches both rules if it arrived at the right moment before 10:00 am.

  -- Michal Miroslaw
