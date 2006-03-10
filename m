From: "Bjo Breiskoll" <bjo@nefkom.net>
Subject: Compiling a netfilter shared library
Date: Fri, 10 Mar 2006 13:22:46 +0100
Message-ID: <000701c6443d$5700c580$03b2a8c0@bjoserver>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Netfilter-Devel@Lists" <netfilter-devel@lists.netfilter.org>
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

Hello.

Im currently developing a new netfilter-target for the current
netfilter-framework under kernel 2.6.x. I had only a few problems with the
kernel-modul registering a new target. After the decision of implementing a
few user-mode commands via iptables i need to compile a shared-library for
my module.
And here is the problem: Is there a "special" way for compiling
iptables-shared-libs? For testing purpose i've tried the TCPLAG-Target: The
Kernelmodul compiled well but with "gcc -fPIC -c libipt_TCPLAG.c" for the
library only compile-errors occour.
 
Maybe i need special compilation arguments?

Regards
BJO
