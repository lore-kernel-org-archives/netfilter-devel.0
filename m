From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 03/11] Split out the event cache
Date: Fri, 3 Nov 2006 13:03:25 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031301380.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.061177411@wlug.westbo.se>
	<454B2EB9.6030101@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B2EB9.6030101@trash.net>
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
> > This patch splits out the event cache into its own file
> > nf_conntrack_ecache.c
>
> I forgot to mention, I've added an include of nf_conntrack_ecache.h
> to xt_CONNMARK to fix a warning.

Ah, sorry, I have another patch where I rewrite most of the event cache, I
added the include in that one...

/Martin
