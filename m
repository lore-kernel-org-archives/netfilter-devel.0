From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq and ip_queue
Date: Thu, 26 Feb 2004 09:03:58 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402260842260.7600-100000@filer.marasystems.com>
References: <20040226023731.GE826@hserus.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chandrakanth Chereddi <kanth@hserus.net>
In-Reply-To: <20040226023731.GE826@hserus.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Feb 2004, Chandrakanth Chereddi wrote:

> nfmark and the contrack entries are not of much concern, cause they are
> specific netfilter headers. But, could you probably tell me what the
> routing entries will stop me from doing - Mirroring?, Masquerading?

You can do everything, as long as you do not need to change how the packet 
is routed if the packet you are looking at has already got it's route 
calculated.

For the fine details on when routes are calculated in relation to the 
netfilter hooks see the netfilter hacking howto.

nfmark is not netfilter specific. It is a means whereby netfilter can
provide hints to other parts of the kernel about how this packet should be
processed. Both routing and tc have directives to make use of the nfmark
in the decision process.

> mean, how often does netfilter have to modify routing entries and under
> what circumstances. (Yes, I am newbie to the netfilter arch.)

The routing is primarily modified as part of NAT, to have the packets
rerouted according to the packet headers after NAT. For forwarded packets
this is rarely needed but in cases where NAT is applied to locally
generated traffic there is cases where the packet will be routed even
before it exists (first packet of a unbound session).  See the smallprint
in the netfilter hacking howto for the fine details.

> I do want to implement NAT, but in the userspace, (can this be done!!!).

Ok.

As long as you do not plan on using the conntrack or NAT kernel parts of
Netfilter you are fine, or at least unless the re-routing restrictions
bite you.

What I am saying is that if you are doing NAT or similar packet mangling
in userspace then the conntrack or NAT functions of netfilter must not be
used.

> And one last question, can I set the "policy" on a chain to "QUEUE", I
> wasn't successful in doing that on my machine though.

Never tried, but I do not see any reason why this should not be possible. 
QUEUE is a builtin target primitive in netfilter. But it seems you are 
right, the iptables command does not accept QUEUE as policy. 

Available options:

 * use a single iptables rule with QUEUE target instead of having it as a 
policy.
 * or modify the iptables command to accept QUEUE as a valid policy,
 * or write your own netfilter hook returning QUEUE as verdict, avoiding 
the need of iptables entirely.

Regards
Henrik
