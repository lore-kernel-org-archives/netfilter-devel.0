From: Vivek raghunathan <vivek.raghunathan@gmail.com>
Subject: mac dest match
Date: Wed, 5 Jan 2005 13:18:43 -0600
Message-ID: <645d37c505010511185e63eb1b@mail.gmail.com>
Reply-To: Vivek raghunathan <vivek.raghunathan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hi all.

I am a graduate student doing wireless networking research. I am doing
some performance analysis for a testbed implementation of a new
routing scheme for such networks. The biggest problem in doing testing
is that it is very difficult to create reliable network topologies
using commercially available 802.11 cards. While I could go on about
the problem at length, here's why I write this email.

I have 3 nodes A, B, C on the same subnet and I would like to create a
line topology:

A -> B -> C

To do this, I need to prevent any MAC packet from A to C from getting
across and vice versa.

I am currently using iptables mac-source matching to do this. At C, I
filter out all packets from mac address of A and vice versa. However,
with mac-source matching, packets from A to C still cross over the
wireless to C before being dropped at the INPUT hook at C.

I plan to write a mac-dest match for iptables that lets me filter out
packets based on destination MAC address. This will let me drop the
packets from A to C at A before they cross the wireless rather than at
C after they cross the wireless.

I wonder if somebody else has written such a mac-dest match already ...

-Vivek
