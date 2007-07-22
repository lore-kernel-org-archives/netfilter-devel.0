From: "eescar@free.fr" <eescar@free.fr>
Subject: [PATCH] ulogd 1.24 mysql bad identification
Date: Mon, 23 Jul 2007 01:43:15 +0200
Message-ID: <46A3EB93.6080701@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi list,

trying to build ulogd-1.24, ./configure give me a warning, leading to a bad identification in the mysql :

....
checking for MySQL files... found mysql_config in /usr/bin
checking for mysql_real_escape_string support... strings: invalid option -- L
Usage: strings [option(s)] [file(s)]
 Display printable strings in [file(s)] (stdin by default)
 The options are:
  -a - --all                Scan the entire file, not just the data section
  -f --print-file-name      Print the name of the file before each string
  -n --bytes=[number]       Locate & print any NUL-terminated sequence of at
  -<number>                 least [number] characters (default 4).
  -t --radix={o,d,x}        Print the location of the string in base 8, 10 or 16
  -o                        An alias for --radix=o
  -T --target=<BFDNAME>     Specify the binary file format
  -e --encoding={s,S,b,l,B,L} Select character size and endianness:
                            s = 7-bit, S = 8-bit, {b,l} = 16-bit, {B,L} = 32-bit
  -h --help                 Display this information
  -v --version              Print the program's version number
strings: supported targets: elf32-i386 a.out-i386-linux efi-app-ia32 elf32-little elf32-big srec symbolsrec tekhex binary ihex trad-core
found old MySQL
.....

after some digging in the lists archives, it looks like ulogd 1.x support looks nearly "abandoned" ...

As I, and certainly some more people are, am "stucked" with kernel 2.4.x, working on a live-cd firewall distro(devil-linux), I tried to fix the
problem by myself; As I'm not developper and a "bad bash scripting guy", the patch may not be optimal but it solves the issue, at least for me :

....
checking for MySQL files... found mysql_config in /usr/bin
checking for mysql_real_escape_string support... found new MySQL
creating ./config.status
....

So, as it may help some folks around, I send it on this mailling-list ...


--- ulogd-1.24/configure.old    2007-07-22 17:24:37.000000000 -0500
+++ ulogd-1.24/configure        2007-07-22 17:18:17.000000000 -0500
@@ -1728,7 +1728,7 @@
 EOF

         MYSQLINCLUDES=`$d/mysql_config --include`
-        MYSQLLIBS=`$d/mysql_config --libs`
+        MYSQLLIBS=`$d/mysql_config --libs | awk '{ print $1 }' | cut -c3-`

        DATABASE_DIR="${DATABASE_DIR} mysql"


Thank you all for the fantastic job done,

Best Regards,

MaNU ESCaR
