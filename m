From: Gergely Imre <gimre@nextra.ro>
Subject: memory leak problems
Date: Wed, 27 Aug 2003 03:10:00 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0308270250100.12780-100000@mx.nextra.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


hi

i'm trying to write some traffic-meter program, using the routines from 
iptables 1.2.8. i have some problems. it looks like there is some memory 
leak. i've tried the following code:

#include "libiptc/libiptc.h"

int main(int argc, char* argv[])
{
    iptc_handle_t h;
    const struct ipt_entry *rule;
    const char* tablename = "filter";
    const char* chain = "count";

    if (!(h = iptc_init(tablename))) {
        return 0;
    }
    rule = iptc_first_rule(chain,&h);
    return 0;
} /* main */

i'm using gcc 2.96 under linux to compile this.
now, i looked in the code, and found that iptc_init, and iptc_firs_rule 
too, is doing some malloc. when/where will be that memory freed? 
itc_first_rule is calling a subroutine named populate_cache that is doing 
some malloc.
where and how do i suppose to free up that memory after finished working 
with the handle, and i want a new snapshot of the rules? i was calling 
iptc_init once every second on a fairly large chains (around 1000 rules), 
and after a minute or so, i saw that the program took more and more 
memory from the system. what can i do? will this be fixed soon, or just 
i'm not using the code the right way?
i checked iptables-restore too, with memprof, and it has the same memory 
leak. i mean, that is no problem when you run the program for a few 
second, but if you want it to sit in the memory for hours and querying the 
tables/chains all the time, it's not gonna work :)

thanks

-- 
Gergely Imre                       email: gimre@nextra.ro
sysadmin   mobile: +40-745-105592, office: +40-266-317500
Nextra Tele Com SRL   str. Florilor 28/1, 4100 M-Ciuc, RO
http://www.nextra.ro/gimre                 ICQ# 101510959
