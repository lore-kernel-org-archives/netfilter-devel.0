From: Patrick McHardy <kaber@trash.net>
Subject: Re: a patch for conntrack_tuple
Date: Fri, 14 Jan 2005 05:03:11 +0100
Message-ID: <41E7447F.5060400@trash.net>
References: <20050111102202.99FD6A90F2@mail.goldenhope.com.cn>
	<BF65C818-65DF-11D9-9545-000A95B170F8@mail.goldenhope.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: zhongyu <xxx@mail.goldenhope.com.cn>
In-Reply-To: <BF65C818-65DF-11D9-9545-000A95B170F8@mail.goldenhope.com.cn>
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

zhongyu wrote:

> --- include/linux/netfilter_ipv4/ip_conntrack_tuple.h   27 Nov 2003 
> 12:42:40 -0000      1.2
> +++ include/linux/netfilter_ipv4/ip_conntrack_tuple.h   10 Jan 2005 
> 04:28:28 -0000
> @@ -50,13 +50,37 @@
>                         u_int64_t all;
>
> [...] 

> The function hash_conntrack use the low 16 bits of tuple->dst, but in 
> big-endian system
> the port infomation is in high 16 bits. So the destination port on 
> big-endian system was
> ignored. This caused hash collision. The patch above fixed this 
> problem :-)


In the mainline kernel "all" is u_int16_t. Have you applied any patches ?

Regards
Patrick
