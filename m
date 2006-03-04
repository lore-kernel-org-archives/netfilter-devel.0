From: Michael Leow <michael@webwork-solutions.com>
Subject: [PATCH] nfsim configure
Date: Sat, 04 Mar 2006 20:18:35 +0800
Message-ID: <4409859B.2070207@webwork-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Greetings from the 7th Asia OSS Code Fest! 

    Hit the following problem while compiling using the following 
environment:- Linux 2.6.15.5 source and nfsim-20060303.  Due to a 
missing x_tables.c; the Makefile is not created.  Here is a simple patch 
for your consideration.


leow@xen:~/broken-nfsim/nfsim-fix$ diff -rN -u 
../nfsim-20060303/configure configure
--- ../nfsim-20060303/configure 2006-01-09 04:55:34.000000000 +0800
+++ configure   2006-03-04 15:55:47.000000000 +0800
@@ -107,6 +107,9 @@
            echo "import: netfilter/gen/$f" >> Makefile.import
        done
        cat $KERNELDIR/net/netfilter/Makefile | grep -v 
'^obj-$(CONFIG_NETFILTER)' | grep -v '^netfilter-objs' > 
netfilter/gen/Makefile
+    else
+       # Empty ... :(
+       touch netfilter/gen/Makefile
     fi
 fi




Regards,

Michael Leow
HighTraffic.com
(A Division of WebWork-Solutions Sdn Bhd)
