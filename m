From: Lev Stipakov <lstipakov@gmail.com>
Subject: iptables audit target causes kernel panic with iptables-persistent
	(kernel 3.2.78)
Date: Tue, 26 Apr 2016 11:58:32 +0300
Message-ID: <nfnajo$4cj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: linux-audit@redhat.com
Return-path: <linux-audit-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

Hello,

I see kernel panic with iptables-persistent package installed and one 
iptables rule with AUDIT target.

   root@debian7:~# uname -a
   Linux debian7 3.2.0-4-amd64 #1 SMP Debian 3.2.78-1 x86_64 GNU/Linux

   root@debian7:~# dpkg -l | grep iptables
   ii  iptables			1.4.14-3.1
   ii  iptables-persistent	0.5.7+deb7u1

Steps to reproduce:

1) Install Debian 7 and iptables-persistent (see versions above)
2) Add iptables rule (must be OUTPUT chain):

   root@debian7:~# iptables -I OUTPUT -j AUDIT --type ACCEPT

3) Save rule:

   root@debian7:~# iptables-save > /etc/iptables/rules.v4

4) Reboot

5) Kernel panic (screenshot): 
https://www.dropbox.com/s/db40e5kc10e4ddg/kernel_panic2.png?dl=0


I cannot reproduce it on (one of) previous kernel version:

   lev@debi7:~$ uname -a
   Linux debi7 3.2.0-4-amd64 #1 SMP Debian 3.2.73-2+deb7u2 x86_64 GNU/Linux

   lev@debi7:~$ dpkg -l | grep iptables
   ii  iptables                           1.4.14-3.1
   ii  iptables-persistent                0.5.7+deb7u1


-Lev
