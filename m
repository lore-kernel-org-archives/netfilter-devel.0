From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Sun, 08 Jul 2007 02:28:54 +0900 (JST)
Message-ID: <200707071728.l67HStWh022546@toshiba.co.jp>
References: <200707070627.l676R79T003388@toshiba.co.jp>
	<200707071224.l67COMEg022741@toshiba.co.jp>
	<Pine.LNX.4.64.0707071727580.1808@x2>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707071727580.1808@x2>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 7 Jul 2007 17:34:49 +0200 (CEST)

> > My idea is following.
> >
> > - This TCP reset is not initial packet of TCP connection. If it is initial packet,
> >  no address in ICMP packet should be mangled. Jordan, if you see
> >  /proc/net/netfilter/nf_conntrack, you will find the entry matched the TCP packet.
> >
> > - TCP packet was marked as error packet. Because '--state ESTABLISHED'
> >  didn't match the packet. No conntrack entry wasn't assigned to the
> >  packet. Usually, error log by nf_conntrack_tcp should be generated in
> >  such case, but no message is generated in some cases. I don't know why
> >  this TCP reset was handled as error.
> >
> > - Then ICMP error generated at this router was not assigned to any conntrack entry.
> >
> > - nf_conntarck_icmp.c assigns the ICMP error to the conntrack which matches
> >  the TCP reset. But IP_CT_IS_REPLY didn't set to *ctinfo. This is bug.
> >
> >        h = nf_conntrack_find_get(&innertuple, NULL);
> >        if (!h) {
> >                /* Locally generated ICMPs will match inverted if they
> >                   haven't been SNAT'ed yet */
> >                /* FIXME: NAT code has to handle half-done double NAT --RR  */
> >                if (hooknum == NF_IP_LOCAL_OUT)
> >                        h = nf_conntrack_find_get(&origtuple, NULL);
> 
> 
> The local ICMP tracking is basically useless nowadays since we always
> manually attach the conntrack reference from the original packet
> (exactly because of the half-done double NAT FIXME quoted above).
> But this is an interesting case, the connection tracking code itself
> thought the RST was invalid, but ICMP tracking will still associate
> the ICMP containing the RST with the original connection. I'm wondering
> whether it should really do that. In case it shouldn't, just removing
> all locally generated ICMP special-casing should also fix the bug,
> right?

At first I thought so. But I didn't come up with any bad situation caused
by returning ICMP error to such invalid packets.

-- Yasuyuki Kozakai
