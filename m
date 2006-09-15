From: Mohammad Farooq <mohammadfarooq@tango-networks.com>
Subject: Problem compiling u32 patch on Redhat
Date: Fri, 15 Sep 2006 14:54:09 -0500
Message-ID: <1158350049.4127.27.camel@mfarooq-1.tango-networks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I posted this problem on the user list but didn't receive any response.
I would appreciate if any expert can help me out.
I am trying to apply u32 patch to the Redhat enterprise edition 4 which
is using 2.6.9 kernel. I am getting the following compile error.

net/ipv4/netfilter/ipt_u32.c:127: warning: "struct xt_match" declared
inside parameter list
net/ipv4/netfilter/ipt_u32.c:127: warning: its scope is only this
definition or declaration, which is probably not what you want
net/ipv4/netfilter/ipt_u32.c:210: warning: "struct xt_match" declared
inside parameter list
net/ipv4/netfilter/ipt_u32.c:219: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ipt_u32.c:220: error: unknown field `matchsize'
specified in initializer
net/ipv4/netfilter/ipt_u32.c:220: warning: initialization makes pointer
from integer without a cast
net/ipv4/netfilter/ipt_u32.c:221: warning: initialization from
incompatible pointer type
make[3]: *** [net/ipv4/netfilter/ipt_u32.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

 I
I looked in the ipt_u32.c and found the matchsize variable:

static struct ipt_match u32_match = {
        .name           = "u32",
        .match          = &match,
        .matchsize      = sizeof(struct ipt_u32),
        .checkentry     = &checkentry,
        .me             = THIS_MODULE
};

But in the ip_tables.h this varibale doesn't exists:

struct ipt_match
{
        struct list_head list;

        const char name[IPT_FUNCTION_MAXNAMELEN];

        /* Return true or false: return FALSE and set *hotdrop = 1 to
           force immediate packet drop. */
        /* Arguments changed since 2.4, as this must now handle
           non-linear skbs, using skb_copy_bits and
           skb_ip_make_writable. */
        int (*match)(const struct sk_buff *skb,
                     const struct net_device *in,
                     const struct net_device *out,
                     const void *matchinfo,
                     int offset,
                     int *hotdrop);

        /* Called when user tries to insert an entry of this type. */
        /* Should return true or false. */
        int (*checkentry)(const char *tablename,
                          const struct ipt_ip *ip,
                          void *matchinfo,
                          unsigned int matchinfosize,
                          unsigned int hook_mask);

        /* Called when entry of this type deleted. */
        void (*destroy)(void *matchinfo, unsigned int matchinfosize);

        /* Set this to THIS_MODULE. */
        struct module *me;
};

Could you please guide me how can I fix this problem. I tried to fix
this compile problem by commenting out the line ipt_u32.c which
references matchsize variable. After that I was able to compile the
kernel but when I tried to run iptables command,
I got "Invalid argumment" error. Here is the command I used.

iptables -A OUTPUT -m u32 --u32 "2&0xffff=0x2:0x0100" -j DROP
iptables: Invalid argument

I am not sure if I am seen this error because I commented out the line
in ipt_u32.c? I appreciate if you point me to the right direction. Is
u32 module is ported to linux 2.6 kernel?
Thanks.

Mohammad
