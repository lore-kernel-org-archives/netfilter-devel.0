From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Sat, 15 Feb 2003 21:50:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E4EA833.5050504@trash.net>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org> <20030215175841.GL30133@calix.csn.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
In-Reply-To: <20030215175841.GL30133@calix.csn.tu-chemnitz.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thomas Poehnitzsch wrote:

>>>ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
>>>refragments them at POST_ROUTING without careing about IP_DF. packets
>>>      
>>>
>
>What has IP_DF (I hope you mean the "Don't Fragment" bit in the
>IP-header) to do with _de_-fragmentation? As far as I understood RFC791
>
nothing.

>Could somebody please explain the notation: "IP_DF|IP_MF" to me? Does
>this mean at least one of both flags is set? And if so this is against
>my understanding of the above mentioned RFC791. If IP_DF is set, the
>packet _must not_ be fragmented, so IP_MF can't be set.
>
both are set. "|" is logical or. nfs (always?) generates packets bigger 
than mtu
so they are fragmented and have IP_MF set (except last one). If linux 
wants to
know path mtu it sets IP_DF on these, so the fragments may not be _further_
fragmented.

>
>Let me go through an example of PMTUD and correct me if I am wrong with
>my view of this protocol:
>
>Assume host A wants to send a packet to host B and pmtud is enabled 
>(/proc/sys/net/ipv4/ip_no_pmtu_disc = 0) the IP_DF flag will be set in
>the packet sent. In case this packet will not pass through the eye of a
>needle further down the line, it will be droped and an ICMP Message
>(type 3 code 4: fragmentation needed and DF set) will be sent to A.
>Host A will then resend smaller packets (again with IP_DF set) until the
>packet reaches host B. 
>The way I understand it, there won't be any fragmented packet on the
>line in this connection, so iptables will not break anything.
>
>If on the other hand the IP_DF bit is not set, any host on the route
>from A to B is allowed to refragment the packet to fit the MTU of the
>next connection.
>
>Now I can't see any reason why iptables should not be allowed to
>reassemble and refragment a packet with IP_DF not set.
>

see above.

>
>  
>
>>>The problem is that we _need_ to defragment at NF_IP_PRE_ROUTING in
>>>order to have the be able to do connection tracking.  So at this point
>>>we would need to save the sizes of all individual fragments.  This
>>>would enable us to re-fragment to exactly the same size at
>>>POST_ROUTING. 
>>>      
>>>
>
>Do we really have to re-fragment to exactly the same size? Wouldn't it
>be sufficient to re-fragment to fragments not bigger in size than the
>biggest incoming fragment of this connection?
>
>  
>
>>>And then, what happens if NAT has to resize (enlarge/shrink) a packet.
>>>How should we deal with this while re-fragmenting? 
>>>      
>>>
>
>In my opinion we should just refragment it, as any router would do it.
>
that router is broken too. think about a host doing path mtu discovery, 
the packet
doesn't fit the interface mtu but nat shrinks the packet so it does fit 
.. the host gets
a wrong idea of the pmtu. unfortunately i don't know of a way to fix it 
except maybe
to also consider the removed bytes when deciding if a packet needs to be 
fragmented.

>>And if we go for my first propsal, how/where would we store the
>>list-of-fragment-sizes?  We certainly don't want it to be dynamically
>>allocated... but according to RFC791 there kan be 8192 fragments of 8
>>octets each...
>>    
>>
>
>I think we have to store fragment sizes of each connection, but storing
>
even worse we need to store the fragment sizes of each reassembled 
packet. if we consider
the case not all fragments have DF set and we would want to handle nat 
resizing correctly
besides fragment sizes we also need fragment boundaries and fragment 
flags (-> iph->frag_off).

Bye,
Patrick
