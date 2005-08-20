From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 00:38:53 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
References: <20050820172824.GE5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>
	<20050820202552.GF5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20050820202552.GF5638@aaricia.csbnet.se>
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


>Its a _very_ large router infront of a student network. It house sover 2000
>computers behind it and has a traffic amount between 50Mbit and 400Mbit
>(night and day) for each of the 2 large main interface. Now the machine has
>and additionally 30 interfaces. Most of them virtual VLAN interfaces. Point
>is, this is a _very large_ routing machine. The machines work can't be done
>in 63 rules. No way. Not with all the functions i have. The large amount of

The question is: how different do all these 2000+ hosts need to be classified?
I can't think of anything but to let everything through with possibly 
exceptions like SMTP and HTTP (going over proxies there).

>interface but with slithly different paramters such as ip-range, limiters
>and other things.

Other things like?
Matching by interface might eliminate the need to test ipaddr/iprange.
Matching by ipaddr/iprange might eliminate the need to test interface.
Discrete logic is the key ;)

>Seen it, however im running on a 2.4.23-kernel. (It will take weeks to test
>and patch a new 2.6-kernel not even knowing if it will crash.

You know that 2.4.31 is current, and .23 is more error prone to security flaws
(oh, did you mention you are a DDOS target? Think again!)

>A crach isn't affordable on this router.

Just have a fast recover lane. :)

>Need to backport it then and it still wont really solve the problem as i which
>to reduce the flow most packets takes. In both mine existing and your solution
>the packets we want to save will still take the jump to chain_tcpsyn and then
>back.

A goto does not come back.

>In your solution back "two step", in mine back the two steps by yet
>another match. My better solution wont jump at all, however needing another
>(fast) match, the RETURN.

How do you know two packet comparisons are faster than a iptable stack jump?
Given that each operation was valued "1" and that the first rule of
"chain_tcpsyn" always matches for our hypothesis...

>>>iptables -N chain_tcpsyn
>>>iptables -A chain_tcpsyn -m limit (+1) --limit 1000/s (+1) -j RETURN (+1)
>>>iptables -A chain_tcpsyn -m limit 1/s -j LOG --log-prefix "FW raw chain_tcpsyn"
>>>iptables -A chain_tcpsyn -j DROP
>> 
>>>iptables -N chain
>>>iptables -A chain -p tcp (+1) --syn (+1) -j chain_tcpsyn (+1)
>>>iptables -A chain -p tcp (+1) --syn (+1) -j RETURN (+1)
>>>iptables -A chain -p tcp -j chain_tcp
>>>iptables -A chain -p tcp -j RETURN
>> 
>>ipt -A chain -p tcp (+1) --syn (+1) -g chain_tcpsyn (+1)
>>ipt -A chain -p tcp -g chain_tcp
>>ipt -A chain -p udp -g chain_udp

... in your case, you would need

  -p tcp --syn -j chain_tcpsyn
  -m limit --limit 1000/s -j RETURN
  -p tcp --syn -j RETURN
  == 9 operations

to exit finish the chain named "chain", while I need

  -p tcp --syn -g chain_tcpsyn
  -m limit --limit 1000/s -j RETURN
  == 6 operations to do so.

In fact, you do 3 jumps (one enter, two exits) while I do only 2 (one goto and
one exit). And a goto is usually less expensive than a jump since it does not
push a return-chain onto the netfilter stack.



Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
