From: "Andrew Hall" <andrew.hall@bluereef.com.au>
Subject: Bug in patch-o-matic-20030107 with tcp-window-tracking patch?
Date: Tue, 18 Feb 2003 16:20:01 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004b01c2d70d$63000e90$2601010a@bluereef.local>
References: <003901c2d0b3$f9fce8a0$2601010a@bluereef.local> <20030217085815.GG7631@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have been trying to apply the tcp-window-tracking patch to 2.2.20 from the
20030107 POM. It fails with no error but only that it didn't successfully
apply the patch.

When I manually apply the patch to the kernel including the makefile changes
it fails to compile with the errors below. The objects should be defined as
I placed the changes from tcp-window-tracking.makefile into
linux/net/ipv4/netfilter/Makefile. This should be all that is required? The
tcp-windows-tracking module isn't broken is it?

Thanks,

Andrew.

gcc -D__KERNEL__ -I/iso/2.4.20/linux-2.4.20/include -Wall -Wstrict-prototype
s -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer -
pipe -mpreferred-stack-boundary=2 -march=i686   -nostdinc -iwithprefix
include -DKBUILD_BASENAME=ip_conntrack_proto_tcp  -c -o
ip_conntrack_proto_tcp.o ip_conntrack_proto_tcp.c
ip_conntrack_proto_tcp.c:715: parse error before
"this_object_must_be_defined_as_export_objs_in_the_Makefile"
ip_conntrack_proto_tcp.c:715: warning: type defaults to `int' in declaration
of `this_object_must_be_defined_as_export_objs_in_the_Makefile'
ip_conntrack_proto_tcp.c:715: warning: data definition has no type or
storage class
make[3]: *** [ip_conntrack_proto_tcp.o] Error 1
make[3]: Leaving directory `/iso/2.4.20/linux-2.4.20/net/ipv4/netfilter'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory `/iso/2.4.20/linux-2.4.20/net/ipv4/netfilter'
make[1]: *** [_subdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/iso/2.4.20/linux-2.4.20/net'
make: *** [_dir_net] Error 2
