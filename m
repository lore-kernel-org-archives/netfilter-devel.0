From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Fri, 03 Sep 2004 00:23:37 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409021523.i82FNdsY015603@toshiba.co.jp>
References: <200409012234.26310.bdschuym@pandora.be>
	<200409020440.i824e8Jl020613@toshiba.co.jp>
	<Pine.LNX.4.61.0409021029460.17962@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: davem@redhat.com, usagi-core@linux-ipv6.org,
	netfilter-devel@lists.netfilter.org, bdschuym@pandora.be,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hno@marasystems.com
In-Reply-To: <Pine.LNX.4.61.0409021029460.17962@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Henrik Nordstrom <hno@marasystems.com>
Date: Thu, 2 Sep 2004 10:31:05 +0200 (CEST)

> On Thu, 2 Sep 2004, Yasuyuki Kozakai wrote:
> 
> > You forgot to find "Jumbo Payload Option" in Hop-by-Hop Options header.
> > Other options may exist in this header.
> >
> > And please truncate packet if actual packet length is greater than
> > Jumbo Payload Length + IPv6 header length.
> 
> Hmm.. a bridge should not touch the packet content unless absolutely 
> needed to fulfill the Ethernet requirements. Why should it do this on 
> IPv6?

Hmm... Indeed, I don't want br_netfilter to change the packet size when just
loading it...

Maybe alternatives are as follows.

	1. drop such packets. This approach is not different with truncating
	   in that output is not same as input when loading it.

	2. change netfilter modules to use payload length in
	   IPv4 header/IPv6 header/Jumbogram option. Maybe many changes are
	   necessary...

	3. Just trust skb->len even if it doesn't consist with payload length
	   in the headers. I'm not sure what happens in this case. At least,
	   we have to be careful not to bring kernel panic and so on.
	   The advantage of this case is that user can select to drop/truncate
	   by inserting filtering rule.

other idea ?

> Does Netfilter require that too large packets have been truncated?

Many netfilter modules assume that skb->len is the right payload length.
And some modules uses this value to calculate checksum.

> 
> Regards
> Henrik
> 

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
