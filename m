From: Max Kellermann <max@duempel.org>
Subject: nfsim for Linux 2.6.12-rc4?
Date: Wed, 11 May 2005 21:56:52 +0200
Message-ID: <20050511195652.GA14386@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

is anyone already working on the Linux 2.6.12 port of nfsim?  If not,
I'll do it.

gcc -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -g -Wa,-W
-I. -I/tmp/nfsim-3/core -I/tmp/nfsim-3/kernelenv/include
-I/tmp/nfsim-3/netfilter/include  -c  -DKBUILD_MODNAME=ip_nat_ftp -o
ip_nat_ftp.o ip_nat_ftp.c
ip_nat_ftp.c:174: warning: "struct kernel_param" declared inside
parameter list
ip_nat_ftp.c:174: warning: its scope is only this definition or
declaration, which is probably not what you want
ip_nat_ftp.c:180: error: parse error before '(' token
ip_nat_ftp.c:175: warning: 'warn_set' defined but not used
make[2]: *** [ip_nat_ftp.o] Error 1


Max
