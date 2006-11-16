From: Gilles Kerdoncuff <gkerdoncuff.ext@orange-ftgroup.com>
Subject: Re: [PATCH] Update SNMP basic for full IP address NAT
Date: Thu, 16 Nov 2006 16:05:42 +0100
Message-ID: <455C7E46.6080404@orange-ftgroup.com>
References: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetele	com.fr>
	<455AB76C.9050603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <455AB76C.9050603@trash.net>
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

Hi Patrick,

** The purpose of my patch, for SNMP, is to fully benefit of the NAT 
feature on a residential gateway (RFC2962 - Basic method)

SNMP traps from any device in the local network can be sent to a Network 
Management Station (NMS) in the ouside world (using the MASQUERADE or 
SNAT rule found on any gateway). The local IP of the agent in the 
payload is natted to the public address.

In addition, SNMP requests from outside world NMS can reach a device in 
the local network with a specific DNAT rule. Some requests ask for the 
IP address table. In that case, the local IP in the response, its natted 
to the public IP of the gateway.

So when we have to NAT from a local network to an internet public 
address, the full IP has to be natted, not only the first byte.


** I understand that you'd like to keep the /8 behavior, yet, something 
still troubles me with the current ip_nat_snmp_basic.c file :

The from/to fields of the oct1_map structure are filled-in by calling 
the NOCT1 (0xFF mask) macro on the tuple IP.
Which means that on a 192.168.1.x address, it takes the x part.

On the second hand, the mangle_address routine is called with 
"ctx->pointer - 4", which points to the beginning of the IP. So, the 
routine will compare the x part to the '192' part !!

Am I misinterpretting the code or is it really a bug ?
My understanding is that the '192' part of the address should be subject 
to the NAT translation, correct ?

** Anyway, if any use case for the /8 behavior exists, I don't mind 
adding a parameter to test only the first 8,16,24 or 32 bits of the 
address, keeping /8 as a default.


BR
Gilles



Patrick McHardy wrote:
> Gilles KERDONCUFF wrote:
>   
>> This patch applies to the netfilter file   nat_ip_snmp_basic.c
>>
>> The algorithm now applies NAT to the complete IP address (and not only
>> the first byte) It also recomputes the UDP checksum accordingly.
>>
>> Please apply this patch to the 2.6.18.1 official release.
>>     
>
> What exactly is the purpose of this? My understanding of this module
> (which might be wrong) is that it maps an entire /8 network, including
> addresses not participating in the current connection. Your patch
> changes this to only touch addresses participating in the connection
> and leave the others unmapped. Is that really what you want?
> In either case we can not break the old behaviour, so I suggest you
> add an module option to control whether the entire network or just
> a single address will be translated (ideally by just letting the user
> specify a prefix length) and default to the old behaviour.
>
>   

 
