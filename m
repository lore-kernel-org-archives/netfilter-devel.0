From: "SB CH" <chulmin2@hotmail.com>
Subject: lots of ACK/FIN filtering (DPT=80) at web server.
Date: Thu, 29 May 2003 08:46:21 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-F81QtbpgYuNQKm0004e8b9@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987; format=flowed
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

Hello, all.

I have operated linux web server and executed iptables 1.2.8.

and I have found so lots of logs like this ACK,FIN filtering.
Surely, ACK-FIN is a connection closing step, so there is no problem for 
customers but I would like to know why this happens!!
I guess that the timeout of the connection tracking related.


May 25 12:33:05 www kernel: IN=eth0 OUT= SRC=210.126.xxx.xx 
DST=211.10.xx.xx LEN=40 TOS=0x00 PREC=0x00 TTL=118 ID=3376 DF PROTO=TCP 
SPT=3608 DPT=80 WINDOW=63520 RES=0x00 ACK FIN URGP=0

Do you have any problems like me?
and what's the problem and how can I solve this problem?


Thanks in advance for your kind opinios!!

_________________________________________________________________
행운의 주인공이 이번엔 나일꺼야, 진짜루... 인터넷 복권   
http://www.msn.co.kr/money/interlotto/  
