From: =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@ncparty.dk>
Subject: CONNMARK Patching Problem
Date: Sat, 9 Nov 2002 12:43:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <005a01c287e5$2d0862a0$0200000a@parseerror.dk>
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

Hey! :D

I'm having a very anoying problem.

I have patched 2.4.18-19 kernels where both have the same problem, when i
run patch-o-magic on a fresh kernel, then when i come to where i can patch
the CONNMARK module into the kernel, it always fail, even if it's the only
thing i select, and with both kernels, even they both are fresh installed.

Testing... CONNMARK.patch NOT APPLIED ( 4 missing files)
The extra/CONNMARK patch:
   Author: Henrik Nordstrom <hno@marasystems.com>
   Status: working

<-Nice information about the module...-->

-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/v/q/?] y
Testing patch extra/CONNMARK.patch...
   Placed new Config.in line
   Placed new Config.in line
   Placed new Config.in line
   Placed new Configure.help entry
   Placed new Makefile line
   Placed new Makefile line
Failed to patch copy of /usr/src/linux
TEST FAILED: patch NOT applied.

[Press enter to continue]


Im using from source

iptables 1.2.7a
patch-o-magic 20021008
have tried with newer cvs image patch-o-magic and did'nt even work
kernel 2.4.18-19 both have the same problem.

Does anybody know if theres a workaround for this thingie?.. or am i just
lost in my dreams until a new release come? Is there a way i can check what
the error is?

- SilverWolf
