From: "andre achternaam" <andreiscmeel@hotmail.com>
Subject: How to add nat rules by another loadable kernel module
Date: Fri, 25 Oct 2002 07:02:17 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F43ZKxt8zPdqJL947FR000004f8@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

Hi coders,

I'm developing a module, but have some difficulty with it. May be some of 
you can put me on the right track.
In my loadable kernel module i want to add the following rule to my nat 
module(s):
iptables -t nat -A PREROUTING -d 192.168.0.50 -i eth0 -j DNAT 
--to-destination 10.255.255.10

I'm aware this is a userspace methode to do it, and i like to know how to do 
this in kernel space. I have looked hours in all kind of netfilter files but 
i don't have any hint how to do it.

Q] Can somebody tell me how to add NAT rules from another loadable kernel 
module or provide some example code?

I don't want to do it with the register_expect stuff since you need a 
releted (master) connection, which i dont have.
Of couse later on i want to delete them as wel with the following 
look-a-like
iptables -t nat -D PREROUTING -d 192.168.0.50 -i eth0 -j DNAT 
--to-destination 10.255.255.10

Thanx in advance for the information.

Andre Kleibeuker


_________________________________________________________________
Surf the Web without missing calls! Get MSN Broadband. 
http://resourcecenter.msn.com/access/plans/freeactivation.asp
