From: Gergely Imre <gimre@nextra.ro>
Subject: iptables compilation (or user :) error
Date: Wed, 10 Sep 2003 16:49:09 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


hi

i've got the latest source from CVS, and i wanted to compile it, but it 
stops after a few seconds with the following error:

[root@imi userspace]# make
Making dependencies: please wait...
Something wrong... deleting dependencies.
make: *** [/usr/src/linux/include/linux/netfilter_ipv4/ipt_CLASSIFY.h] 
Error 1

i have kernel source 2.4.22. do i have to patch it, or why isn't this 
working? thx.

-- 
Gergely Imre                       email: gimre@nextra.ro
sysadmin   mobile: +40-745-105592, office: +40-266-317500
Nextra Tele Com SRL   str. Florilor 28/1, 4100 M-Ciuc, RO
http://www.nextra.ro/gimre                 ICQ# 101510959
