From: "calvin" <calvinproject@ihug.com.au>
Subject: can netfilter capture internal network packet?
Date: Sat, 7 Jun 2003 18:37:50 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001101c32cd0$14bdf940$010aa8c0@toowoomba>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>, <netfilter@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all,

I got a serious problem with my netfilter programe.

what i am trying to do is capture a packet frmo A to B in the same network
and direct it to QUEUE.

My setup is

A      B
 \       /
  \     /
  HUB
     | (eth0)
   GW
     |(eth1)
     |
     |

is that possible to: when A send a message to B port 1700 (for example) ,
the iptales in GW can grep the packet and put into queue for processing and
put it back to the line?
I tried to the rules like:
iptables -A INPUT -i eth0 -p udp --dport 17-- -j QUEUE
or
iptables -A INPUT -o eth1 -p udp --dport 17-- -j QUEUE
or both of them.

I can get it works.

I also have a netfilter module, insepecting packetsrc/dest port in the
PRE_ROUTING hook point, also can't get it.

is that any way I can do what I want to do in module? in iptables?

Thanks very much for any of your help..

Regards,
Calvin
