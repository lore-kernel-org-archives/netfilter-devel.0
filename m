From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: netfilter observation
Date: Fri, 27 Jan 2006 20:31:28 +0900 (JST)
Message-ID: <200601271131.k0RBVTIv006273@toshiba.co.jp>
References: <20060127061433.GA31447@oknodo.bof.de>
	<20060127084937.432199b1@pulsar.inexo.com.br>
	<20060127111340.GB31447@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ethy.brito@inexo.com.br, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: bof@bof.de
In-Reply-To: <20060127111340.GB31447@oknodo.bof.de>
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

From: Patrick Schaaf <bof@bof.de>
Date: Fri, 27 Jan 2006 12:13:40 +0100

> > > In the filter table, matches like '-m conntrack' can be used to
> > > refer to the NAT state of the packet under inspection.
> > 
> > I can't see how this could help me. The old data stream has already its state set
> > to ESTABLISHED.
> 
> Hmm. You could use different connmark mark values, and match on those
> in the filter table. When you flush your NAT rules and rebuild them,
> use a different set of mark values, and use the same mark values
> in the filter table.
> 
> That's not supposed to be a nice, clean solution. But I think
> it could work.
> 
> > > per-flow: [...] one of the new style userlevel conntrack manipulation
> > tools (work in progress, as far as I know)
> > 
> > Could you gimme some pointer about these tools? They are not in trunk/conntrack
> > tree and google was not of much help (too much garbage to dig into).
> 
> Sorry, I did not really track the relevant discussions.
> 
> Help/HOWTO/Pointers, somebody?

man page of 'conntrack' is here.

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/conntrack/

Maybe what you want to do is 'conntrack -D conntrack .....'.

-- Yasuyuki Kozakai
