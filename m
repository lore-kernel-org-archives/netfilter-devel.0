From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
 services)
Date: Sat, 17 Apr 2004 20:53:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40817D3E.3010202@fl.priv.at>
References: <Pine.LNX.4.44.0404172007210.22427-100000@filer.marasystems.com>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0404172007210.22427-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote on 17.04.2004 20:18 MET:
> On Sat, 17 Apr 2004, Friedrich Lobenstock wrote:
> 
> 
>>Thanks, but can you give some background info about the hash size parameter 
>>of ip_conntrack as the description on the page above is rather lacking any 
>>reasons:
>>- Is this parameter automatically sized according to the amount of
>>   installed memory?
> 
> Yes.
> 
> 
>>- How is it related to ip_conntrack_max?
> 
> ip_conntrack_max = 8 * hah_size

What is the downside if that equation is not fullfilled by running
   echo "xxxx" > /proc/sys/net/ipv4/ip_conntrack_max
without setting the hashsize=yyyy parameter?


>>- What's the amount of memory that is allocated based on this
>>   parameter?
> 
> Depends a little on what conntrack & nat helpers etc you enabled when the
> kernel is built. In my kernel each conntrack currently uses ca 384 bytes, 
> most others probably use less..

Wouldn't it be good if ip_conntrack exports that size via /proc? Would help 
the average user to estimate the influence of increasing ip_conntrack_max.

> The amount of memory allocated based on the hash size is pretty marginal, 
> what one needs to keep track of is the total number of connections as this 
> is the bulk of the memory usage.

So the hash size also limits the amount of connections?

> As for suggested defaults: If this is a general purpose server then the
> automatic defaults. On a dedicated firewall scale the memory and conntrack
> based on how many concurrent sessions you need to support but I would not
> recommend to assign more than 50% of your memory to conntrack.

And why if I may ask? Management overhead, or what?
For example a machine with 1GB RAM router only, couldn't we assign eg. 
768MB to conntrack?

Another side question, can you add this information to the netfilter FAQ?

-- 
MfG / Regards
Friedrich Lobenstock
