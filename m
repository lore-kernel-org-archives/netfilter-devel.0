From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 18:55:27 +0900 (JST)
Message-ID: <200601200955.k0K9tSnm004816@toshiba.co.jp>
References: <200601160936.k0G9aXWH026971@toshiba.co.jp>
	<200601200225.k0K2PAn2005682@toshiba.co.jp>
	<20060120081151.GV4603@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060120081151.GV4603@sunbeam.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 20 Jan 2006 09:11:51 +0100

> On Fri, Jan 20, 2006 at 11:25:09AM +0900, Yasuyuki KOZAKAI wrote:
> > 
> > From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> > Date: Mon, 16 Jan 2006 18:36:33 +0900 (JST)
> > 
> > > These patches are just for cleanup. I didn't cleanup ip6t_esp.c because
> > > I have a patch for xt_esp.c. It looks unnecessary to skip IPv6 extension
> > > headers before ESP in match() if ip6_packet_match() does it.
> > > After some tests, I'll send it.
> > 
> > Hmm.. we cannot do that without breaking compatibility of ip6t_esp.
> > Because this forces us to add '-p esp' to ip6tables command. The current
> > ip6t_esp doesn't require it.
> 
> We shouldn't require ourselves to be compatible to bugs.  There is no
> point in matching ESP SPI when the protocol != esp.  So any ruleset that
> would no longer work with the new xt_esp was most likely invalid anyway.

good point. OK, let's prevent users from such misconfiguration rather than
taking care about compatibility this time.

But please note that 'ip6tables -p esp' with kernel before 13 month didn't
match ESP header. That was the policy of initial implementator, not bug.
I imagine he treated ESP as extention header. Then users used
'ip6tables -m esp ...' without '-p esp'.

> > JFYI, I attached a patch for xt_esp I wrote at first time. It's sad to drop it,
> > but let's keep the current code...
> 
> I would want to push this forward (for post-2.6.16).  Patrick has some
> infrastructural changes for the checkfn, which we want to push into
> net-2.6.17 once it opens.  I would like to ask you to re-submit your
> xt_esp after that time.

OK, I'll do it.

> btw: Your patch doesn't seem to modify the existing ip[6]t_esp.h header
> files.

Thanks for notice.

-- Yasuyuki Kozakai
