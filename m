From: Martijn Lievaart <m@rtij.nl>
Subject: Re: writing a fragmentation-needed patch
Date: Sun, 30 Mar 2003 12:14:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E86C399.7020209@rtij.nl>
References: <3E85D60D.7040304@rtij.nl> <20030330093514.GA1098@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030330093514.GA1098@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:

>>I have written a patch for ipt_REJECT that enables iptables to send back 
>>fragmentation-needed. This is useful for testing PMTUD problems. It 
>>works for me now, but needs some polishing before I release it.
>>
>>Questions:
>>- Would such a patch have a chance to be submitted to pom?
>>    
>>
>
>Two questions:
>
>- why is it a patch against REJECT, instead of a standalone target?
>

Because it feels (felt) right. It's the only subtype of 
icmp-dest-unreach that is not handled in REJECT.

Advantage:
- 99% of the code of a new target would be identical to ipt_REJECT, so 
we avoid a lot of code replication.
Disadvantage:
- uncompatible with fake-source patch. Note that ipt_REJECT should imho 
be rewritten anyhow, it's to rigid now. I guess this is not a real 
option as that would invalidate the fake-source patch so we would get 
patch on patch.

What do you think?

>- how would you concretely use it to test PMTUD problems?
>  
>

I need this because we use a firewall that does not document how it 
handles-fragmentation needed. Going through tech-support did not give 
satisfactory answers, besides I want to see it on the wire before I 
believe what really happens. (And no, replacing the firewall with a 
better one is not an option :-( ). As out webservers run on HP/UX that 
seems to have some problems with fragmentation-needed if not handled 
correctly by the firewall (this may be lore, I intend to prove it 
doesn't have these problems).

 So we need to really know that it really works before we fully enable 
pmtud on our servers, it was disabled because it caused /strange/ 
problems with the webservers with a previous version of the firewall 
(that probably just dropped the frag-neededs). And I mean /strange/ 
problems, once pmtud kicked in for one connection, all connections on 
that interface where affected, until finally the traffic just stopped. 
As this was before I worked there I think much of what is known about 
the problems, and possibly even the description of the problems 
themselves, may be incorrect and/or lore.

An alternative was to set up a test situation with a small mtu somewhere 
in the path. However it is easier for me to write this patch and apply 
it to the endpoint used for testing. Note that you cannot just set the 
mtu of the link at the endpoint smaller, as this will then be advertised 
in the mss for tcp therefore avoiding pmtud with tcp.

Concretely:

Take the following rule(s).

LENGTH=1000
iptables -F INPUT
iptables -A INPUT -s ! 10.0.2.3 -m length --length $((LENGTH + 
1)):0xffff -j REJECT --reject-with icmp-fragmentation-needed --mtu $LENGTH

(10.0.2.3 is the address I use to ssh in to the box, I exclude it in 
case there are problems with the patch. It is not needed now the patch 
works, yet it doesn't hurt either).

Now wget from the webserver, or telnet or do something else to get 
packets flowing. Sniff the wire on all relevant points. Works like a 
charm :-)

Martijn Lievaart

P.S. Replacing HP/UX with another OS is also not an option :-(
