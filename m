From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ip_conntrack_max registered twice
Date: Wed, 15 Dec 2004 21:59:59 +0100
Message-ID: <41C0A5CF.4030303@eurodev.net>
References: <000701c4e2e8$280ae830$0e25fe0a@pysiak>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <000701c4e2e8$280ae830$0e25fe0a@pysiak>
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

Maciej Soltysiak wrote:

> Hi,
>
> I noticed that I have:
> /proc/sys/net/ipv4/netfilter/ip_conntrack_max
> /proc/sys/net/ipv4/ip_conntrack_max
>
> A quick look at net/ipv4/netfilter/ip_conntrack_standalone.c shows
> that we register the same variable (ip_conntrack_max) twice:
>
> In:
> ip_ct_sysctl_table[]:
>        {
>                .ctl_name       = NET_IPV4_NF_CONNTRACK_MAX,
>                .procname       = "ip_conntrack_max",
>                .data           = &ip_conntrack_max,
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
>                .proc_handler   = &proc_dointvec,
>        },
>
> And in ip_ct_netfilter_table[]:
>        {
>                .ctl_name       = NET_IP_CONNTRACK_MAX,
>                .procname       = "ip_conntrack_max",
>                .data           = &ip_conntrack_max,
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
>                .proc_handler   = &proc_dointvec
>        },
>
> Is this for some backward compatibility or is it a needless duplication ?


I asked the same some time ago, and Jozsef told me that it's a backward 
compatibility issue.

--
Pablo
