From: "Igor" <more@skyportal.com>
Subject: iplimit depmod problem
Date: Mon, 14 Oct 2002 13:57:40 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000501c27370$84a56b40$0aa115d9@softbear.lv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1251"
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

I'm trying to compile 2.4.19 kernel with iplimit module from patch-o-matic-20021013 or patch-o-matic-20020825 under slackware 8.0.
Compillation ends without errors, but when run "make modules_install" depmod says:

depmod: *** Unresolved symbols in /lib/modules/2.4.19/kernel/net/ipv4/netfilter/ipt_iplimit.o
depmod:         ip_conntrack_find_get

How do I fix this?
Thank you.
