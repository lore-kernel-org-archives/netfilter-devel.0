From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 00:14:31 +0200
Message-ID: <20050820221431.GG5638@aaricia.csbnet.se>
References: <20050820172824.GE5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>
	<20050820202552.GF5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050820202552.GF5638@aaricia.csbnet.se>
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

2005-08-20 22:25:52+0200, Joakim Axelsson <gozem@gozem.se> ->
> > >Its impossible to keep track on where the packet is unless i supply the
> > >table (filter,nat,mangle,raw) and the chain name in --log-prefix. Even if i
> > >try to keep this short there is very little, if no room, left for a reason
> > >to fit in --log-prefix. Simple solution for me is to modify -j LOG to handle
> > >a longer --log-prefix.
> > 
> > There is a -j TRACK, but I have not used it yet. (I apparently forgot to patch 
> > it in, and now I am too lazy to touch my kernel again for some weeks.)
> > 
> 
> Yeah, come to think about that afterwards i sent he mail, havn't had time to
> check it tho.
> 

I checked TRACE. It adds chainname and rulenum to the ipt_entry. ipt_entry
is passed to an -j TARGET, but only ipt_entry->ipt_ip is passed to an -m
match. As far as i can see there is no good way to get that ipt_entry for
the match. Perhaps using the hook_mask? Seems to be the ipt_entry->comefrom.
Don't see a way to use that. Can somebody explain the hook_mask better for
me?

Anyway, i think the best way to solve this, is to set the chainname in the
match's matchdata in userspace. Now, the parse-function doesn't get any info
in userspace on the chain name, but it does get the argv-array. So we can
scan the commandline. Ugly ugly, be will do the trick with least other
(possible unstable) (kernel-)hacking.

Or i could hack a half global area that the rule-traversing code can write
to. Saving the name of the chainname (or just a pointer to the current
ipt_entry). This would also solve another problem/feature i've been thinking
of. What if matches/targets could make a note on the packet which -j LOG
could print. This would make it easy for modules as -m unclean and perhaps
-m recent to express a more exact reason for the packet to match or not. The
next rule in line could then use it, either overwrite it with its own reason
or in the case of -j LOG. Print it. This field would be a simple string, or
even just a char*, being pointed to static strings with reasons that the
different modules have in stock.


-- 
/Joakim Axelsson A.K.A Gozem@EFnet
