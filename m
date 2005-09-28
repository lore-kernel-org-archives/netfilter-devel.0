From: Amin Azez <azez@ufomechanic.net>
Subject: snat bridge routes reply packets
Date: Wed, 28 Sep 2005 17:05:44 +0100
Message-ID: <dhef0t$mj3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I have a bridge setup snat'ing some IP's that aren't actually on the
bridge subnet.

That works fine except that the nat code doesn't know what to do with
the de-snat'd packets and tries to send them to the default gateway.

This makes sense, but it's routing, not bridging.

Bridging dnat would keep track of the physdev and src mac as well as the
src ip and ignore arp altogether when re-issueing the de-snat'd
responses; it would write the de-snat'd packet back out to the original
interface and targeted to the original mac.

I think bridging snat can be detected when the target mac of the packet
that causes the conntrack to be created does not match the mac of the
physdev the packet comes in on (i.e. the snat'ing box is not being used
as a gateway).

In such cases the physdev and srcmac must be saved.

(Co-incidentally I'm already doing this in my contrack mods which will
no doubt get merged into nf_conntrack that does some layer 2 stuff)

So my real questions are:
1) Am I nuts?
2) Any tips on skipping the arp cache stuff on the de-snat'd response,
as I have a reference to the physdev and target mac already available?

I also think there is some mileage in checking the src_mac when looking
up conntracks in the orig direction, to avoid having to presume that the
same ip address does not exist on different physdev of the same bridge -
to thus allow them both to be snat'd independantly.

Sam Azez
