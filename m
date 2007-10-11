From: Konstantin Ushakov <kostik@oktetlabs.ru>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
 in preliminary routing decision
Date: Thu, 11 Oct 2007 10:47:45 +0400
Message-ID: <470DC711.4020701@oktetlabs.ru>
References: <470CA4DF.6000803@oktetlabs.ru> <470DA22F.70807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shelob-wplus.oktetlabs.ru ([195.131.132.186]:54698 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752896AbXJKHKm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:10:42 -0400
In-Reply-To: <470DA22F.70807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Konstantin Ushakov wrote:
>> Netfilter team,
>>
>> we use netfilter under linux kernel 2.4.31 and have the problem
>> described below.
>> !Note, that it can be easily reproduced for latest kernels.
>>
>>  - we want to connect to some on tcp port #80
>>  - in the kernel and in some time we get to ip_route_output_slow
>> function
>>  - in this function kernel searches for route for the packet:
>>          if (fib_lookup(&key, &res)) {
>>             res.fi = NULL;
>>             if (oldkey->oif) {               <- oif is zero at this
>> point, so we miss that "if"
>>                 ......
>>             }
>>             ...
>>             err = -ENETUNREACH;
>>             goto out;
>>          }
>>     It fails to find one as we don't have fwmark set for the packet and
>> there is not route for packets without fwmark (see configuration
>> attached). So, ENETUNREACH is returned and the packet fails to be sent.
>> In fact the packet could be routed
>> correctly, but this would happen in ip_build_xmit function in netfilter
>> hook for LOCAL_OUT packets.
>>
>> Questions:
>>  - is it a bug or it's a deliberate decision to have such behaviour?
>>  - is there any known add-hock solution for the problem?
>
>
> Its a consequence of how routing by fwmark works. Its not perfect,
> but I don't see a better solution since the initial routing takes
> place before we even have a packet.
>
> Just add a route to the dummy device or something like that, that
> should make sure you don't get ENETUNREACH.

I'm afraid that dummy route does not solve the problem. I mean
  - we should not pass out the packets, so where should the route lead?
To loopback?
  - another thing is that on 'send' (for, say, some external address,
port 239)
    with dummy route we hang, but if in fact the packet can't be routed,
    we should get ENETUNREACH.

Idea that we had is the following:

we mark all packets that have passed netfilter (mangle table) with a
specific mark (see configuration below).
We add 2 rules:
 - unreachable, for packets that have passed mange table but should not
be routed
 - rule that lookup table #100 for all packets, in table #100 we have
route like
   ip route add default via 127.0.0.2 table 100

Local traffic that goes to tcp port 80 is routed correctly. Forwarded
traffic is not routed,
ENETUNREACH is received on the lan side. BUT for local traffic that
should not be forwarded,
we don't receive UNREACH, 'send' just hangs.

Example:

on host on LAN side of the router:
bash$ nc 192.168.1.5 81
(UNKNOWN) [192.168.1.5] 80 (www) : No route to host

BUT if we issue that same command on the router itself, it handgs.


That's the situation, so two questions:
   - is there any other common way, except for dummy route... or what
should the route look, so
     it does not change behaviour of applications (see comments above).
   - what is wrong with our new idea? I mean it's looks like a bug in
the kernel, but I don't
     understand exactly where it is.

=================================================
Configuration:

# iptables -L -nv -t mangle
Chain PREROUTING (policy ACCEPT 715 packets, 80324 bytes)
 pkts bytes target     prot opt in     out     source              
destination        
  707 78919 MARK       all  --  *      *       0.0.0.0/0           
0.0.0.0/0           MARK set 0xb

Chain INPUT (policy ACCEPT 700 packets, 78677 bytes)
 pkts bytes target     prot opt in     out     source              
destination        

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source              
destination        

Chain OUTPUT (policy ACCEPT 118 packets, 64650 bytes)
 pkts bytes target     prot opt in     out     source              
destination        
    0     0 MARK       all  --  *      *       0.0.0.0/0           
0.0.0.0/0           MARK set 0xb
    0     0 MARK       tcp  --  *      *       0.0.0.0/0           
0.0.0.0/0           tcp dpt:80 MARK set 0xa

Chain POSTROUTING (policy ACCEPT 52 packets, 4796 bytes)
 pkts bytes target     prot opt in     out     source              
destination 


Rules:
0:      from all lookup local
32766:  from all lookup main
32767:  from all lookup default
32768:  from all fwmark 0xa lookup 10
40000:  from all fwmark 0xb lookup 99 unreachable
50000:  from all lookup 100

Thanks once again,
Konstantin.
