From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 12:15:49 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201137310.2389-100000@filer.marasystems.com>
References: <3FBC916A.8010501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3FBC916A.8010501@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, Patrick McHardy wrote:

> I couldn't find the exact line in either 2.4 or 2.6, could you post it ?

It would be this

>ASSERT ip_conntrack_core.c:632 &ip_conntrack_lock not readlocked

struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
{
        return LIST_FIND(&helpers, helper_cmp,
                         struct ip_conntrack_helper *,
                         tuple);
}


which makes sense as LIST_FIND uses ASSERT_READ_LOCK.

#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)

The warning have been isolated to the nat helpers only. The conntrack 
helpers are silent.

The full trace is

#0  printk (fmt=0xa2812140 "ASSERT %s:%u %s not readlocked\n") at 
printk.c:416
#1  0xa280efec in ip_ct_find_helper (tuple=0xa282aab4)
    at ip_conntrack_core.c:630
#2  0xa281dd24 in ip_nat_helper_register (me=0xa282aaa0) at 
ip_nat_helper.c:474
#3  0xa282a724 in init () at ip_nat_ftp.c:327
#4  0xa0010eb3 in sys_init_module (name_user=0x807cfe8 "ip_nat_ftp", 
    mod_user=0x80a7578) at module.c:563

this is not 100% the exact same kernel so the line number differs 
slightly, but it is the exact same error.

Regards
Henrik
