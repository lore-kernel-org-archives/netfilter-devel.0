From: don-netfil@isis.cs3-inc.com (Don Cohen)
Subject: generalized packet modification (inc tcpflags, adding options)
Date: Mon, 30 Jun 2003 09:47:22 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <16128.27034.85530.861667@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
to: "Mohammed Awad" <MAwad@Enppi.com>, Craig Shelley <craig@microtron.org.uk>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


The u32 match I sent in (I think about 6 months ago) was meant as a
generalization of lots of much more specific matches, such as ttl or
length.  I had hoped to generalize that to allow modification of
arbitrary bits in the packet, which would take care of many other
current modules, including the tcp flag example.
I've not gotten around to it, partly because I've not had a specific
burning need, but I'd like to encourage anyone with a better
(competence + motivation) than mine to do that.

It's not immediately clear to me what language would be best for 
describing such modifications and that would probably be worth
discussing on this list.  For that matter, it's not clear what
language is best for describing the match.  My u32 language was
designed to do what seems to be needed for IPv4 but is not good
for IPv6.  I recall someone (Patrick?) supplied a BPF analog of the
u32 match.  (Where can I find that, BTW?)  Is that language capable of
specifying data modification?  Of course other important issues
include run time efficiency and convenience for the user.

All of above seems much more complicated when you start to make
modifications that change the packet size.  (And this includes adding
options.)  I have code that adds a new option but it's not just a
module.  I've changed the kernel to deal with the problem that this
might cause the packet to exceed MTU and if so it might have DF, and
then we want to send back an ICMP reply suggesting a smaller size.
And it gets even more complicated when you try to change things like
TCP payload, which affects TCP sequence numbers of all subsequent
packets in the connection.  I know there are some modules that do this
now, I think related to NAT on protocols that send port numbers in
decimal (so the number of digits can be changed by NAT).

I'd be interested in discussion of a general approach to this problem 
too, but I think it will be a lot more worth while in the short run
(most of the benefit for much less effort) to deal with only changing
the bits that are there and not trying to add or delete them.
