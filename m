From: Patrick McHardy <kaber@trash.net>
Subject: Re: Raw Sockets and Netfiter
Date: Tue, 25 Mar 2003 09:05:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E800DE4.9070000@trash.net>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER> <20030325072544.GI18652@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ethan Dameron <efd@duke.edu>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030325072544.GI18652@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:

>On Tue, Mar 25, 2003 at 02:06:59AM -0500, Ethan Dameron wrote:
>  
>
>>If I have a an IP datagram in userspace and I send it via a raw socket
>>created with socket(PF_INET, SOCK_RAW, IPPROTO_RAW) using the send()
>>system call, will this packet traverse the netfilter chains?
>>    
>>
>
>No. Raw sockets bypass the TCP/IP stack. Netfilter hooks, and
>consequently iptables, sit inside the IP stack.
>

Then what is the purpose of ip_conntrack_local:

static unsigned int ip_conntrack_local(...)
{
        /* root is playing with raw sockets. */
        if ((*pskb)->len < sizeof(struct iphdr)
            || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
                if (net_ratelimit())
                        printk("ipt_hook: happy cracking.\n");
                return NF_ACCEPT;
        }
        return ip_conntrack_in(hooknum, pskb, in, out, okfn);
}

Seems like it could be eliminated entirely if you're correct.

Regards,
Patrick
