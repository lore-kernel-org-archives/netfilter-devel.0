From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: The latest nf_conntrack
Date: Wed, 10 Nov 2004 23:10:48 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411102300180.4118@filer.marasystems.com>
References: <200411010827.iA18RJGT024881@toshiba.co.jp>
	<20041108134709.GE12437@sunbeam.de.gnumonks.org>
	<200411102151.iAALpOKa016683@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200411102151.iAALpOKa016683@toshiba.co.jp>
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

On Thu, 11 Nov 2004, Yasuyuki Kozakai wrote:

>> I think we were undecided at the workshop about what to do, so it's not 
>> really a difference from the proposed solution ;)
>
> OK, I look like misunderstanding.

There was a lot of minor confusion at the workshop when this specific 
topic (handling of fragments within IPv6 connection tracking) was 
discussed. I remember that it was quite apparent when taking the notes 
that there appeared to be conflicts in several of the ideas, and me 
loosing the relevant notes of the discussion did not make this any 
clearer..

>> yes.  I think it is even worth to change nf_conntrack_ipv4 to do it the
>> same way as ipv6 now does it.  But let's not change too many things at
>> the same time,
>
> Sounds good and it's challenging because we have to consider about IPv4 NAT.

What about keeping the fragments around, and reuse them later unless the 
payload needed to be touched by NAT helpers?

Plain NAT is not really a problem here even if IP theoretically allows 
fragments covering the protocol header, only the use of NAT helpers is of 
major concern to how to handle fragments in IPv4 NAT. Fragments covering 
the protocol headers can be considered invalid as these would require the 
initial fragment to go below the minimum allowed fragment size.

Regards
Henrik
