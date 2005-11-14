From: Tom Dickerson <tomdi@bangkok-peakoil.com>
Subject: Need help combining packets in netfilter driver...
Date: Mon, 14 Nov 2005 13:44:15 +0700
Message-ID: <4378323F.4010001@bangkok-peakoil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hi Everyone,

I have a situation where we must send a large number of small packets 
over a relatively slow wireless link. I have a quick custom compression 
algortihm which can save alot of bandwidth for only a few machine 
cycles, but the sheer number of packets will swamp the wireless link. 
Due to handshaking on the wireless link, I must aggregate N small 
packets into 1 large packet, where N is determined by the number of 
compressed packets I can fit into a single 1500 byte packet. All traffic 
I am concerned with is UDP, and originates from a set of well known 
ports and machines, destined to a set of well known ports and machines.

I am trying to design something for in house use that is quick, dirty 
and most importantly fast. I need something that will do 300k+ pps. That 
is a challenge enough in itself, even without the compression filter. 
The compression algorithm will only add a few hundred machine cycles per 
packet...negligible in comparison to the netfilter infrastructure.

This will be my first attempt at writing anything with netfilter. Can 
someone suggest the quickest and most reliable way to aggregate a number 
of individual UDP packets into a single 1500 byte packet? The data is 
also a real time stream and latency is very important. I need to 
guarantee a minimum of 5000 pps over the wireless link. Thus, if I don't 
have a full 1500 bytes after 200 microseconds, I need to force the 
aggregate packet to be sent anyway.

My first plan was to hook in at POSTROUTING after all routing had been 
performed. In that hook I would simply compress and buffer the data in 
private storage, returning DROP for all the packets until I got a 
complete buffer. If the buffer was complete, I'd replace the skb with my 
own skb consisting of the aggregate packets I had stored and return ACCEPT.

This seemed simple, but it is not clear how to get the 200 microsecond 
timer behavior that I need in this case. Can I force my POSTROUTING hook 
to be called every 200 microseconds even if there is no traffic?

Also, on the receiving side, I need to reconstruct the original packet 
stream. I was thinking that in the PREROUTING hook I could simply 
decompress the packet back into the original packet stream. But this 
means I have to inject N-1 new packets directly into the netfilter 
stream. Can this be done from the PREROUTING hook?

Note that the Linux box is simply acting as a router for these packets. 
The packets are generated on remote servers and are destined for remote 
servers. There are no userspace programs involved in the packet 
transactions.

Can someone who is experienced suggest the correct way to implement a 
compression filter like this? Is there a way to make this very quick? 
Since this is such a specialized case I could even accept bypassing the 
routing tables and filtering altogether. The traffic will simply be 
coming in one gigabit ethernet card and heading out the other.

Any and all advice is appreciated,

Thank you in advance,

Tom Dickerson
tomdi@bangkok-peakoil.com
