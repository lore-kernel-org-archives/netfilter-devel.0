From: =?ISO-8859-15?Q?Fr=E9d=E9ric_Massot?=
 <frederic@juliana-multimedia.com>
Subject: Pb for get target info
Date: Sat, 28 Feb 2004 13:36:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <c1q202$khp$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,

I write a C program (libiptc 1.2.9) which lists the rules using the MARK
target.

The list returned by the program must contain the value of the mark
(setting with --set-mark) and the values of the counters.

For the moment, I list the values of the counters for the rules which 
use the MARK target, but I block to read the value of the MARK.

I took as a starting point the sources of the programs iptables and
iptables-save, and I block on the strange function "find_target".

Can you help me, please ?
Best regards.

Below the source code of the program.

PS: If the developers of the libiptc read me, would be a good idea to 
have a function "iptc_get_target_info" which returned the target 
information.


<---------SOURCE CODE--------------->

#include <stdio.h>
#include <libiptc.h>
#include <iptables.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int
main(void)
{
   iptc_handle_t h;
   const char *chain = NULL;
   const struct ipt_entry *e;
   const char *target_name;
   struct iptables_target *target = NULL;
   const struct ipt_entry_target *t;

   h = iptc_init("mangle");
   if(!h)
   {
     fprintf(stderr, "Can't initialize: %s\n", iptc_strerror(errno));
     return EXIT_FAILURE;
   }

   for (chain = iptc_first_chain(&h);
        chain; chain = iptc_next_chain(&h))
   {
     e = iptc_first_rule(chain, &h);

     while(e)
     {
       t = ipt_get_target((struct ipt_entry *)e);

       if (!iptc_is_chain(chain, h))
       	target = find_target(chain, TRY_LOAD);
       else
	target = find_target(IPT_STANDARD_TARGET,
                      LOAD_MUST_SUCCEED);

       target_name = iptc_get_target(e, &h);
       if (target_name &&
           (strncmp(target_name, "MARK", strlen("MARK")) == 0))		      {
         printf("%s - ", target_name);
         printf("[%llu:%llu]\n", e->counters.pcnt,
  			        e->counters.bcnt);
         if(target->print) target->print(&e->ip, t, 0x0041);
       }
       e = iptc_next_rule(e, &h);
     }
   }

   iptc_free(&h);
   return EXIT_SUCCESS;
}



-- 
==============================================
|              FREDERIC MASSOT               |
|     http://www.juliana-multimedia.com      |
|   mailto:frederic@juliana-multimedia.com   |
===========================Debian=GNU/Linux===
