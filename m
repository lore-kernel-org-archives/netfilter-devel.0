From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: Routing decision?
Date: Mon, 15 Sep 2003 17:29:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F65DACC.8020706@able.be>
References: <Pine.LNX.4.44.0309151632240.16959-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1063639754-20940-2"
Cc: netfilter-devel@lists.netfilter.org, pieter@able.be
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309151632240.16959-100000@filer.marasystems.com>
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

------------=_1063639754-20940-2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Henrik

Thanks for your answer.

If I understand correct, if the local endpoint of the socket is not 
bound, then:
1. The routing decision is taken, and the source IP address is assigned 
to the IP address of the interface
    through which the packet would leave the firewall.
2. The packet travels through the OUTPUT chain and does not pass the 
routing decision anymore, because
     the routing decision was already taken before going to the OUTPUT 
chain.
Is there any specific reason why the packet doesn't pass the routing 
decision the second time?

Regards
Wim

Henrik Nordstrom wrote:

>On Mon, 15 Sep 2003, Wim Ceulemans wrote:
>
>  
>
>>In paragraph 6.2 of the iptables-tutorial the following is said:
>>"The OUTPUT chain is used for altering locally generated packets (i.e., 
>>on the firewall) before they get to the routing decision.
>>    
>>
>
>Yes.
>
>  
>
>>But in paragraph 3.1, the "Traversing of tables and chains" diagram, we 
>>see the "Routing decision" is listed after the "Local process" and
>>BEFORE! the packet goes to the output chain.
>>
>>So which one is right? Does the routing decision take place after or 
>>before the packet travels through the output chain?
>>    
>>
>
>Both, depending on the situation.
>
>if the local endpoint of the socket sending the packet is bound then
>routing occurs after OUTPUT.
>
>If the local endpoint of the socket is NOT bound then routing occurs 
>before OUTPUT to assign the source address.
>
>Regards
>Henrik
>
>
>  
>


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


------------=_1063639754-20940-2--
