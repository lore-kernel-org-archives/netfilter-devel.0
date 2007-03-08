From: "Alexander Sirotkin" <demiourgos@gmail.com>
Subject: Re: TCP/UDP checksum in hardware
Date: Thu, 8 Mar 2007 12:15:11 +0200
Message-ID: <c4357ccd0703080215p659147bdhefb023d93ae889fd@mail.gmail.com>
References: <c4357ccd0703040726ie905103rd60c87c8a35923c8@mail.gmail.com>
	<45EAFEF7.7050404@trash.net>
	<c4357ccd0703050149p508d3b2ej80cbdeaccbdbd3b5@mail.gmail.com>
	<45EC5C3F.6060401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45EC5C3F.6060401@trash.net>
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

On 3/5/07, Patrick McHardy <kaber@trash.net> wrote:
> Alexander Sirotkin wrote:
> > On 3/4/07, Patrick McHardy <kaber@trash.net> wrote:
> >
> >> Alexander Sirotkin wrote:
> >> > The reason I'm asking is that computing checksum (in case of NAT, for
> >> > instance) becomes a real problem on embedded devices
> >>
> >> Do you have any data to show this?
> >>
> > I don't know how relevant this is for netfilter, but yes - if the
> > device does not support checksum offloading my benchmark which I ran
> > on 266Mhz MIPS 24K (which is a pretty common processor for residential
> > gateways) showed that under 80Mbps UDP traffic, with NAT enabled,
> > checksum check takes about 15% CPU.
>
> The first question would be whether this is really checksumming
> done by netfilter or by the UDP code. Since enabling checksum
> offloading seems to help, this points to the UDP code. In case
> it is netfilter, the second question would be whether its
> checksum verification or updates.
>
> > BTW, while we are on the subject, the overhead of netfilter itself,
> > i.e. the difference in CPU utilization of kernel with and without
> > netfilter on the above platform is more than 5%. Is there anybody hear
> > willing to discuss this ?
>
> Is this with netfilter modules (like iptables, conntrack, NAT, ...)
> loaded or just by enabling netfilter in the configuration?
>
Just netfilter, no modules.
Strangely enough, this only happens with bridge configuration. With
router configuration the difference in CPU utilization is minor,
however with bridge it is huge - about 25% on my system.

> BTW, which kernel version are you talking about?
>
2.6.16.22
