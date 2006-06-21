From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: Virutal Network Interface
Date: Wed, 21 Jun 2006 14:48:35 +0530 (IST)
Message-ID: <1424.10.107.26.27.1150881515.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Hi,
  I am working on a small application involving IPtables . But now
I have to make use of this virtual interface driver (insane) for my
application(http://www.linux.it/~rubini/docs/vinter/insane.tar.gz).

 I tried compiling it on kernel-2.6.11-6. but I got the following errors.
I am new to kernel programming and require your  help to solve this
compile time errors.

 This has been successfully tested under kernel-2.3

 Please give me your valuable suggestion.
 Thanx
**************ERROR*********************************8
cc -MM *.c > .depend
In file included from /usr/include/linux/sched.h:14,
                 from /usr/include/linux/module.h:9,
                 from insane.c:29:
/usr/include/linux/cpumask.h:238:5: error: missing binary operator before
token "("
/usr/include/linux/cpumask.h:297:5: error: missing binary operator before
token "("
/usr/include/linux/cpumask.h:366:5: error: missing binary operator before
token "("
In file included from /usr/include/linux/module.h:22,
                 from insane.c:29:
/usr/include/asm/module.h:60:2: error: #error unknown processor family
insane.c:32:45: error: linux/malloc.h: No such file or directory
insane.c:37:50: error: net/arp.h: No such file or directory
make: *** [depend] Error 1

**********************************
