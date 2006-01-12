From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 11:53:02 +0100
Message-ID: <43C6350E.4020809@trash.net>
References: <BAY103-F9081615570A9A6A5FC912B2270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F9081615570A9A6A5FC912B2270@phx.gbl>
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
>>
>>> Ok, my fault sorry. Here is my corrected (I hope) iptables rules:
>>>
>>> iptables -P FORWARD DROP
>>> iptables -F
>>>
>>> iptables -A FORWARD -m policy --dir out --pol ipsec --mode tunnel 
>>> --tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
>>> iptables -A FORWARD -m policy --dir in  --pol ipsec  --mode tunnel 
>>> --tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP
>>>
>>> iptables -A FORWARD -m policy --dir in --pol ipsec --mode tunnel 
>>> --tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
>>> iptables -A FORWARD -m policy --dir out  --pol ipsec  --mode tunnel 
>>> --tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP
>>>
> root@Calimero:/usr/src/linux-2.6.15/net/ipv4/netfilter# ip xfrm policy
> src 10.1.1.0/24 dst 10.1.2.0/24
>        dir in priority 2344
>        tmpl src 172.16.1.226 dst 172.16.1.247

These are the addresses you need to use for --tunnel-src/dst, not the
outer addresses. Those can be match with -s and -d are usual.
