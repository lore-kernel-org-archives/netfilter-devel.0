From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Sun, 08 Jul 2007 02:48:40 +0900 (JST)
Message-ID: <200707071748.l67HmfF1026109@toshiba.co.jp>
References: <200707071224.l67COMEg022741@toshiba.co.jp>
	<Pine.LNX.4.64.0707071727580.1808@x2>
	<200707071728.l67HStWh022546@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, kaber@trash.net
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707071728.l67HStWh022546@toshiba.co.jp>
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

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Sun, 08 Jul 2007 02:28:54 +0900 (JST)

> From: Patrick McHardy <kaber@trash.net>
> Date: Sat, 7 Jul 2007 17:34:49 +0200 (CEST)
> > 
> > The local ICMP tracking is basically useless nowadays since we always
> > manually attach the conntrack reference from the original packet
> > (exactly because of the half-done double NAT FIXME quoted above).
> > But this is an interesting case, the connection tracking code itself
> > thought the RST was invalid, but ICMP tracking will still associate
> > the ICMP containing the RST with the original connection. I'm wondering
> > whether it should really do that. In case it shouldn't, just removing
> > all locally generated ICMP special-casing should also fix the bug,
> > right?
> 
> At first I thought so. But I didn't come up with any bad situation caused
> by returning ICMP error to such invalid packets.

Can kernel correctly return ICMP error without conntrack in this case ?
If so, I agree. (maybe yes, I'll check it after waking up).

-- Yasuyuki Kozakai
