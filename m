From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH NFSIM]: Fix linker error on x86_64
Date: Thu, 06 Jan 2005 15:07:01 +0100
Message-ID: <41DD4605.3090907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040006070909060205070106"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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

This is a multi-part message in MIME format.
--------------040006070909060205070106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty,

I have a couple of nfsim fixes for x86_64. Please review and apply the 
correct ones.

Thanks,
Patrick


This patch fixes a linker error on x86_64 when linking core/fakesockopt.o:

gcc -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -g -Wa,-W 
-shared -Wl,-soname,fakesockopt.so.1 -nostdlib -ldl \
        -o core/fakesockopt.so.1.0 core/fakesockopt.o core/utils.o
/usr/bin/ld: core/fakesockopt.o: relocation R_X86_64_32S can not be used 
when making a shared object; recompile with -fPIC
core/fakesockopt.o: could not read symbols: Bad value
collect2: ld returned 1 exit status
make: *** [core/fakesockopt.so.1.0] Error 1



--------------040006070909060205070106
Content-Type: text/x-patch;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.diff"

Index: Makefile.in
===================================================================
--- Makefile.in	(revision 3578)
+++ Makefile.in	(working copy)
@@ -58,6 +58,12 @@
 		-o $@ $^
 	ln -sf core/fakesockopt.so.1.0 ./
 
+core/fakesockopt.o:
+	$(CC) $(CFLAGS) -c -fPIC core/fakesockopt.c -o core/fakesockopt.o
+
+core/utils.o:
+	$(CC) $(CFLAGS) -c -fPIC core/utils.c -o core/utils.o
+
 core/usage.o: core/usage.c
 core/usage.c: $(USAGE_SOURCES) doc/gen-usage
 	doc/gen-usage $(USAGE_SOURCES) >$@

--------------040006070909060205070106--
