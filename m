From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: i wanna know exact difference between NETFILTER and IPTABLES
Date: Thu, 5 Feb 2004 10:46:03 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <031901c3eb79$0ccbd140$2601010a@bluereef.local>
References: <Pine.LNX.4.44.0402042317330.19469-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>,
	"rohit persaie" <persaie@yahoo.co.in>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I remember reading quite awhile ago about a proposed change to both the
interface iptables uses and the mechanics of kernel applied rule
replacement. Something about being able to make singular atomic changes to
each rule rather than replace whole tables. Can you (Henrik) or anyone else
shed some light on where this thinking currently stands, whether there's
been a new specification generated to which the core developers are working,
or whether there is in fact some code. I understand that Harald had done
some work on the iptables2 interface? Is this part of this new proposed
interface?

I think everyone would be interested in a quick synopses of where things are
broadly at, in the world of Netfilter.

Thanks,
Andrew.
----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "rohit persaie" <persaie@yahoo.co.in>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, February 05, 2004 9:21 AM
Subject: Re: i wanna know exact difference between NETFILTER and IPTABLES


> On Wed, 4 Feb 2004, rohit persaie wrote:
>
> > netfilter(acts at kernel level )
> >
> > and iptables ( works at user level)
>
> Netfilter provides the hooks required for the iptables firewall to access
> the packets within the Linux kernel. Both run within the kernel. See the
> netfilter hacking guide for details.
>
> To control the ruleset of the iptables firewall kernel the userspace
> program iptables is used. This program is responsible for compiling your
> firewall ruleset into binary form used by the iptables kernel. The
> communication is using getsockopt calls, but this is not really of
> interest to anyone except for the iptables core as it is all wrapped up
> nicely. The exact deatils of the communication between the iptables
> userspace and kernel is not specified in detail other than the source. The
> official interface for talking to the iptables kernel is the iptables
> command.
>
> Regards
> Henrik
>
>
