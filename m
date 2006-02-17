From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 10:09:47 +0100
Message-ID: <43F592DB.9090701@trash.net>
References: <BAY103-F14EFAD9BC487D65AE76129B2F80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F14EFAD9BC487D65AE76129B2F80@phx.gbl>
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
> Patrick McHardy wrote:
> 
>> Marco Berizzi wrote:
>> > With these rules I'm able to send/receive packets from the two
>> > private networks each other (172.16.0.0/23<->172.23.0.0/23).
>> > If I delete the first rule in the INPUT table (on firenze-gateway)
>> >
>> > ACCEPT     all  --  venezia-gateway       0.0.0.0/0
>> >
>> > there is no packet flow inside the tunnel. I don't understand,
>> > as I accept esp packets in the red-me chain.
>>
>> What does your policy look like?
> 
> 
> root@Halley:~# ip xfrm policy
> src 172.16.0.0/23 dst 172.23.0.0/23
>        dir in priority 2377
>        tmpl src venezia-gateway dst firenze-gateway
>                proto comp reqid 16406 mode tunnel
>                level use
>        tmpl src 0.0.0.0 dst 0.0.0.0
>                proto esp reqid 16405 mode transport
> src 172.23.0.0/23 dst 172.16.0.0/23
>        dir out priority 2377
>        tmpl src firenze-gateway dst venezia-gateway
>                proto comp reqid 16406 mode tunnel
>        tmpl src 0.0.0.0 dst 0.0.0.0
>                proto esp reqid 16405 mode transport
> src 172.16.0.0/23 dst 172.23.0.0/23
>        dir fwd priority 2377
>        tmpl src venezia-gateway dst firenze-gateway
>                proto comp reqid 16406 mode tunnel
>                level use
>        tmpl src 0.0.0.0 dst 0.0.0.0
>                proto esp reqid 16405 mode transport

I can't see a mistake. Can you please add a logging rule to log
the packets that get dropped without the ACCEPT rule?
