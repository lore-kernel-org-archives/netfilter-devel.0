From: "Jeremy Davis" <jeremy@slicenet.net>
Subject: RE: port-based filtering of ESP packets with in-kernel IPsec?
Date: Wed, 30 Jul 2003 11:45:03 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <KAEOKILOFJNGKODBFBLJKEDCCNAA.jeremy@slicenet.net>
References: <1059540296.16545.305.camel@k7.localnet>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1059540296.16545.305.camel@k7.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I guess I need to get a develop kernel and do some testing.  Purdue aye, I
just moved from Indianapolis, had many friends that attended Purdue.  Been
there a time or two myself.

Jeremy Davis
Security Analyst
Slice Networks

-----Original Message-----
From: netfilter-admin@lists.netfilter.org
[mailto:netfilter-admin@lists.netfilter.org]On Behalf Of Rick Kennell
Sent: Wednesday, July 30, 2003 12:45 AM
To: netfilter-devel@lists.netfilter.org; netfilter@lists.netfilter.org
Subject: port-based filtering of ESP packets with in-kernel IPsec?


I asked about this last week in the general netfilter list, but it
appears that most folks are still using FreeS/WAN for IPsec.

I'm using the in-kernel IPsec and want to be able to filter ESP packets
based on protocol or port number.  These values are encapsulated in the
ESP payload and are unavailable to netfilter.  If I were using
FreeS/WAN, I could use standard netfilter techniques on the ipsec0
device.  With the in-kernel IPsec, there's no extra pseudo-device with
which to examine unencapsulated ESP packets.

It looks too me like netfilter sees the packet as ESP in all chains in
all tables.  (I'd be delighted to be corrected.)

Since ESP packets that reach the mangle INPUT chain are destined for a
local process, why not unencapsulate them just before that point?  It
might still be nice to have an indication that this was once an ESP
packet for filtering, but that could be done by setting a mark in the
mangle PREROUTING chain.

I realize that this would probably require some heavy lifting in the
network layer to accomplish this nesting of functionality.

Am I missing something obvious?

--
Rick Kennell <kennell@ecn.purdue.edu>
Purdue University School of Electrical and Computer Engineering
