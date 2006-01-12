From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 12:23:50 +0100
Message-ID: <BAY103-F101B38B8CF2C670CC1A915B2270@phx.gbl>
References: <43C6350E.4020809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43C6350E.4020809@trash.net>
To: kaber@trash.net
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


Patrick McHardy wrote:

>Marco Berizzi wrote:
>>
>>Patrick McHardy wrote:
>>
>>>Marco Berizzi wrote:
>>>
>>>>Ok, my fault sorry. Here is my corrected (I hope) iptables rules:
>>>>
>>>>iptables -P FORWARD DROP
>>>>iptables -F
>>>>
>>>>iptables -A FORWARD -m policy --dir out --pol ipsec --mode tunnel 
>>>>--tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
>>>>iptables -A FORWARD -m policy --dir in  --pol ipsec  --mode tunnel 
>>>>--tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP
>>>>
>>>>iptables -A FORWARD -m policy --dir in --pol ipsec --mode tunnel 
>>>>--tunnel-src 10.1.2.0/24 --tunnel-dst 10.1.1.0/24 -j DROP
>>>>iptables -A FORWARD -m policy --dir out  --pol ipsec  --mode tunnel 
>>>>--tunnel-dst 10.1.2.0/24 --tunnel-src 10.1.1.0/24 -j DROP
>>>>
>>root@Calimero:/usr/src/linux-2.6.15/net/ipv4/netfilter# ip xfrm policy
>>src 10.1.1.0/24 dst 10.1.2.0/24
>>        dir in priority 2344
>>        tmpl src 172.16.1.226 dst 172.16.1.247
>
>These are the addresses you need to use for --tunnel-src/dst, not the
>outer addresses. Those can be match with -s and -d are usual.

Aha! ;-)) It's working. Thanks a lot. Perhaps _IMHO_ this should be
clarified in iptables man page. After all --tunnel-src/dst are the two
IPsec endpoint addresses. Right?

Thanks again and sorry for wasting your time.
Ciao.

PS: I'm compiling right now 2.6.15-git8 with your latest patch: Check
policy length in policy match strict mode.
