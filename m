From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU (Patrick McHardy)
Date: Sat, 15 Feb 2003 22:00:32 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15951.10496.914173.716313@isis.cs3-inc.com>
References: <20030215232635.25928.78900.Mailman@kashyyyk>
	<15950.60635.389199.836425@isis.cs3-inc.com>
	<3E4F0881.70302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3E4F0881.70302@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy writes:
 > ... since the sender of an icmp fragmentation required includes the
   max. mtu it can handle without fragmenting it is clear it is not to
   be treated as only heuristic.
This doesn't affect my argument of why it must be considered heuristic.

 > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=58084

After reading this it seems to me that this NFS code (or possibly the
kernel code it ends up using) is really to blame.  I don't even
understand why it uses UDP, but that reference sounds like NFS is
really just not prepared for packet loss.  Use of DF for PMTU
discovery is fine but you have to be prepared for loss, including 
the loss of the ICMP packets and you also have to be prepared for
change of network conditions, inc. change of path or MTU.
(Here we could get into another discussion of the role of ICMP in DoS 
attacks, what people do about that, what they should do, etc.  Recall
that ICMP replies are often rate limited, so an attacker can
effectively block almost all of your ICMP replies.)
I think all code that tries to optimize packet size really has to
view it as an ongoing (requiring continual monitoring, since things
do change) heuristic hill climbing type of problem.

As you point out, PMTU is a situation where a value slightly too low 
is fine, slightly too high is terrible (like the old TV show "The
price is right").  That already suggests appropriate heuristics.
