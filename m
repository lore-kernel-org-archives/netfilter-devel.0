From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Thu, 2 Sep 2004 10:31:05 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409021029460.17962@filer.marasystems.com>
References: <200409012234.26310.bdschuym@pandora.be>
	<200409020440.i824e8Jl020613@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: davem@redhat.com, usagi-core@linux-ipv6.org,
	netfilter-devel@lists.netfilter.org, bdschuym@pandora.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200409020440.i824e8Jl020613@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2 Sep 2004, Yasuyuki Kozakai wrote:

> You forgot to find "Jumbo Payload Option" in Hop-by-Hop Options header.
> Other options may exist in this header.
>
> And please truncate packet if actual packet length is greater than
> Jumbo Payload Length + IPv6 header length.

Hmm.. a bridge should not touch the packet content unless absolutely 
needed to fulfill the Ethernet requirements. Why should it do this on 
IPv6?

Does Netfilter require that too large packets have been truncated?

Regards
Henrik
