From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/11] Reduce timer updates in __nf_ct_refresh_acct()
Date: Fri, 03 Nov 2006 14:54:36 +0100
Message-ID: <454B4A1C.8070602@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.886519886@wlug.westbo.se>
	<454B3867.5070004@trash.net>
	<Pine.LNX.4.58.0611031424520.2974@tux.rsn.bth.se>
	<454B46BB.9070908@trash.net>
	<Pine.LNX.4.58.0611031442500.2974@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0611031442500.2974@tux.rsn.bth.se>
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

Martin Josefsson wrote:
> On Fri, 3 Nov 2006, Patrick McHardy wrote:
> 
>>That sounds like a good way to fix it. I think I saw that patch on the
>>link you sent me some time ago, IIRC it touches core kernel code, so
>>you should probably send the timer part seperately to lkml.
> 
> 
> Yes that's why I havn't submitted it yet, hopefully they won't scream too
> loudly about the changes.

I think it makes sense in cases like conntrack to synchronize by the
timers, so its a good addition IMO.
