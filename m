From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: mask for interface
Date: Thu, 25 Mar 2004 14:09:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4062CC0C.3080503@aiqa.com>
References: <Pine.LNX.4.44.0403251241430.14618-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0403251241430.14618-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

...to test mask value of the input interface I wrote a small program 
(below) and insert these rules..

iptables -N test
iptables -A test -i eth0 -p tcp -s 10.0.0.1 -d 10.1.1.1 -j ACCEPT
iptables -A test -i eth+ -p tcp -s 10.0.0.1 -d 10.1.1.1 -j ACCEPT

-----------------------------------begin---------sample code to test 
interface mask-----------------------------
#include <stdio.h>
#include <sys/errno.h>
#include "iptables.h"
#include "libiptc/libiptc.h"
#include <stdlib.h>

int main(void)
{

   iptc_handle_t h;
   const struct ipt_entry *e;
   const char *chain = NULL;
   const char *tablename = "filter";

   h = iptc_init(tablename);
   if ( !h ) {
       printf("Problem when initializing: %s\n", iptc_strerror(errno));
       exit(errno);
   }

   for ( chain = iptc_first_chain(&h); chain; chain = 
iptc_next_chain(&h)) {
       printf("%s\n", chain);
       for ( e = iptc_first_rule(chain, &h); e; e = iptc_next_rule(e, 
&h)) {
           printf("iface : %s, mask : %s \n", e->ip.iniface, 
e->ip.iniface_mask);
       }
   }
   exit(0);
}

-----------------------------------end---------sample code to test 
interface mask-----------------------------


the output is same for eth+ and eth0

-----------------------------------begin---------output of the 
test-----------------------------
iface : eth0, mask :
iface : eth+, mask :
-----------------------------------end---------output of the 
test-------------------------------


Is there another way to create a mask for an interface?
What am I doing wrong to test iniface_mask?

thanks,
Ozgur AKAN
