From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Thu, 2 Sep 2004 21:25:52 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409022125.52433.bdschuym@pandora.be>
References: <200409012234.26310.bdschuym@pandora.be>
	<200409020440.i824e8Jl020613@toshiba.co.jp>
	<Pine.LNX.4.61.0409021029460.17962@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@redhat.com, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <Pine.LNX.4.61.0409021029460.17962@filer.marasystems.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 02 September 2004 10:31, Henrik Nordstrom wrote:
> On Thu, 2 Sep 2004, Yasuyuki Kozakai wrote:
> > You forgot to find "Jumbo Payload Option" in Hop-by-Hop Options header.
> > Other options may exist in this header.
> >
> > And please truncate packet if actual packet length is greater than
> > Jumbo Payload Length + IPv6 header length.
>
> Hmm.. a bridge should not touch the packet content unless absolutely
> needed to fulfill the Ethernet requirements. Why should it do this on
> IPv6?

Well, it's the bridge-nf code that touches the packet, not the bridge code and 
bridge-nf can be disabled. I don't see any real difference between this and 
doing NAT (f.e.) on a bridged packet, except of course that the user doesn't 
have any control over it.

Note that bridge-nf for the IPv4 case does this:
	if (skb->len > len) {
		__pskb_trim(skb, len);
		if (skb->ip_summed == CHECKSUM_HW)
			skb->ip_summed = CHECKSUM_NONE;
	}

cheers,
Bart
