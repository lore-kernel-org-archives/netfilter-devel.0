From: Andreas Haumer <andreas@xss.co.at>
Subject: iptables compile problem with glibc-2.1.3 and kernel 2.4.21
Date: Tue, 08 Jul 2003 12:07:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F0A97FC.4030008@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: andreas@xss.co.at
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

I have a compile problem with iptables 1.2.8:

[...]
make -j 1 BINDIR=/usr/bin LIBDIR=/usr/lib MANDIR=/usr/man KERNEL_DIR=/lib/modules/2.4.21-xss/build/
Making dependencies: please wait...
Extensions found: IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
cc -O2 -Wall -Wunused -I/lib/modules/2.4.21-xss/build//include -Iinclude/ -DIPTABLES_VERSION=\"1.2.8\"  -fPIC -o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
ld -shared -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
cc -O2 -Wall -Wunused -I/lib/modules/2.4.21-xss/build//include -Iinclude/ -DIPTABLES_VERSION=\"1.2.8\"  -fPIC -o extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c
In file included from /lib/modules/2.4.21-xss/build/include/linux/bitops.h:3,
                 from /lib/modules/2.4.21-xss/build/include/linux/netfilter_ipv4/ip_conntrack.h:9,
                 from extensions/libipt_conntrack.c:12:
/lib/modules/2.4.21-xss/build/include/asm/bitops.h:410: conflicting types for `__ffs'
/usr/include/string.h:247: previous declaration of `__ffs'
make: *** [extensions/libipt_conntrack_sh.o] Error 1
[...]

Headers under "/usr/include/" come from glibc-2.1.3
"/lib/modules/2.4.21-xss/build/" is a symlink pointing to
linux-2.4.21 kernel sources (with ac4 patches)

Linux 2.4 and glibc-2.1.3 seem to have a different understanding
about __ffs(). Both use their own one...

Usually, this is not a problem, as userspace programs
don't include kernel headers, but iptables does.

I checked the mailing lists for glibc, linux-kernel and
iptables for solutions, but couldn't find any.

Any idea anyone?

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/Cpf0xJmyeGcXPhERAgV4AJ41x3dVZP28Uqf8e0Z+mH6QXXfnvACguiNf
7qNlvwr0SX/6F6kjjqga0JU=
=g7zb
-----END PGP SIGNATURE-----
