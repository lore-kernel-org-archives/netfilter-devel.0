From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: [PATCH] ipp2p v0.8.2 fix for iptables 1.3.6/1.3.7 on linux
	2.6.18/2.6.19
Date: Mon, 11 Dec 2006 18:23:35 +0100
Message-ID: <20061211172335.GA20514@ekonomika.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Cc: kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm not sure when this bug started acting up. I'm currently running
IPP2P v0.8.2 on linux 2.6.19 with iptables 1.3.7. The standard release
will compile but not work correctly. The kernel module loads without
problems, but the userspace library (libipt_ipp2p.so) won't load.

The problem is that when the module is loaded, the _init() function
should be called by dlopen(). This doesn't happen because dlopen() can't
find the constructor (_init())

The iptables includes redefine every _init() function to be my_init(),
and mark it as a constructor with __attribute__((constructor)).
This attribute is only recognized by the compiler it seems, not the
linker. And because the ipp2p module is compiled and then linked with
"ld" instead of "gcc", the constructor never gets recognized, thereby
causing the world of pain I've been in the last week.

So, to make a long story short(er): patch the ipp2p source with the
attached patch to get it working.

kind regards,
-- Steven
-- 
My amazon wishlist:
http://www.amazon.com/gp/registry/1DB4XNEIEQBPB

--fdj2RfSjLxBAspz7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="990_____makefiles_fix.patch"

diff -Naur ipp2p-0.8.2/Makefile ipp2p-0.8.2-patched/Makefile
--- ipp2p-0.8.2/Makefile	2006-12-04 19:23:46.000000000 +0100
+++ ipp2p-0.8.2-patched/Makefile	2006-12-11 11:41:03.000000000 +0100
@@ -60,7 +60,7 @@
 
 libipt_ipp2p.so: libipt_ipp2p.c ipt_ipp2p.h
 	$(CC) $(CFLAGS) $(IPTABLES_OPTION) $(IPTABLES_INCLUDE) -fPIC -c libipt_ipp2p.c
-	ld -shared -o libipt_ipp2p.so libipt_ipp2p.o
+	$(CC) -shared -o libipt_ipp2p.so libipt_ipp2p.o
 
 clean:
 	-rm -f *.o *.so *.ko .*.cmd *.mod.c

--fdj2RfSjLxBAspz7--
