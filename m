From: A K A <gello666@yahoo.com>
Subject: NF_STOLEN effect on TCP
Date: Tue, 11 Nov 2003 11:18:14 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031111191814.3664.qmail@web13104.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

(include my email address in your replies).


dear all,

Ok I have been stuck on this for tooo long and cant
figure it out. I have made an LKM which registers to
NF_POST_ROUTING hook. it gets a packet and if matches
a certain criterion then it puts it on to my private
Queue and returns NF_STOLEN. By putting the packet on
the Queue I am delaying the packets by arround 4 ms.

Now here is the problem for the case of a TCP packet:
A TCP SYN was selected to be delayed. So my hook
returns NF_STOLEN and the packet is sent 4 ms latter
using ip_send(), initated by an ioctl called from a
user application. next my host receives a syn+ack and
imediately sends an ack. However the first data packet
is sent out at a delay arround 4ms also. which is very
odd. cuz in the user application the send function is
called right after connect. I was expecting only the
syn packet to be affected because of my delay, but
there is some sort of reaction.

I dont think that its because of some RTT calculations
because when i sendthe SYN packet imdediately and
delay it at the peer then the first data packet goes
on fine. 

Now I have been stuck with this damn thing for a long
while and cant figure out---is it the stealing that
results in this. is this some expected behavior of
TCP. .. please can u help me with this soon.


regards,

Asad

ps: i can send you a trace plot of the tcp seq vs time
as an attachment if you would like to see it.

__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree
