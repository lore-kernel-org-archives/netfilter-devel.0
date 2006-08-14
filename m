From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:32:04 +0200
Message-ID: <20060814163204.GA7194@kriss.csbnet.se>
References: <44E07BCD.8030206@trash.net> <200608141640.41759.max@nucleus.it>
	<44E08D3B.7040505@trash.net> <200608141819.38152.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
Content-Disposition: inline
In-Reply-To: <200608141819.38152.max@nucleus.it>
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

2006-08-14 18:19:36+0200, Massimiliano Hofer <max@nucleus.it> ->
> On Monday 14 August 2006 4:48 pm, Patrick McHardy wrote:
> 
> > Hmm .. recent does a table lookup during runtime and the table could be
> > cached. That would improve things a bit, but in my opinion not enough
> > to justify this patch. Same for hashlimit. What data would condition
> > store exactly?
> 
> I need a pointer to per condition data, so that multiple rules with the same 
> name refer to the same flag.
> I can break userspace compatibility and store a pointer in the userspace 
> structure. I just thought this could be useful to everyone (and let me 
> maintain userspace compatibility along the way).
> 

Same goes for all but one of my matches. All of them are accessing "their"
global variable that several rules might share. All but my lim (new limiter)
that has its own data that should be re-checkentry():ed everytime another
rule changes. I sure can keep a global list of all limits but i have no good
way of making each uniq. There is no naming as in condition (and all other
of my modules).

> > Its actually quite clear what is needed. We want a userspace interface
> > built on netlink, that acts on individual rules, not entire rulesets.
> > There are a few more ideas, like handling negation centrally, allowing
> > userspace to specify whether a target is terminal or not, allow multiple
> > non-terminal targets in a row, etc, but nothing really fundamental.
> 
> I thought the current way of doing things was specifically designed to 
> minimize softirq locking (especially with arbitarily long chains and 
> arbitrary initialization code). We could switch to RCU lists, though...
> 

That would solve alot of problems and make the data structure much more
flexible in the futhure for alterations. Guess we have to change back to the
old ipchains name then :-P

--
Joakim Axelsson
