From: Jon Webb <jon_webb@binary-one.com>
Subject: Re: mac dest match
Date: Wed, 05 Jan 2005 19:24:51 -0800
Message-ID: <41DCAF83.5040805@binary-one.com>
References: <645d37c505010511185e63eb1b@mail.gmail.com>
	<20050105211829.GA6225@soldats.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Surda <shurdeek@routehat.org>
In-Reply-To: <20050105211829.GA6225@soldats.localdomain>
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

Peter,
I've had to do this before with regards to testing adhoc wireless 
network protocols. For mac filtering, you are on the right track - 
filter everything you can using routing/iptables rules and set the 
[send|accept|secure]_redirects appropriately. However, the problem is 
that ARP will not live by those rules. Therefore, you must disable ARP 
using ifconfig and then add static entries manually with the arp command.

- Jon

Peter Surda wrote:

>On Wed, Jan 05, 2005 at 01:18:43PM -0600, Vivek raghunathan wrote:
>  
>
>>Hi all.
>>    
>>
>Hi,
>
>  
>
>>I have 3 nodes A, B, C on the same subnet and I would like to create a
>>line topology:
>>
>>A -> B -> C
>>
>>To do this, I need to prevent any MAC packet from A to C from getting
>>across and vice versa.
>>    
>>
>I think it would be easier to use separate subnets and deactivate sending icmp
>source redirects on "B". No need to play with iptables.
>Assuming the network device is always eth0, you'd do something like:
>
>A: ip addr add 192.168.0.1/30 dev eth0
>B: ip addr add 192.168.0.2/30 dev eth0;ip addr add 192.268.0.6/30 dev eth0
>C: ip addr add 192.168.0.5/30 dev eth0
>
>(on B)
>echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects
>
>  
>
>>-Vivek
>>    
>>
>Bye,
>
>Peter Surda (Shurdeek) <shurdeek@routehat.org>, ICQ 10236103, +436505122023
>
>  
>
