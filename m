From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: 64bit changes in cvs
Date: Fri, 28 May 2004 17:12:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405281709390.31197-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0405281413510.7322@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0405281413510.7322@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 28 May 2004, Martin Josefsson wrote:

> I know almost nothing about autoconf (more than I think it's very bloated
> :), I'll see if I can make some time to actually look at it.

It is very bloated for a project targeting only a single OS / libc..

But for any other project the bloat makes detecting all those platform 
dependent junk, compile time options etc a magnitude easier to manage..

Regards
Henrik
