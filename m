From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: [PATCH] RSH Conntrack+NAT
Date: Fri, 03 Jan 2003 12:01:10 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301030201.h0321AR25354@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: Andreas.Hofmeister@pyramid.de
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

Hello all,

  On 24 Aug 2002, Andreas sent a message with the subject
line  "some modules from pom-20020823 break iptables-1.2.7 build".
He supplied a patch that he had to create to fix a number of errors
that came from compiling userspace code against a machine patched
with a many of the conntrack patches, including RSH.  I can see
that the conntrack patches had been fixed in the patch-o-matic.  
  But,  I had the same problem last night, and it was my new stinking
module that caused it!  D'oh ;-)

  I have uploaded the complete pom package again, but the only
change is the following to rsh.patch (v1.21)

676,678c676
< +#ifndef __KERNEL__
< +#error Only in kernel.
< +#endif
---
> +#ifdef __KERNEL__
684a683,684
> +
> +#endif


+---------------
    ftp.netfilter.org/incoming/pom-rsh-030103-01.tgz
    3aaffd6046e81d9bfde93e42435eed0a  pom-rsh-030103-01.tgz 
    7430 bytes in size.
+---------------


  Let me know if you have any problems with it.



--
Ian Latter
Internet and Networking Security Officer
Macquarie University
