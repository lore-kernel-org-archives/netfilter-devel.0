From: eddie shi <shenminshi@yahoo.com>
Subject: snmp-basic
Date: Sun, 12 Jan 2003 22:28:45 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030113062845.83048.qmail@web40301.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
  I am trying to use the module ip_nat_snmp_basic.c to
xlate the snmp ip-address related playload from
private ip address to outgoing public address. When
performing the snmpget from the SNMP manager , the
result I got still shows the private ipaddress. I then
started to enable debugging and also put some extra
printk() in the ip_nat_snmp_basic.c. What I found is
that the module did register itself during _init ,
however the module's helper  function(nat_help) never
get called.

  Is there something obvious I forgot to do? I am
using 2.4.17 kernel with newnat patched. I also use
iptables to do portfording of snmp port 161 to one of
my internal box running snmp agent. Here is my rule.
 
   iptables -t nat -A PREROUTING -i eth1 -p udp
--dport 161 -j DNAT --to 192.168.1.5

   Are there any other rules I need to add?

   BTW, does anyone know why there is no connection
tracking module (ie ip_conntrack_snmp_basic.c) for
this ?
   All other modules (ftp,talk,irc and etc) are
working fine in the system.

   Thanks 


Eddie

__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
