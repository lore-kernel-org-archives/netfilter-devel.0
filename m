From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: Deleting Connection Tracking information
Date: Tue, 9 Jul 2002 01:31:53 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708233153.GB30970@aaricia.hemmet.chalmers.se>
References: <AE696B0F5B44A348B8D18E40F976D9571BA92E@mailsrv.etagon.com> <200207081143.g68Bh6806571@vulcan.rissington.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Antony Stone <Antony@Soft-Solutions.co.uk>
Content-Disposition: inline
In-Reply-To: <200207081143.g68Bh6806571@vulcan.rissington.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-08 12:43:01+0100, Antony Stone <Antony@Soft-Solutions.co.uk> ->
> On Monday 08 July 2002 1:31 pm, Tsachi Sharfman wrote:
> 
> > Hi,
> >
> > I would like to add a NAT rule on a gateway while connections are passing
> > through it, and have the rule apply to existing connections. I understand
> > this is not the behavior when the rule is simply added to the NAT table,
> > since netfilter consults the NAT table only for the first packet of the
> > connection. I assume that if I can delete connection tracking information
> > on the gateway, once a packet belonging to an existing connection passes
> > through the gateway netfilter will regard it as a new connection (since
> > there is no connection tracking information for it), and apply the new NAT
> > rules that existing connection. My questions are:
> >
> > 1.	Is my assumption correct?
> 
> Depends whether you're talking about TCP connections or not.
> 
> If you are talking about TCP, then I do not believe this assumption is valid, 
> because only the very first packet of a connection contains the SYN flag, and 
> only the second packet contains the SYN/ACK, which are the first two steps of 
> the TCP three-way handshake.   Without those the connection tracking system 
> won't set up an ESTABLISHED connection, and the automatic NAT rules won't 
> apply.
> 

That is not true. I suggest reading some old mails in the archive and
documents. Conntrack's state of NEW is NOT the same things as a TCP with
SYN-flag. The FIRST packet is sees in a flow is marked state NEW. 

> However, a more serious problem is what do you possibly want to change in the 
> NAT rules for a connection which is currently in progress, which isn't going 
> to seriously upset either the client or the server on the ends of the 
> connection ?
> 
>  
> 
> Antony.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
