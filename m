From: Patrick McHardy <kaber@trash.net>
Subject: Re: NAT & FORWARDING
Date: Fri, 30 Jan 2004 16:52:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <401A7DA6.2050207@trash.net>
References: <Pine.LNX.4.44.0401301635121.9279-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Srinivasa Hebbar <sshebbar@yahoo.com>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401301635121.9279-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Thu, 29 Jan 2004, Srinivasa Hebbar wrote:
> 
> 
>>I have a situation that if the dest. IP address of the packet is
>>for the local node, then apply NAT rule, otherwise it should simply
>>forward the packet according to the routing table.
>>
>>How can I achieve the above?
> 
> 
> You need to know which addresses are local. Other than this it is just to 
> do it. DNAT is done in PREROUTING and can change the destination freely.

The addrtype match was written out of a similar need, it matches
what routing thinks of an address. It can be found in
patch-o-matic/extra.

Best regards,
Patrick



> 
> If you want to be able to NAT sessions initiated by the local node then 
> you need to enable NAT of local sessions in the kernel build.
> 
> Regards
> Henrik
> 
