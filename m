From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Mon, 17 Feb 2003 01:39:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E502F45.507@trash.net>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org> <20030215175841.GL30133@calix.csn.tu-chemnitz.de> <3E4EA833.5050504@trash.net> <20030216235507.GN30133@calix.csn.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
In-Reply-To: <20030216235507.GN30133@calix.csn.tu-chemnitz.de>
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

>Hi Patrick,
>
>thanks for enlightening me.
>
>On Sat, Feb 15, 2003 at 09:50:59PM +0100, Patrick McHardy wrote:
> 
>  
>
>>both are set. "|" is logical or. nfs (always?) generates packets bigger 
>>than mtu
>>    
>>
>
>In my new understanding, this very much depends on the MTU and the size
>of the NFS-operation that has to be sent in a single datagram.
>  
>

i read somewhere else nfs is unable to split up some operations over
multiple packets so it has so create bigger packets than local interface
mtu (assuming ethernet mtu).

>>so they are fragmented and have IP_MF set (except last one). If linux 
>>wants to
>>know path mtu it sets IP_DF on these, so the fragments may not be _further_
>>fragmented.
>>    
>>
>
>You are right, my understanding of PMTUD with UDP was slightly wrong.
>So the problem is not unique to NFS, but can appear in any application
>using UDP, with PMTUD enabled? It just needs to send indivisible
>datagrams bigger than the smallest MTU on the route.
>

yes if conntrack is running at the place of the mtu transition.

>I just skimmed through RFC1631, and have to admit I completely forgot
>about NAT changing the packet size. And yes, your idea of considering
>the original size if the packet size decreases by NAT seems to be a good
>way. 
>
>If on the other hand the packet size increases a fragmentation
>notification may confuse the application. In this case it would probably
>be better to do the fragmentation based on the biggest fragment of the
>datagram.
>

this seems like a good idea.

>>even worse we need to store the fragment sizes of each reassembled 
>>packet. if we consider
>>the case not all fragments have DF set and we would want to handle nat 
>>resizing correctly
>>besides fragment sizes we also need fragment boundaries and fragment 
>>flags (-> iph->frag_off).
>>    
>>
>
>But how to calculate the fragment boundaries after a nat-helper has
>shrunken/enlarged the packet? Wouldn't this mean you have to let those
>(fragment-)packets without the DF flag pass (fragmented if necessary)
>and ask for fragmentation of those with DF set?
>
i think the important thing is to preserve fragment sizes. just handle 
all new data
as beeing added at the end and then do the fragmentation.

>But with conntrack you have to choose an all or nothing approach. So how
>do you ask for the retransmission of all packets/fragments?
>
upper layer protocols get the reassembled packet, so there is no way to 
request
retransmission of single fragments. despite that, the sender might not even
no that fragmentation happend.

>Furthermore the ICMP error message may then contain data changed by NAT
>and thus unknown to the application. (But I think somebody (you?) has
>mentioned this before.)
>
yes it was mentioned a number of times. i don't think any os out there tries
to pass fragmentation required messages to an application, but i don't 
know ...

>To me this looks like a situation that cannot be handled properly
>without breaking anything or making some assumptions. :-(
>
>And what about overlapping fragments? The overlapping data might be
>be different after NAT.
>
i think fragmentation as seen during normal communication should not be 
to hard
to handle. the problems are overlapping fragments and many small, 
differently
sized fragments. also normal linux defragmentation which is used atm eats
the ip headers of the single fragments (expect first) during reassembly. 
these may
contain options which also enlarge the packet, so at maybe nop option 
padding or
something like this has to be done (which could turn our to be useful 
for packets
shrunk be nat ;))

bye,
patrick
