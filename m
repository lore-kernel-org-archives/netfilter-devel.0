From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: ip_conntrack_max registered twice
Date: Wed, 15 Dec 2004 21:53:36 +0100
Message-ID: <000701c4e2e8$280ae830$0e25fe0a@pysiak>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,

I noticed that I have:
/proc/sys/net/ipv4/netfilter/ip_conntrack_max
/proc/sys/net/ipv4/ip_conntrack_max

A quick look at net/ipv4/netfilter/ip_conntrack_standalone.c shows
that we register the same variable (ip_conntrack_max) twice:

In:
ip_ct_sysctl_table[]:
        {
                .ctl_name       = NET_IPV4_NF_CONNTRACK_MAX,
                .procname       = "ip_conntrack_max",
                .data           = &ip_conntrack_max,
                .maxlen         = sizeof(int),
                .mode           = 0644,
                .proc_handler   = &proc_dointvec,
        },

And in ip_ct_netfilter_table[]:
        {
                .ctl_name       = NET_IP_CONNTRACK_MAX,
                .procname       = "ip_conntrack_max",
                .data           = &ip_conntrack_max,
                .maxlen         = sizeof(int),
                .mode           = 0644,
                .proc_handler   = &proc_dointvec
        },

Is this for some backward compatibility or is it a needless duplication ?

Regards,
Maciej
