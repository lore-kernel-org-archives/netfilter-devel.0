From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:40:05 +0200
Message-ID: <20060814154005.GW7194@kriss.csbnet.se>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se> <44E09746.60302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E09746.60302@trash.net>
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

2006-08-14 17:31:18+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > Alot of my patches can use it. Not having todo an ugly solution trying to
> > sneak away from being reseted when another rule is altered. I sure would
> > like to have it added. Simpyl do not change for example -m limit into using
> > it if it breaks the "feature" of reseting its state then altering another
> > unrelated rule.
> 
> I forgot to reply to this. You seem to misunderstand, limit doesn't
> reset its state today. It will when moving private data out of the
> structures shared with userspace. Same for all other users of this,
> they will "forget" their state on each ruleset change.

Okie, now I get it. This seams to have changed from 2.4 then. As altering
one unrelated rule will trigger the checkentry for _all_ rules. The code i
posted was a (somewhat ugly) workaround for this, and yes relying on
userspace not altering a kernel-space pointer for us. However, the case is
the same for xt_limit with r->master = r; (and quota). Alter master in
userspace after the limit rule has been initiated and you will get some
really nasty result.

--
Joakim Axelsson
