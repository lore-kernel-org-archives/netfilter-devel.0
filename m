From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: Routing decision?
Date: Thu, 18 Sep 2003 09:37:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6960B5.6050303@able.be>
References: <Pine.LNX.4.44.0309151802300.17421-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1063870643-19143-6"
Cc: netfilter-devel@lists.netfilter.org, dev@able.be
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309151802300.17421-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format...

------------=_1063870643-19143-6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Henrik Nordstrom wrote:

>On Mon, 15 Sep 2003, Wim Ceulemans wrote:
>
>  
>
>>If I understand correct, if the local endpoint of the socket is not 
>>bound, then:
>>1. The routing decision is taken, and the source IP address is assigned 
>>to the IP address of the interface
>>    through which the packet would leave the firewall.
>>    
>>
>
>Yes. Or to be more precise to the source IP address of the route by which 
>the packet would leave the host, or interface address if no route source 
>address is defined in the routing table.
>
>  
>
>>2. The packet travels through the OUTPUT chain and does not pass the 
>>routing decision anymore, because
>>     the routing decision was already taken before going to the OUTPUT 
>>chain.
>>    
>>
>
>Yes.
>
>However on the next packet of the connection (assuming it is a TCP
>connection) the situation is the reverse. The local endpoint of the socket
>is now bound and there is no need for a routing decision during packet
>construction as the source IP address is already know. So now routing
>occurs after OUTPUT like it logically should be.
>
>  
>
>>Is there any specific reason why the packet doesn't pass the routing 
>>decision the second time?
>>    
>>
>
>Why should it if the routing has already been called once?
>
>iptables does route the packet a second time if you mangle or NAT the
>packet.
>
>Regards
>Henrik
>
>
>  
>
Henrik

Sorry to come back to this problem.

Wouldn't the firewall be more predictable if the routing decision was 
always taken after the packet travels through the OUTPUT chain, even if 
it was a packet originating from an unbound socket? In that way the 
diagram in the netfilter tutorial would be true in all cases, and also if
advanced routing with the ip command is used, it would work with all 
packets (originating from bound or unbound sockets).

Of course for packets originating from unbound sockets this would lead 
to the fact that the routing decision code is gone through twice, but 
the first time only for determining the source address, and the second 
time to be able to re-route the packet to another interface (based on 
marks set in the output chain).

Regards
Wim


-- 
Wim Ceulemans
R&D Engineer

Secure Internet Communication with aXs Guard

Able NV
Leuvensesteenweg 282 - B-3190 Boortmeerbeek - Belgium
Phone: + 32 15 50.44.00 - Fax: + 32 15 50.44.09
E-mail: wim.ceulemans@able.be



--
Security check on this e-mail has been done by aXs GUARD
(http://www.axsguard.com)


------------=_1063870643-19143-6--
