From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 11:38:42 +0100
Message-ID: <BAY103-F16E9571FF1B70C7DBB70A1B2270@phx.gbl>
References: <43C616B1.6060101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43C616B1.6060101@trash.net>
To: kaber@trash.net
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


Patrick McHardy wrote:

>Marco Berizzi wrote:
>>
>>Patrick McHardy wrote:
>>
>>>>Chain FORWARD (policy DROP 0 packets, 0 bytes)
>>>>pkts bytes target     prot opt in     out     source               
>>>>destination
>>>>   19  1140 ACCEPT     all  --  any    any     anywhere             
>>>>anywhere            policy match dir out pol ipsec strict [0] [1] [2] 
>>>>[3] mode tunnel tunnel-dst 10.1.1.0/24 tunnel-src 10.1.2.0/24
>>>>    0     0 DROP       all  --  any    any     anywhere             
>>>>anywhere            policy match dir in pol ipsec strict [0] [1] [2] [3] 
>>>>mode tunnel tunnel-dst 10.1.2.0/24 tunnel-src 10.1.1.0/24
>>>
>>>
>>>How did you add these rules? It looks like you used "--next" multiple
>>>times without specifying a policy element ..
>>
>>
>>This is the command:
>>
>>iptables -P FORWARD DROP
>>iptables -A FORWARD -m policy --next --dir out --next --pol ipsec --next 
>>--mode tunnel
>>--tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 --strict -j ACCEPT
>>iptables -A FORWARD -m policy --next --dir in --next --pol ipsec --next 
>>--mode tunnel
>>--tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 --strict -j DROP
>>
>>Are they wrong?
>
>Yes, --next is needed only if your policy has multiple elements, like
>"--mode tunnel --tunnel-src 1.2.3.4/32 --next --mode transform". I'll
>fix up the userspace part to reject this incorrect use.

Ok, my fault sorry. Here is my corrected (I hope) iptables rules:

iptables -P FORWARD DROP
iptables -F

iptables -A FORWARD -m policy --dir out --pol ipsec --mode tunnel 
--tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
iptables -A FORWARD -m policy --dir in  --pol ipsec  --mode tunnel 
--tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP

iptables -A FORWARD -m policy --dir in --pol ipsec --mode tunnel 
--tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
iptables -A FORWARD -m policy --dir out  --pol ipsec  --mode tunnel 
--tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP


iptables -A FORWARD -s 10.1.2.0/24 -d 10.1.1.10/24 -j ACCEPT
iptables -A FORWARD -d 10.1.2.0/24 -s 10.1.1.10/24 -j ACCEPT

iptables -L -v output:

root@Calimero:/tmp/RACOON# iptables -L -v
Chain INPUT (policy ACCEPT 11574 packets, 2434K bytes)
pkts bytes target     prot opt in     out     source               
destination

Chain FORWARD (policy DROP 0 packets, 0 bytes)
pkts bytes target     prot opt in     out     source               
destination
    0     0 DROP       all  --  any    any     anywhere             anywhere 
            policy match dir out pol ipsec mode tunnel tunnel-dst 
10.1.1.0/24 tunnel-src 10.1.2.0/24
    0     0 DROP       all  --  any    any     anywhere             anywhere 
            policy match dir in pol ipsec mode tunnel tunnel-dst 10.1.2.0/24 
tunnel-src 10.1.1.0/24
    0     0 DROP       all  --  any    any     anywhere             anywhere 
            policy match dir in pol ipsec mode tunnel tunnel-dst 10.1.1.0/24 
tunnel-src 10.1.2.0/24
    0     0 DROP       all  --  any    any     anywhere             anywhere 
            policy match dir out pol ipsec mode tunnel tunnel-dst 
10.1.2.0/24 tunnel-src 10.1.1.0/24
1074 64440 ACCEPT     all  --  any    any     10.1.2.0/24          
10.1.1.0/24
1074 64440 ACCEPT     all  --  any    any     10.1.1.0/24          
10.1.2.0/24

Chain OUTPUT (policy ACCEPT 5983 packets, 933K bytes)
pkts bytes target     prot opt in     out     source               
destination

Ipsec policy match are never matched: I can ping-pong from-to both sites.
I'm not understand what is wrong.
