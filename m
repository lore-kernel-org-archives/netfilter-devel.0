From: Manu <manuprivat@gmx.de>
Subject: iptables
Date: Mon, 27 Apr 2009 10:05:22 +0200
Message-ID: <49F56742.7080309@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752079AbZD0IFL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:05:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi list,

if I use command:

#iptables -nvL -t mangle

I get:

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               
destination
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
    0     0 MARK       all  --  *      *       10.0.20.2            
0.0.0.0/0           MARK set 0x14


Everything works fine, but I get this error message?
My kernel is built with every point of iptables stuff included, not as 
module.
This error occurs only if I did an entry with MARK target, and it 
depends on iptables-version.
with iptables v.1.2.9 there is no error displayed.


iptables: v1.4.3.2
kernel: 2.6.23.9

Manu
