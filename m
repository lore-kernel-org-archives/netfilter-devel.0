From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Injecting a brand new packet.
Date: Wed, 21 Jan 2004 17:02:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400E9481.3080000@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I'd like some advices on the following as I would not like to do it 
wrong and be obliged to started it again and again from scratch.

In my framework, upon reception of a certain message, the host running 
netfilter needs to inject a TCP packet in the network on behalf of 
another machine.

I started to implement this from scratch by building my own TCP packet 
that I was thinking to send with the ip_build_and_send_pkt (it seems to 
fit my needs as I can specify the source and destination IP addresses). 
So far, I filled my TCP header except the checksum (I guess I'll find a 
function to do so), I initialized a socket, and I have now to initialize 
the struct sk_buff, which I don't know yet how to do.

Now two questions haunt my mind:
 - is there something alike in any part of the netfilter code? It would 
avoid me to reinvent the wheel.
 - if not, do you think I choose the good way? Particularly because I'm 
not totally sure about the exact functionality of this 
ip_build_and_send_pkt function.

If you have a good advice on that, I appreciate your help a lot.

          Emmanuel
