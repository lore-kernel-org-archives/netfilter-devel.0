From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 02 Jul 2007 16:46:24 +0200
Message-ID: <46890FC0.9050903@trash.net>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<4688FC41.5070403@trash.net>
	<Pine.LNX.4.64.0707021537390.32643@blackhole.kfki.hu>
	<46890846.90907@trash.net>
	<Pine.LNX.4.64.0707021622320.32643@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707021622320.32643@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Mon, 2 Jul 2007, Patrick McHardy wrote:
> 
>>>> We should really document that with window tracking and NAT you
>>>> must drop INVALID packets to avoid them getting delivered locally
>>>> and causing a RST.
>>>
>>>
>>> Couldn't we do it in NAT itself? I.e drop the packet by NAT if
>>> ip_conntrack_tcp_be_liberal is unset and the packet is INVALID.
>>
>>
>> I'm a bit sceptical about NAT core caring about TCP conntrack
>> specific sysctls, I'd prefer an unconditional drop.
> 
> 
> NAT works on top of conntrack so peeking the flags were not completely
> perverse ;-). If NAT drops INVALID packets undconditionally, that'd
> disable the sysctl flag completely and we had to say "this sysctl
> setting cannot be used if the NAT module is loaded in".


Would it really? The sysctls flag makes *more* packets be regarded
as valid, so I'm not I'm following ..


> 
>>> It'd be backward-incompatible as it'd change the current behaviour but
>>> were more safer (saner) than the present approach.
>>
>>
>> Yes, for this case it definitely makes sense. I'm just wondering
>> whether we'll break anything. Tools like nmap come to mind ..
> 
> 
> Dropping packets is a good thing. :-)


Incoming yes, outgoing .. who knows :)
