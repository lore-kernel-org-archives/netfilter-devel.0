From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Wed, 26 Apr 2006 18:49:43 +0200
Message-ID: <444FA4A7.7060105@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl>
	<444F7A3F.9080507@trash.net>
	<BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl>
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

Jing Min Zhao wrote:
> ----- Original Message ----- 
> From: "Patrick McHardy" <kaber@trash.net>
> To: "Jing Min Zhao" <zhaojingmin@hotmail.com>
> Cc: <netfilter-devel@lists.netfilter.org>
> Sent: Wednesday, April 26, 2006 9:48 AM
> Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
> 
> 
> 
>>Jing Min Zhao wrote:
>>
>>>This patch is for 2.6.17-rc2. Please visit
>>>http://nath323.sourceforge.net/#_Toc133598071 for details.
>>>
>>>Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
>>
>>Please attach patches inline so I can view and quote them in my mail
>>client and include the patch description with the patch.
>>
> 
> I'm sorry. Actually, I'm always frustrated by my Outlook Express 
> and my hotmail account :(. 

I can relate :) I think you should be able to use imap on
people.netfilter.org.


>>I definitely don't like the internal_net module option. I know its not
>>strictly required, more an optimization, but still limiting this to only
>>one network is not a good idea. We may be able to use the routing
>>information as indication whether we need an expectation or not .. but
>>I need think about it some more.
>>
>>
> 
> I also want such a solution deadly, but I can't figure out a way. 
> Actually, the only question is how can a firewall tell that any two 
> endpoints can talk with each other directly without passing though it.
> Any suggestion for this will be greatly appreciated.

There is no general way to do this, but we I think we can take a good
guess for the common case of no weird NATing etc based on the nexthop
information we get from fib_lookup(). I think an assumption that is
true for most cases is that if the nexthop information is identical,
the two endpoints can reach each other without our help. It needs to
be optional of course. What do you think about this?


>>--- a/include/linux/netfilter_ipv4/ip_conntrack.h
>>+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
>>@@ -154,6 +154,7 @@ struct ip_conntrack_expect
>>       unsigned int flags;
>>
>>#ifdef CONFIG_IP_NF_NAT_NEEDED
>>+       u_int32_t saved_ip;
>>       /* This is the original per-proto part, used to map the
>>        * expected connection the way the recipient expects. */
>>       union ip_conntrack_manip_proto saved_proto;
>>
>>Please explain why this is needed.
>>
>>
> 
> If an external endpoint A calls an internal endpoint B, and B forwards 
> the call to an internal endpoint C, then the second call will come from 
> A, pass through firewall, and go to C. The current architecture assumes 
> any expected connections come back to the same internal endpoint, so 
> only the port (saved_proto) is saved. But in this case, it is not 
> enough - the expected connection will go to the third endpoint. So we 
> need to save not only C's port but also C's IP.

OK, this seems to be unavoidable. But please just replace
ip_conntrack_manip_proto by ip_conntrack_manip.
