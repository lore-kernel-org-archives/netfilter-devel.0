From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 11:15:30 +0100
Message-ID: <43F5A242.9040809@trash.net>
References: <BAY103-F81B8A00B6663452743916B2F80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F81B8A00B6663452743916B2F80@phx.gbl>
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

Marco Berizzi wrote:
> 
>> > IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00
>> > SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00
>> > TTL=53 ID=45921 PROTO=ESP SPI=0x583f3ff9
>> > IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00
>> > SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00
>> TTL=53
>> > ID=45921 PROTO=4
>>
>> Thats odd, these packets should be caught by your ESP rule, so I guess
>> they must be dropped by another rule. Please post your full ruleset with
>> iptables -vxnL.
> 
> 
> Me again. Aha! Found!!! ;-))
> 
> iptables -I INPUT -s venice-gateway --protocol 4 -j ACCEPT
> 
> did the trick.

I also just noticed the second line contains IPCOMP not ESP, which is
strange because ESP is used in transport mode, so the ESP and IPCOMP
decapsulation should happen without any netfilter hooks in between.

src 172.16.0.0/23 dst 172.23.0.0/23
       dir in priority 2377
       tmpl src venezia-gateway dst firenze-gateway
               proto comp reqid 16406 mode tunnel
               level use
       tmpl src 0.0.0.0 dst 0.0.0.0
               proto esp reqid 16405 mode transport
