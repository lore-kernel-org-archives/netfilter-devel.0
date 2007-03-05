From: "Alexander Sirotkin" <demiourgos@gmail.com>
Subject: Re: TCP/UDP checksum in hardware
Date: Mon, 5 Mar 2007 11:49:14 +0200
Message-ID: <c4357ccd0703050149p508d3b2ej80cbdeaccbdbd3b5@mail.gmail.com>
References: <c4357ccd0703040726ie905103rd60c87c8a35923c8@mail.gmail.com>
	<45EAFEF7.7050404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45EAFEF7.7050404@trash.net>
Content-Disposition: inline
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

On 3/4/07, Patrick McHardy <kaber@trash.net> wrote:
> Alexander Sirotkin wrote:
> > It appears that Netfilter does not exploit the hardware TCP/UDP
> > checksum functionality present in some network cards, i.e.
> > NETIF_F_HW_CSUM. Is there any particular reason why it is not used ?
>
> With pure NAT we do incremental checksumming, which shouldn't be
> very expensive. One thing I want to do is offload checksumming in
> the cases where we recalculate the entire checksum, but AFAIK thats
> only when helpers mangle the packet.
Oops. That's correct, as it turned out the problem was in the driver -
it did not report to the OS that it supports checksum offloading.
Incremental checksum of pure NAT is indeed not CPU intensive.
>
> > The reason I'm asking is that computing checksum (in case of NAT, for
> > instance) becomes a real problem on embedded devices
>
> Do you have any data to show this?
>
I don't know how relevant this is for netfilter, but yes - if the
device does not support checksum offloading my benchmark which I ran
on 266Mhz MIPS 24K (which is a pretty common processor for residential
gateways) showed that under 80Mbps UDP traffic, with NAT enabled,
checksum check takes about 15% CPU.

BTW, while we are on the subject, the overhead of netfilter itself,
i.e. the difference in CPU utilization of kernel with and without
netfilter on the above platform is more than 5%. Is there anybody hear
willing to discuss this ?
