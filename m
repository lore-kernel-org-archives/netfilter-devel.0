From: switcher <switcher@linuxwall.info>
Subject: Check connection state in libipq hook
Date: Fri, 15 Jun 2007 05:59:21 +0200
Message-ID: <20070615055921.e60ifzff4800s4ok@webmail.microgate.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi All,

I'm coding a software that check if an incoming packet is part of an active
connection.
I'm using libipq to get the packet and I tried to submit it to
ip_conntrack_find_get() as a tuple create with ip_conntrack_tuple but it
doesn't work so I have some questions about that.

I'm creating the tuple and submitting it with that piece of code :
--------
struct ip_conntrack_tuple *tuple;
tuple->src.ip 		= iph->saddr;
tuple->src.u.tcp.port 	= tcp->source;
tuple->dst.ip 		= iph->daddr;
tuple->dst.u.tcp.port 	= tcp->dest;
tuple->dst.protonum 	= iph->protocol;
tuple->dst.dir		= 0;
if (NULL == ip_conntrack_find_get(tuple, NULL))
{
     fprintf(stdout, "tuple IS NOT part of an active connection");
}
else {
     fprintf(stdout, "tuple IS part of an active connection");
}
--------
But I don't know what to put in tuple->dst.dir value... is it a static value ?

Moreover, I included <linux/netfilter.h>,
<linux/netfilter_ipv4/ip_conntrack_tuple.h> and
<linux/netfilter_ipv4/ip_conntrack_core.h> (kernel 2.6.17.7) but when I try to
compile it, I have an error message :
--------
/usr/include/linux/netfilter_ipv4/ip_conntrack_core.h: In function
'ip_conntrack_confirm':
/usr/include/linux/netfilter_ipv4/ip_conntrack_core.h:44: error: dereferencing
pointer to incomplete type
/usr/include/linux/netfilter_ipv4/ip_conntrack_core.h: At top level:
/usr/include/linux/netfilter_ipv4/ip_conntrack_core.h:59: error: syntax error
before 'ip_conntrack_lock'
--------

I'm not manipulating 'ip_conntrack_confirm' nor 'ip_conntrack_lock' so I guess
I've made a mistake somewhere but I don't know where...
Could you help me ?

Thanks,
julien
