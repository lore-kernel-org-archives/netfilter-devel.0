From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 15:37:23 +0100
Message-ID: <BAY103-F17E50648E467F94FCCFAC6B2270@phx.gbl>
References: <43C64C83.2060808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43C64C83.2060808@trash.net>
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
>>>These are the addresses you need to use for --tunnel-src/dst, not the
>>>outer addresses. Those can be match with -s and -d are usual.
>>
>>
>>Aha! ;-)) It's working. Thanks a lot. Perhaps _IMHO_ this should be
>>clarified in iptables man page. After all --tunnel-src/dst are the two
>>IPsec endpoint addresses. Right?
>
>Yes. I don't see how it could be made any clearer, but feel free to
>send a suggestion :)
>
>        --tunnel-src addr[/mask]
>               Matches the source address of a tunnel. Only valid with 
>--mode tunnel.
>
>        --tunnel-dst addr[/mask]
>               Matches the destination address of a tunnel. Only valid with 
>--mode tunnel.

Ok. Here is my suggestion:

--tunnel-src addr[/mask]
matches the source end-point address of the SA. Only valid
with --mode tunnel

--tunnel-dst addr[/mask]
matches the destination end-point address of the SA. Only valid
with --mode tunnel
