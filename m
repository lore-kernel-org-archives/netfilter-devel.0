From: Wim Ceulemans <wim.ceulemans@able.be>
Subject: Re: Routing decision?
Date: Thu, 18 Sep 2003 15:39:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F69B585.50203@able.be>
References: <Pine.LNX.4.44.0309181507020.21129-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1063892355-22680-4"
Cc: netfilter-devel@lists.netfilter.org, dev@able.be
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309181507020.21129-100000@filer.marasystems.com>
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

------------=_1063892355-22680-4
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ok, thanks Henrik, we will try the mark in the mangle table.

Regards
Wim

Henrik Nordstrom wrote:

>On Thu, 18 Sep 2003, Wim Ceulemans wrote:
>
>  
>
>>Ok, but the problem is that setting a mark on the packet isn't 
>>considered as a change to the packet, since marks only live in
>>the kernel and have no effect on the packet.
>>    
>>
>
>Changing marks are considered a change in the packet in this context.
>
>If mangle OUTPUT changes any of Source IP, Destination IP, ToS or nfmark
>then the packet is automatically rerouted by iptables.
>
>Regards
>Henrik
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


------------=_1063892355-22680-4--
