From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Any way of knowing a packet's been defragmented
Date: Thu, 19 Aug 2004 14:00:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408191346500.2389@filer.marasystems.com>
References: <W5101410375481091705422@asteria.telenet-ops.be>
 <Pine.LNX.4.61.0408051507530.405@filer.marasystems.com>
 <20040819114604.GQ3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Bart De Schuymer <bdschuym@pandora.be>, shemminger@osdl.org,
   netfilter-devel <netfilter-devel@lists.netfilter.org>,
   bridge <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819114604.GQ3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Aug 2004, Harald Welte wrote:

>> Eh.. I do not claim to be a bridge guru, but won't such bridge cause
>> serious havoc on the network much like PMTU blackholes does?
>
> Nobody ever replied to that question.

Actually it was replied but with other words.

The bridge has to drop oversized frames when bridgeing between media of 
different MTU size due to the simple fact that it can not send them out 
without violating the specifications of the target media. A bridge can not 
be responsible for fragmenting oversized packets mainly due to the fact 
that the bridge is not a router and fragmenting of packets is not defined 
at the ethernet level. In addition it can not respond with ICMP MUST 
FRAGMENT as it does not have an IP. It is also from the fine details about 
which level the bridge operates at (Ethernet, not IP).

It is the administrators responsibility to make sure he does not build a 
IP network where bridgeing between different media will cause packets to 
be dropped. This means that it is theoretically OK to bridge between media 
of different physical MTU size as long as all hosts on the side with 
larger MTU knows the actual MTU of the full network segment, not just 
their physical media. This for example makes perfect sense in a transit 
network.

As I view it it is just a minor issue on bridge specification compliance, 
nothing really important. The resolution is to modify slightly where in 
the process the bridge drops oversized packets. It should be on transmit, 
not forward, where the difference between the two is mainly which 
Netfilter hooks has been called. This change also allows conntrack to do 
it's work like normal as the bridge will then only drop packets if 
oversized after it has left all the netfilter bridge hooks.

Regards
Henrik
