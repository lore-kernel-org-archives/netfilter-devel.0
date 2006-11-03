From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 11/11] Reduce timer updates in __nf_ct_refresh_acct()
Date: Fri, 3 Nov 2006 14:48:24 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031442500.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.886519886@wlug.westbo.se>
	<454B3867.5070004@trash.net>
	<Pine.LNX.4.58.0611031424520.2974@tux.rsn.bth.se>
	<454B46BB.9070908@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B46BB.9070908@trash.net>
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

> > You are absolutely correct. I discussed this with Rusty some time ago and
> > he thought it was fine since we mostly aim for "best effort", but I don't
> > like it either. I have a patch that adds another variant of mod_timer()
> > that doesn't activate an inactive timer, and use this instead of
> > del_timer()/add_timer(). This avoids this race and reduces the number of
> > locks taken. I'll send this patch to you after this weekend I think.
>
>
> That sounds like a good way to fix it. I think I saw that patch on the
> link you sent me some time ago, IIRC it touches core kernel code, so
> you should probably send the timer part seperately to lkml.

Yes that's why I havn't submitted it yet, hopefully they won't scream too
loudly about the changes.

/Martin
