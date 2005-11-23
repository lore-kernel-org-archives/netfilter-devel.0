From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH 2.4] TCP window tracking: core implementation
Date: Thu, 24 Nov 2005 00:27:36 +0100
Message-ID: <20051123232736.GA20035@alpha.home.local>
References: <43819E72.5060704@tac.ch> <20051122165631.GA13716@alpha.home.local>
	<438466C4.5040701@tac.ch> <20051123215429.GA19518@alpha.home.local>
	<4384EE05.9070008@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
Content-Disposition: inline
In-Reply-To: <4384EE05.9070008@drugphish.ch>
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

On Wed, Nov 23, 2005 at 11:32:37PM +0100, Roberto Nibali wrote:
> Hello Willy,
> 
> >>Could you batch my patchset for your next -hf series, please? I'll try
> >>to get you a tcpdump with erroneous behaviour regarding window tracking,
> >>so you can verify this as well.
> >
> >No, and I'm sorry to insist in this direction : the -hf tree is only a
> >*selection* of patches from next mainline version(s). It's targetted at
> 
> Stupid me, I didn't mean -hf series, I meant the experimental 2.4.x 
> kernel series we're going to start.

OK, I'm reassured.

> >the users who cannot risk an upgrade to the next -pre-something, but who
> >still need security or stability fixes. Under no circumstance should I
> >add new features to this tree.
> 
> Of course. Although tcp window tracking could be seen as a security fix.

I knew you would say this, I left the window open on purpose :-)

> >I'm currently thinking about another tree (something like 2.4-enterprise)
> >which would host those patches absolutely needed for people with higher
> >expectations than "normal" users. Nflog, window-tracking, epoll, and
> 
> I'm probably going to drop the nflog stuff, since it is not really used 
> in 2.4.x. Also the tcp window tracking can happily live without it.

OK, I did not know. I've long believed that it really relied on it. Maybe
it's only for the INVALID logs ? Most often, /dev/null wants to eat them.

> >jiffies64 immediately come to mind, but possibly a small bunch of others
> >too. And I hope to count you among the patch contributors ;-)
> 
> Sure thing.

cool.

> >>This is of course possible but could potentially lead to a lot of
> >>exception code. I reckon that it's safe enough to fallback to classic
> >>packet filtering when dealing with non-RFC conform TCP clients or
> >>applications. Meanwhile I've found the problem with the NOTRACK hanging
> >>and will propose a fix in another thread I've started.
> >
> >OK, I don't have much idea about how to proceed with the NOTRACK yet
> >because in the past I could not get it to work along with 
> >window-tracking.
> >So of course I'm interested :-)
> 
> It's not supposed to work with window tracking other than not 
> influencing it. I use the NOTRACK feature to simulate the old ipchains 
> or ipfwadm behaviour. So when using NOTRACK you need to map the TCP 
> states into to filter rules yourself. While window tracking (looking at 
> TCP) is an n-tuple (n>7) check on the skb, NOTRACK is a simple 5 to 
> 7-tuple check with no memory constraints:
> 
> <srcIP, srcPORT, destIP, destPORT, proto, (TCPflags, interface)>
> 
> I'll send you the semantics off-list.

OK thanks, now I understand what you do.

> Best regards,
> Roberto Nibali, ratz

Cheers,
Willy
