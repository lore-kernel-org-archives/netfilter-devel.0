From: Chandrakanth Chereddi <kanth@hserus.net>
Subject: Re: libipq and ip_queue
Date: Thu, 26 Feb 2004 08:07:31 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040226023731.GE826@hserus.net>
References: <20040225041703.GG19291@hserus.net> <Pine.LNX.4.44.0402252238180.32183-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402252238180.32183-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 25/02/04 22:51 +0100, Henrik Nordstrom wrote:
> On Wed, 25 Feb 2004, Chandrakanth Chereddi wrote:
> 
> > Marking the words *almost anything*, I had my doubts and thought that the
> > devel list would be the best place to get further information.

Thank you for your reply Henrik.

> ipqueue provides you access to the IP packet and payload, but does not
> give you access to the complete MAC header of the packet, only the
> destination MAC address.

I don't think I will need any Layer 2 filtering, so this should not
cause any problem.

> You can modify the packet payload including IP header, but you can not
> modify the nfmark, routing or other skb fields outside the packet payload.
> I think there was a patch floating around to extend ipq with the ability 
> to set the nfmark if needed some time ago (many months).

nfmark and the contrack entries are not of much concern, cause they are
specific netfilter headers. But, could you probably tell me what the
routing entries will stop me from doing - Mirroring?, Masquerading?  I
mean, how often does netfilter have to modify routing entries and under
what circumstances. (Yes, I am newbie to the netfilter arch.)

> In addition, packet mangling via ip_queue or in fact any netfilter hook
> outside the same does not work well together with netfilter conntrack or
> NAT so be careful if you plan on using any of these features.

I do want to implement NAT, but in the userspace, (can this be done!!!).
I don't plan to depend on netfilter for anything more than getting a
packet from kernel space to user space and delivering it back to take
the appt. action. I am guessing that this will not cause any problem,
cause all traffic is either firewalled or mangled only through my
application/

And one last question, can I set the "policy" on a chain to "QUEUE", I
wasn't successful in doing that on my machine though.

Once again, thanks Henrik and the Netfilter development team.

-- 
CCK./
"Passion and gradualness"	-- Pavlov.
