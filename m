From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/03]: Netfilter fixes
Date: Wed, 08 Aug 2007 15:58:14 +0200
Message-ID: <46B9CBF6.1050209@trash.net>
References: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
	<20070807.181242.89281020.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070807.181242.89281020.davem@davemloft.net>
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

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon,  6 Aug 2007 15:29:03 +0200 (MEST)
>
>   
>> these patches fix a few netfilter bugs: failure to load IPv4 connection tracking
>> when loading the NAT module, an invalid return code in ctnetlink and a possible
>> NULL pointer dereference in ipt_recent. I'll pass the NULL pointer fix to
>> -stable once its upstream.
>>
>> Please apply, thanks.
>>     
>
> Applied, thanks Patrick.
>
> I really wish those dependencies could be worked out in a nicer
> way than calling NULL functions in the needed module.
>   

Its not very pretty, I agree. In this case we could have used
indirect dependencies and request_module, but I actually prefer
the symbol dependency because its visible in lsmod, which makes
it easier to figure out what needs to be unloaded first to
remove a module.
