From: "Bjo Breiskoll" <bjo@nefkom.net>
Subject: Writing a new netfilter-target with shared-library
Date: Tue, 21 Mar 2006 16:25:26 +0100
Message-ID: <005b01c64cfb$adcbe180$03b2a8c0@bjoserver>
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

Hello,
 
i've written a new netfilter-module which implements an ring-buffer for
ip-v4 header in kernelspace. This works pretty good. After the decision of
implementing some arguments for the kernel-modul like start/stop/reset
buffer, changeable buffersize ... i implemented this argument-handling with
module parameter (module_param ...). But it would be much nicer to write a
shared-library which handles this - so i am able to change parameters with
<iptables>.
 
After reading some faqs i found out that i have to write a shared library
but i have to check and test it very often. So patch-o-matic seems a bit
unpractiable. Is there a way to build the needed libs out of the
"netfilter-build"-system for test purposes? Like <gcc -fPIC -Wall -c
testlib.c>.

Regards and hope for help ...
BJO
