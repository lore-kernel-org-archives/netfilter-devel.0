From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: p-o-m: nf-log fix
Date: Tue, 10 Aug 2004 13:05:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092135947.2905.346.camel@develbox.linuxbox.cz>
Reply-To: nikola.ciprich@linuxbox.cz
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, I think there is small bug in nf-log p'o'm patchset,
can You please apply following patch: (in case it is correct)

diff -Naur patch-o-matic-ng-20040809/nf-log/linux-2.4.patch
patch-o-matic-ng-20040809-nf-log_fix/nf-log/linux-2.4.patch
--- patch-o-matic-ng-20040809/nf-log/linux-2.4.patch    2004-02-19
12:36:55.000000000 +0100
+++ patch-o-matic-ng-20040809-nf-log_fix/nf-log/linux-2.4.patch
2004-08-10 12:07:10.644846287 +0200
@@ -402,7 +402,7 @@
 +      }
 +
 +      /* if threshold is reached, send message to userspace */
-+      if (qlen >= loginfo.qthreshold) {
++      if (ub->qlen >= loginfo.qthreshold) {
 +              if (loginfo.qthreshold > 1)
 +                      nlh->nlmsg_type = NLMSG_DONE;
 +      }

thanks,
n.

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
