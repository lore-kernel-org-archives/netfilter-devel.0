From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 09:43:29 +0100
Message-ID: <43C616B1.6060101@trash.net>
References: <BAY103-F3EE617C3194F61E05CC5CB2270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F3EE617C3194F61E05CC5CB2270@phx.gbl>
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
>>> Chain FORWARD (policy DROP 0 packets, 0 bytes)
>>> pkts bytes target     prot opt in     out     source               
>>> destination
>>>   19  1140 ACCEPT     all  --  any    any     anywhere             
>>> anywhere            policy match dir out pol ipsec strict [0] [1] [2] 
>>> [3] mode tunnel tunnel-dst 10.1.1.0/24 tunnel-src 10.1.2.0/24
>>>    0     0 DROP       all  --  any    any     anywhere             
>>> anywhere            policy match dir in pol ipsec strict [0] [1] [2] 
>>> [3] mode tunnel tunnel-dst 10.1.2.0/24 tunnel-src 10.1.1.0/24
>>
>>
>> How did you add these rules? It looks like you used "--next" multiple
>> times without specifying a policy element ..
> 
> 
> This is the command:
> 
> iptables -P FORWARD DROP
> iptables -A FORWARD -m policy --next --dir out --next --pol ipsec --next 
> --mode tunnel
> --tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 --strict -j ACCEPT
> iptables -A FORWARD -m policy --next --dir in --next --pol ipsec --next 
> --mode tunnel
> --tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 --strict -j DROP
> 
> Are they wrong?

Yes, --next is needed only if your policy has multiple elements, like
"--mode tunnel --tunnel-src 1.2.3.4/32 --next --mode transform". I'll
fix up the userspace part to reject this incorrect use.
