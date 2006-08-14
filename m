From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:55:49 +0200
Message-ID: <20060814165549.GC7194@kriss.csbnet.se>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se>
	<44E09693.9000606@trash.net>
	<20060814160443.GX7194@kriss.csbnet.se>
	<44E0A132.6040709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E0A132.6040709@trash.net>
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

2006-08-14 18:13:38+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-08-14 17:28:19+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>>
> >>>Please have a look here for 4 modules "needing" this patch:
> >>>http://www.gozem.se/~gozem/netfilter/
> >>
> >>Please post your examples to the list.
> >>
> > 
> > 
> > In which format? As a full patch for the kernel or something that fits in
> > pom-ng? The current code works for 2.4 and early 2.6. I don't want to spend
> > time porting it into "wrong" API now when we are discussing priv_data to be
> > or not to be :-)
> 
> I'm mostly interested in the way you wish to use it, so I can better
> judge whether this change is worth doing or not.
> 

The change is NOT worth it if we can't keep the priv_data pointer between
changes of unrelated rules. I better use a global list instead as condition
is using today.

Still, i want to know in whcih format the new modules are wanted. Patch,
files fitting pom-ng or my own svn-repository to source.list?

I will port my matches as soon as possible and post them for you to judge.
Probably for tomorrow evening.

--
Joakim Axelsson
