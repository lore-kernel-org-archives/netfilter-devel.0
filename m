From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: Routing decision?
Date: Thu, 18 Sep 2003 13:54:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F699CFF.1020702@able.be>
References: <Pine.LNX.4.44.0309181320030.20799-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1063886077-8622-18"
Cc: netfilter-devel@lists.netfilter.org, dev@able.be
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309181320030.20799-100000@filer.marasystems.com>
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

------------=_1063886077-8622-18
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Henrik Nordstrom wrote:

>On Thu, 18 Sep 2003, Wim Ceulemans wrote:
>
>  
>
>>Wouldn't the firewall be more predictable if the routing decision was 
>>always taken after the packet travels through the OUTPUT chain, even if 
>>it was a packet originating from an unbound socket? In that way the 
>>diagram in the netfilter tutorial would be true in all cases, and also if
>>advanced routing with the ip command is used, it would work with all 
>>packets (originating from bound or unbound sockets).
>>    
>>
>
>The routing takes place before OUTPUT on unbound sockets as it is the 
>routing table who decides the source IP address to use if the socket is 
>unbound, and it is impossible to create the packet without having the 
>source address.
>
>  
>
>>Of course for packets originating from unbound sockets this would lead 
>>to the fact that the routing decision code is gone through twice, but 
>>the first time only for determining the source address, and the second 
>>time to be able to re-route the packet to another interface (based on 
>>marks set in the output chain).
>>    
>>
>
>Yes, and this is what happens when it is needed.
>
>The kernel uses routing before output to find the source IP address.
>
>Then when iptables changes the packet in such manner that the routing may 
>change it calls the routing again, but only if the packet is modified by 
>iptables.
>
>If there is no changes in the packet details iptables does not call 
>routing again as it can be assumed the result will be the same as in the 
>first call.
>
>Regards
>Henrik
>
>  
>
Henrik

Ok, but the problem is that setting a mark on the packet isn't 
considered as a change to the packet, since marks only live in
the kernel and have no effect on the packet.

So, if I want to re-route the packet later on because for example it is 
an http packet (destination port is 80, 1080 or 8080)
then I have to change something in the packet just to be able to 
re-route it. But I don't want to change something in the
packet, I just want to re-route it to another interface based on the mark.

Do you have an idea how we could do this without using unbound packets?

Thanks and Regards
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


------------=_1063886077-8622-18--
