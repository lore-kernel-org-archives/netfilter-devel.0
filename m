From: "Matthew Connor" <connah@gmail.com>
Subject: IPTables only works for 70 seconds
Date: Thu, 24 Aug 2006 12:54:29 -0400
Message-ID: <db9442840608240954l6cefdd3fk302276a02a5f0854@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi all.

  I have configured my firewall "nat" and "filter" tables the way I want
them and saved them by using "service iptables save". The problem is,
when I reboot the system (or whenever I start IPTables at all), the
rules work fine for only 70 seconds. I know this because with another
machine, I am continuously monitoring my ability to contact port 80 on
a machine behind the firewall. When IPTables starts, for 70 seconds,
the port is available. After that, there is no more connectivity
although all signs point to IPTables still running on the box. I am
starting IPTables from within /etc/rc.d/rc.local with the command
"service iptables start". I tried having it start automatically with
chkconfig, but that resulted in the same problem AND an INCREDIBLY long
boot time. Does anyone have any idea why my firewall rules only work
for 70 seconds? Below is some system information. Please let me know if
I can provide more for you. Thank you!


SYSTEM INFORMATION:


uname -a
Linux pogo 2.6.9-5.ELsmp #1 SMP Wed Jan 5 19:30:39 EST 2005 i686 i686
i386 GNU/Linux


chkconfig --list | grep -i "ip"
iptables        0:off   1:off   2:off   3:off   4:off   5:off   6:off


iptables -V
iptables v1.2.11


cat /etc/sysconfig/iptables
Output Here: http://www.bonniedoone.com/iptables.txt
(Please note, public IPs have been obfuscated with X's for privacy)
