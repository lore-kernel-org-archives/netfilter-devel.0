From: Alexander Piavka <piavka@cs.bgu.ac.il>
Subject: Re: iptables compile error: NFC_IP_TOS undeclared
Date: Thu, 10 Feb 2005 18:00:48 +0200 (IST)
Message-ID: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>
References: <420B7B31.9000606@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Jonas Berlin <jberlin@niksula.hut.fi>
In-Reply-To: <420B7B31.9000606@niksula.hut.fi>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Thu, 10 Feb 2005, Jonas Berlin wrote:

> Alexander Piavka wrote:
>
> >gcc -O2 -Wall -Wunused -I/usr/src/linux-2.6.10-ct_sync-rc1/include
> >-Iinclude/ -DIPTABLES_VERSION=\"1.3.0rc1\"  -fPIC -o
> >extensions/libipt_dscp_sh.o -c extensions/libipt_dscp.c
> >extensions/libipt_dscp.c: In function `init':
> >extensions/libipt_dscp.c:29: error: `NFC_IP_TOS' undeclared (first use in
> >this function)
> >
> >
> Could you give the output of the following three commands (run them from
> your iptables-1.3.0rc1 source directory):
>
>   grep NFC_IP_TOS
> /usr/src/linux-2.6.10-ct_sync-rc1/include/linux/netfilter_ipv4.h
 no match

actually there is no match from  NFC_IP_TOS in the whole
/usr/src/linux-2.6.10-ct_sync-rc1/include subtree

>
>   grep netfilter_ipv4.h
> /usr/src/linux-2.6.10-ct_sync-rc1/include/linux/netfilter_ipv4/ip_tables.h
#include <linux/netfilter_ipv4.h>

>
>   grep ip_tables.h extensions/libipt_dscp.c

#include <linux/netfilter_ipv4/ip_tables.h>
>
> That could help solve the problem.
>
> --

 Thanks
