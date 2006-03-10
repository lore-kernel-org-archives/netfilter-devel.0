From: Chinh Nguyen <cnguyen@certicom.com>
Subject: Re: ip6tables: Unknown error 4294967295
Date: Fri, 10 Mar 2006 09:57:11 -0500
Message-ID: <441193C7.2070003@certicom.com>
References: <341954904.20764@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <341954904.20764@ustc.edu.cn>
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

GuanYao Huang wrote:
> Hi:
> I am doing research into iptables-1.3.5, in which I am trying to use ROUTE target
> which is an extension to the current iptables. 
> I added libip6t_ROUTE.h which makes libip6t_ROUTE.c complied.
> When using the following command:
> [root@localhost iptables]# /root/CNGI/iptables-1.3.5/ip6tables -A POSTROUTING -t
> mangle -o eth0 -p tcp --dport 22 -j ROUTE --oif iptun
> ip6tables: Unknown error 4294967295
> 
> I don't know why. Can you help me? Thanks.
> 
> 
> 

There are 2 parts to netfilter. The modules that are used by iptables to parse
arguments and communicate them to the kernel and the kernel modules that are
loaded (or compiled in) with the kernel.

One problem could be that your current kernel does not have support for the
netfilter module you are trying to used.

I have often seen this error associated with an 'invalid argument' returned by
the netfilter kernel module. In previous versions of iptables, it will say
'invalid argument' instead of 'Unknown error 4294967295'.

This is typically caused by an invalid or missing condition causing the
netfilter kernel to reject the rule in its checkentry function.

Unfortunately, sometimes all the necessary valid conditions are not enumerated
in any iptables manual or checked by the iptables module.

For example, consider this
 /opt/iptables-1.3.5/bin/iptables -A OUTPUT -m esp --espspi ! 0 -j LOG
iptables: Unknown error 4294967295

What is not known is that you have to specify '-p esp' if you will to use module
'esp', which becomes apparent if you look at the kernel source code:

net/ipv4/netfilter/ipt_esp.c:
static int
checkentry(const char *tablename,
       const void *ip_void,
       void *matchinfo,
       unsigned int matchinfosize,
       unsigned int hook_mask)
{
    const struct ipt_esp *espinfo = matchinfo;
    const struct ipt_ip *ip = ip_void;

    /* Must specify proto == ESP, and no unknown invflags */
    if (ip->proto != IPPROTO_ESP || (ip->invflags & IPT_INV_PROTO)) {
        duprintf("ipt_esp: Protocol %u != %u\n", ip->proto,
             IPPROTO_ESP);
        return 0;
    }

If this is your problem, you might have to do some source code reading :)
