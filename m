From: nickolay@protei.ru
Subject: failed loading SNAT and DNAT library
Date: Tue, 14 Jan 2003 18:44:57 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030114184457.A25511@protei.ru>
References: <20030114141102.14779.87181.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030114141102.14779.87181.Mailman@kashyyyk>; from netfilter-devel-request@lists.netfilter.org on Tue, Jan 14, 2003 at 03:11:02PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Guys!

I'm newbe to developing netfilter code and i have some troubles 
with it. I need to working with SNAT and DNAT target rules in my 
new project, but when i trying load shared librarys libipt_SNAT.so 
for SNAT or libipt_DNAT.so for DNAT targets with dlopen(), program
executing is stopped on dlopen() call with next error:
/usr/local/lib/iptables/libipt_SNAT.so: undefined symbol: dotted_to_addr.
Compile step:
cc iptest.c -ldl -liptc -o myprog

Below i preview some major program code, please help me resolve trouble:

#include <getopt.h>
#include <sys/errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <time.h>
#include "/usr/local/include/libiptc/libiptc.h"
#include "/usr/local/include/iptables.h"

int main(void)
{
    iptc_handle_t h;
    const struct ipt_entry *e;
    const struct ipt_entry_target *eTarget;
    struct iptables_target *target;
    const char *chain = NULL;
    const char *tablename = "nat";
    const char *cname = NULL;
    char path[] = "/usr/local/lib/iptables/libipt_SNAT.so";
    void *ldhandler;

    if((h = iptc_init(tablename)) == NULL) {
        fprintf(stderr, "error: iptc_init() failed: %s\n", iptc_strerror(errno));
        exit(1);
    }

    for(cname = iptc_first_chain(&h); cname; cname = iptc_next_chain(&h)) {
        for(e = iptc_first_rule(cname, &h); e; e = iptc_next_rule(e, &h)) {
            eTarget = ipt_get_target((struct ipt_entry*)e);
            printf("-----------------\n");
            printf(":%s\n", eTarget->u.user.name);
            ldhandler = dlopen(path, RTLD_NOW);
            if(!ldhandler) {
                fprintf(stderr, "%s\n", dlerror());
                exit(1);
            }
        }
    }

} /* main */

--
Nickolay
nickolay@protei.ru
