From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Help Needed in Connection Tracking/NAT
Date: Wed, 25 Feb 2004 01:14:13 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402250104170.18273-100000@filer.marasystems.com>
References: <1077631840.3772.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nagaraj G <gnraj@teneoris.com>
In-Reply-To: <1077631840.3772.48.camel@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Feb 2004, Nagaraj G wrote:

> I am a developer working on a new application module (NAT ALG) using the
> netfilter NAT/ConnTrack framework.
> 
> I am using Linux 2.4.10 kernel.

Please upgrade. There has been substantial changes in the NAT framework
interface in later Linux-2.4 releases.

> 3. In one scenario, the response packet comes from MY_PORT destined to
> MY_PORT. In this scenario, my Nat_Expect function gets called for
> MANIP_DST and I supply the destIp and destPort (which again is MY_PORT)
> of the internal host in multi_range structure and call nat_setup_info.
> After this I attach my helper to the info supplied. After this, I get
> called into my Nat_Help routine to handle this packet for the contents
> which I do and complete the packet. After this, for all the outgoing
> packets destined to MY_PORT, I don't see my Nat_Help routine getting
> called. The packets go out without the content being mangled.

Ok. This case is different as MY_PORT is not the destination port. I am 
not sure how to set the NAT helper protocol of expected connections once 
accepted.

> 4. In another scenario, the response packet comes from a new port Y
> destined to MY_PORT. In this scenario also, I do the same things as in 3
> above. But, in this case, I get called for all future packets going out.

I think these will be automatically recognised to use the same NAT helper
due to the destination port of the connection being MY_PORT. Not sure if
this is intentional or not (probably should not as it is an expected
connection, not a new connection).

Regards
Henrik
