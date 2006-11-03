From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 11/11] Reduce timer updates in __nf_ct_refresh_acct()
Date: Fri, 3 Nov 2006 15:02:12 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031457370.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.886519886@wlug.westbo.se>
	<454B3867.5070004@trash.net>
	<Pine.LNX.4.58.0611031424520.2974@tux.rsn.bth.se>
	<454B46BB.9070908@trash.net>
	<Pine.LNX.4.58.0611031442500.2974@tux.rsn.bth.se>
	<454B4A1C.8070602@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B4A1C.8070602@trash.net>
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

On Fri, 3 Nov 2006, Patrick McHardy wrote:

> Martin Josefsson wrote:
> > On Fri, 3 Nov 2006, Patrick McHardy wrote:
> >
> >>That sounds like a good way to fix it. I think I saw that patch on the
> >>link you sent me some time ago, IIRC it touches core kernel code, so
> >>you should probably send the timer part seperately to lkml.
> >
> >
> > Yes that's why I havn't submitted it yet, hopefully they won't scream too
> > loudly about the changes.
>
> I think it makes sense in cases like conntrack to synchronize by the
> timers, so its a good addition IMO.

Yes, in conntrack's case there's no need to take additional locks when we
already try to rely on the timers for synchronization, better make that
actually work and remove the extra locking. It goes in the same direction
as the work I'm doing, remove atomic instructions and locks as much as
possible.

/Martin
