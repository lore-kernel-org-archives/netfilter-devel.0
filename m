From: Peter Surda <shurdeek@routehat.org>
Subject: Re: mac dest match
Date: Wed, 5 Jan 2005 22:18:30 +0100
Message-ID: <20050105211829.GA6225@soldats.localdomain>
References: <645d37c505010511185e63eb1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <645d37c505010511185e63eb1b@mail.gmail.com>
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

On Wed, Jan 05, 2005 at 01:18:43PM -0600, Vivek raghunathan wrote:
> Hi all.
Hi,

> I have 3 nodes A, B, C on the same subnet and I would like to create a
> line topology:
> 
> A -> B -> C
> 
> To do this, I need to prevent any MAC packet from A to C from getting
> across and vice versa.
I think it would be easier to use separate subnets and deactivate sending icmp
source redirects on "B". No need to play with iptables.
Assuming the network device is always eth0, you'd do something like:

A: ip addr add 192.168.0.1/30 dev eth0
B: ip addr add 192.168.0.2/30 dev eth0;ip addr add 192.268.0.6/30 dev eth0
C: ip addr add 192.168.0.5/30 dev eth0

(on B)
echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects

> -Vivek
Bye,

Peter Surda (Shurdeek) <shurdeek@routehat.org>, ICQ 10236103, +436505122023

-- 
  Hello, this is Bill Gates and I pronounce Monopoly, er, Windows as Windows.
