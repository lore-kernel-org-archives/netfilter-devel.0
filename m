From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Wed, 26 Apr 2006 22:20:31 +0200
Message-ID: <444FD60F.4060301@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl>
	<444F7A3F.9080507@trash.net>
	<BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl>
	<444FA4A7.7060105@trash.net>
	<BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl>
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
>>>>--- a/include/linux/netfilter_ipv4/ip_conntrack.h
>>>>+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
>>>>@@ -154,6 +154,7 @@ struct ip_conntrack_expect
>>>>      unsigned int flags;
>>>>
>>>>#ifdef CONFIG_IP_NF_NAT_NEEDED
>>>>+       u_int32_t saved_ip;
>>>>      /* This is the original per-proto part, used to map the
>>>>       * expected connection the way the recipient expects. */
>>>>      union ip_conntrack_manip_proto saved_proto;
>>>>
>>>>Please explain why this is needed.
>>>>
>>>>
>>>
>>>If an external endpoint A calls an internal endpoint B, and B forwards 
>>>the call to an internal endpoint C, then the second call will come from 
>>>A, pass through firewall, and go to C. The current architecture assumes 
>>>any expected connections come back to the same internal endpoint, so 
>>>only the port (saved_proto) is saved. But in this case, it is not 
>>>enough - the expected connection will go to the third endpoint. So we 
>>>need to save not only C's port but also C's IP.
>>
>>OK, this seems to be unavoidable. But please just replace
>>ip_conntrack_manip_proto by ip_conntrack_manip.
>>
>>
> 
> 
> Do you mean to delete saved_ip and replace 
> "union ip_conntrack_manip_proto saved_proto" with 
> "struct ip_conntrack_manip saved_xxx"? This will break other code, 
> for example, ip_nat_follow_master(). Or I misunderstood.


Yes, these places need to be changes as well. But ip_conntrack_manip
is semantically correct, you use the saved_ip for the manip of the
new connection, so we can instead just save an entire manip.
But its still a good point, please make this change in a seperate patch
from the call forwarding patch.
