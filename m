From: Henrik Nordstrom <hno@marasystems.com>
Subject: problem with active ftp masqarading in kernel newer than 2.6.10-rc1
 (fwd)
Date: Fri, 22 Apr 2005 09:11:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504220909400.21714@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Mateusz <mateusz@republika.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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

found on linux-net.


---------- Forwarded message ----------
Date: Fri, 22 Apr 2005 00:28:28 +0200
From: Mateusz <mateusz@republika.pl>
To: linux-net@vger.kernel.org
Subject: problem with active ftp masqarading in kernel newer than 2.6.10-rc1

Hi, first I want to quote the person who have the same problem:

"  Hello,

I found problem with active ftp masqarading in kernel 2.6.11.
I use linux firewall with masquarading for the local network.
When I run ftp client in active mode on any machines in the local network,
I can connect to remote ftp server in outside network (Internet). But
when I get "mget *" command in this ftp session, client downloads about
5 files only and then writes "500 R not understood" and then
"ftp: bind: Address already in use" and it stops.
I tried capture some packets and it looks firewall leaves off masqurading
for
this sessin.
When I switch ftp client to "passive" mode, all works fine.
When I run kernel 2.6.9 (and previous) on the firewall, all works fine (both

active and passive mode).

I tried it on miscellaneous firewalls (with 2.6.11 kernel), miscellaneous
ftp
servers and miscellaneous ftp clients (in active mode) with same results. I
tried both iptables-1.3.1 and iptables-1.3.0 without success.

Regards,
                Milos Wimmer "

I have testes my 2 servers, and investigate that in kernel 2.6.10-rc1
all is OK., but in 2.6.10-rc2 and laters the problem occurs (tested to
2.6.11.7 and 2.6.12-rc2)
In my problem I don't have this message ""ftp: bind: Address already in use"
and it stops.".
Rest is the same - after uploading few files to the ftp server (out from my
network) i have
message:
PORT 10,0,4,32,11,121
200 PORT command successful.
STOR P4020553.JPG
500: " OR P4020553.JPG not understood."
It seems, that first two letters from this command were cutted, and server
gets "OR"
instead of "STOR" command

I have tested it on different ftp servers, clients, and hosts in my network,
in passive
mode all works fine.


Redards, Mateusz Pluta



