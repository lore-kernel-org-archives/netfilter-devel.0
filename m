From: Andrew Beverley <andy@andybev.com>
Subject: Re: Connlimit and linux-2.6.17
Date: Sat, 22 Jul 2006 00:30:58 +0100
Message-ID: <44C163B2.10503@andybev.com>
References: <44BEA42B.3000304@andybev.com>	<Pine.LNX.4.64.0607200026310.4015@bizon.gios.gov.pl>	<44BEB607.3000408@andybev.com>
	<Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kraxel@bytesex.org, martin.bene@icomedias.com,
	netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, adlan.elm@gmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
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

>>>> I (and others, see netfilter list) are having trouble compiling 
>>>> kernel 2.6.17.4 and iptables-1.3.5-20060508 to use connlimit. Once 
>>>> compiled in and I run:
>>
>> <snip>
>>
>>> Yes, the API was changed in 2.6.17, so small fixes are required to 
>>> allow extensions to work. I'm currently traveling a lot so connlimit 
>>> & TARPIT is still on my TODO list. I'm going to finish it ASAP but 
>>> with limited GPRS/EDGE access it is not so simple.
> 
> OK, I fixed the connlimit extension. Please:
>  - tell me if it works (or not).

Yes, many thanks, I've just compiled the patched kernel and connlimit seems to 
work fine.

Andy
