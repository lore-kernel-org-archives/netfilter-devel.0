From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Wed, 22 Jun 2005 13:39:42 +0200
Message-ID: <42B94DFE.2070205@tac.ch>
References: <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net>	<20050621215027.GP8335@postel.suug.ch>
	<42B8B181.4020607@trash.net>	<20050622005243.GQ8335@postel.suug.ch>	<42B8DA09.9080406@eurodev.net>
	<42B8E141.1080902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040006060607060107060800"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42B8E141.1080902@trash.net>
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

This is a multi-part message in MIME format.
--------------040006060607060107060800
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Back with some results.

First I used following patch to make stuff more visible:

--- linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_core.c    Wed Jun 15 15:25
:41 2005
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_core.c    Wed Jun 22 11:24
:57 2005
@@ -46,7 +46,8 @@

 #define IP_CONNTRACK_VERSION   "2.1"

-#if 0
+//#if 0
+#if 1
 #define DEBUGP printk
 #else
 #define DEBUGP(format, args...)
@@ -1389,10 +1390,23 @@
  i_see_dead_people:
        ip_ct_iterate_cleanup(kill_all, NULL);
        if (atomic_read(&ip_conntrack_count) != 0) {
+               if (net_ratelimit()) {
+                       printk(KERN_ERR "dead poets society seeks for conntrack_
cnt: %d\n", atomic_read(&ip_conntrack_count));
+               }
                schedule();
                goto i_see_dead_people;
        }

+
+       while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1) {
+               if (net_ratelimit()) {
+                       printk(KERN_ERR "untracked_use_cnt: %d, conntrack_cnt: %
d\n",
+                               atomic_read(&ip_conntrack_untracked.ct_general.u
se),
+                               atomic_read(&ip_conntrack_count));
+               }
+               schedule();
+       }
+
        kmem_cache_destroy(ip_conntrack_cachep);
        vfree(ip_conntrack_hash);
        nf_unregister_sockopt(&so_getorigdst);

Every second I ran following little scriptlet and stored the information in a
file attached as sockstat_log-save:

#!/bin/bash

echo "timestamp"
echo "---------"
date +%T
echo
echo "iptables states"
echo "---------------"
iptstate -L -s -t
echo
echo "sockstat"
echo ----------
ss -a -e -p -i -n -m
ss -a -e -0
echo "lsmod"
echo "-----"
lsmod
echo "*******************************************************************"

For a couple of seconds the ip_conntrack in in deleted state and the whole
machine hangs, after 30 seconds I can work again on all sessions (logged in via
ssh) which have the NOTRACK flag set.

> I agree, let's track down the untracked-missing-references first, then
> see if any problems remain.

I attached the kernlog during the rmmod ip_conntrack and others. The nf_reset()
part is commented out.

Let me know if you need something else.

Regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------

--------------040006060607060107060800
Content-Type: text/plain;
 name="sockstat_log-save"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sockstat_log-save"

timestamp
---------
15:17:44

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 1 -- TCP: 1 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    
172.23.2.30:33088     172.23.120.120:234    tcp     ESTABLISHED    0:04:59

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,119min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f4096,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f8192,t0) ts sack wscale:0,0 rto:220 rtt:22.5/15 ato:40 cwnd:23
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:46

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 1 -- TCP: 1 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    
172.23.2.30:33088     172.23.120.120:234    tcp     ESTABLISHED  119:59:59

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,119min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f4096,t1800) ts sack wscale:0,0 rto:220 rtt:22.5/15 ato:40 cwnd:12
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:47

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 1 -- TCP: 1 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    
172.23.2.30:33088     172.23.120.120:234    tcp     ESTABLISHED  119:59:59

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,119min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      31808        172.23.120.120:234            172.23.2.30:33088  timer:(on,210ms,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w41400,f3656,t1800) ts sack wscale:0,0 rto:220 rtt:20/10 ato:40 cwnd:25
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:48

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 1 -- TCP: 1 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    
172.23.2.30:33088     172.23.120.120:234    tcp     ESTABLISHED    0:04:59

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,119min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t1800) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:49

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 1 -- TCP: 1 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    
172.23.2.30:33088     172.23.120.120:234    tcp     ESTABLISHED    0:04:59

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,119min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f4096,t1800) ts sack wscale:0,0 rto:220 rtt:22.5/15 ato:40 cwnd:22
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:50

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,160ms,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,400ms,1) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:51

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,390ms,2) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,210ms,2) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:52

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,1.030ms,3) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,850ms,3) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:53

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,3.350ms,4) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,3.170ms,4) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:54

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,2.320ms,4) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,2.140ms,4) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:55

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,1.280ms,4) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,1.100ms,4) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:56

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,250ms,4) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,070ms,4) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:57

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,5.940ms,5) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,5.760ms,5) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:58

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,4.880ms,5) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,4.700ms,5) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:17:59

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,3.850ms,5) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,3.670ms,5) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:00

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,2.820ms,5) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,2.640ms,5) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:01

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,1.790ms,5) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,1.610ms,5) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:02

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,760ms,5) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,580ms,5) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:03

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,13sec,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,12sec,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:04

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,12sec,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,11sec,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:05

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,11sec,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,10sec,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:06

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,10sec,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,9.900ms,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:07

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,9.050ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,8.870ms,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:08

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,8.020ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      80           172.23.120.120:234            172.23.2.31:45103  timer:(persist,7.840ms,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w1800,f2296,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ip_conntrack               0   0  (deleted)
ipt_LOG                 3728   0  (autoclean)
ipt_limit               1360   0  (autoclean)
iptable_raw             1440   0  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   0  (autoclean)
ip_tables              12352   5  [ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:09

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,6.990ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f4096,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   3  (autoclean)
ipt_state                768  50  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  24  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:10

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,5.960ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:11

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,4.930ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:12

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,3.900ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:13

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,2.870ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:14

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,1.840ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:15

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      48           172.23.120.120:234            172.23.2.31:48701  timer:(persist,810ms,6) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w1800,f2296,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:16

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,119min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:18

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:19

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:20

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,68min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:21

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:22

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:23

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:24

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:25

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:26

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:27

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:28

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:29

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:30

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:31

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:32

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:33

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:34

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,69min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:35

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:36

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:37

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:38

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:39

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:40

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:41

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:42

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:43

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,68min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:44

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:45

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:46

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:47

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,6) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:48

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:49

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:50

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************
timestamp
---------
15:18:52

iptables states
---------------
IP Tables State Top -- Sort by: SrcIP
Total States: 0 -- TCP: 0 UDP: 0 ICMP: 0 OTHER: 0
Source                Destination           Proto   State        TTL    

sockstat
----------
State      Recv-Q Send-Q        Local Address:Port          Peer Address:Port 
LISTEN     0      0                         *:234                      *:*      users:(("sshd-admin",795,3)) ino:1166 sk:f77c2060
	 mem:(r0,w0,f0,t0)
ESTAB      0      0            172.23.120.120:234            172.23.2.31:48701  timer:(keepalive,118min,0) users:(("sshd-admin",3539,4)) ino:152066 sk:f6c0d800
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45103  timer:(keepalive,67min,0) users:(("sshd-admin",882,4)) ino:1489 sk:f6f3ebe0
	 mem:(r0,w0,f0,t1800) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.31:45102  timer:(keepalive,67min,0) users:(("sshd-admin",873,4)) ino:1452 sk:f706b040
	 mem:(r0,w0,f0,t0) ts sack wscale:2,0 rto:210 rtt:18.75/7.5 ato:40
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33088  timer:(keepalive,118min,0) users:(("sshd-admin",3632,4)) ino:162265 sk:f694e420
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:17
ESTAB      0      0            172.23.120.120:234            172.23.2.30:33015  timer:(keepalive,68min,0) users:(("sshd-admin",1462,4)) ino:2452 sk:f7026c00
	 mem:(r0,w0,f0,t0) ts sack wscale:0,0 rto:210 rtt:18.75/7.5 ato:40 cwnd:3
Netid  State      Recv-Q Send-Q   Local Address:Port       Peer Address:Port   
lsmod
-----
Module                  Size  Used by
ipt_NOTRACK              944   6  (autoclean)
ipt_state                768  65  (autoclean)
ip_nat_ftp              2800   0  (unused)
iptable_nat            19600   1  [ip_nat_ftp]
ip_conntrack_ftp        3904   1 
ip_conntrack           32256   1  [ipt_NOTRACK ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ipt_LOG                 3728  29  (autoclean)
ipt_limit               1360   6  (autoclean)
iptable_raw             1440   1  (autoclean)
iptable_mangle          2416   0  (autoclean) (unused)
iptable_filter          1904   1  (autoclean)
ip_tables              12352  10  [ipt_NOTRACK ipt_state iptable_nat ipt_LOG ipt_limit iptable_raw iptable_mangle iptable_filter]
*******************************************************************

--------------040006060607060107060800
Content-Type: text/plain;
 name="kernlog-save"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernlog-save"

Jun 22 15:12:14 s_int@sem-arbeit ip_conntrack_in: normal packet for f6fafea8
Jun 22 15:12:14 s_int@sem-arbeit ip_conntrack_in: normal packet for f6fafea8
Jun 22 15:12:18 s_int@sem-arbeit ip_conntrack_in: new packet for f6efeea8
Jun 22 15:12:18 s_int@sem-arbeit Altering reply tuple of f6efeea8 to tuple f6f0bc78: 6 172.23.2.31:45103 -> 172.23.120.120:234
Jun 22 15:12:18 s_int@sem-arbeit destroy_conntrack(f6efeea8)
Jun 22 15:12:18 s_int@sem-arbeit destroy_conntrack: returning ct=f6efeea8 to slab
Jun 22 15:12:18 s_int@sem-arbeit clean_from_lists(f6fafea8)
Jun 22 15:12:18 s_int@sem-arbeit remove_expectations(f6fafea8)
Jun 22 15:12:18 s_int@sem-arbeit destroy_conntrack(f6fafea8)
Jun 22 15:12:18 s_int@sem-arbeit destroy_conntrack: returning ct=f6fafea8 to slab
Jun 22 15:12:18 s_int@sem-arbeit NET: 11980617 messages suppressed.
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:18 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:23 s_int@sem-arbeit NET: 26269793 messages suppressed.
Jun 22 15:12:23 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:28 s_int@sem-arbeit NET: 26417688 messages suppressed.
Jun 22 15:12:28 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:33 s_int@sem-arbeit NET: 26284076 messages suppressed.
Jun 22 15:12:33 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:38 s_int@sem-arbeit NET: 26310362 messages suppressed.
Jun 22 15:12:38 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:43 s_int@sem-arbeit NET: 26308346 messages suppressed.
Jun 22 15:12:43 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:48 s_int@sem-arbeit NET: 26244255 messages suppressed.
Jun 22 15:12:48 s_int@sem-arbeit untracked_use_cnt: 2, conntrack_cnt: 0
Jun 22 15:12:53 s_int@sem-arbeit ip_conntrack version 2.1 (8192 buckets, 65536 max) - 324 bytes per conntrack
Jun 22 15:12:53 s_int@sem-arbeit ip_conntrack_in: new packet for f6a96ea8
Jun 22 15:12:53 s_int@sem-arbeit Altering reply tuple of f6a96ea8 to tuple f6f0bc78: 6 172.23.2.31:45103 -> 172.23.120.120:234
Jun 22 15:12:53 s_int@sem-arbeit destroy_conntrack(f6a96ea8)
Jun 22 15:12:53 s_int@sem-arbeit destroy_conntrack: returning ct=f6a96ea8 to slab
Jun 22 15:12:53 s_int@sem-arbeit ip_conntrack_in: new packet for f6a96ea8
Jun 22 15:12:53 s_int@sem-arbeit Altering reply tuple of f6a96ea8 to tuple f6f0bc78: 6 172.23.2.31:45103 -> 172.23.120.120:234
Jun 22 15:12:53 s_int@sem-arbeit destroy_conntrack(f6a96ea8)
Jun 22 15:12:53 s_int@sem-arbeit destroy_conntrack: returning ct=f6a96ea8 to slab
Jun 22 15:12:53 s_int@sem-arbeit ip_conntrack_in: new packet for f6a96ea8
Jun 22 15:12:53 s_int@sem-arbeit Altering reply tuple of f6a96ea8 to tuple f6f0bc78: 6 172.23.2.31:45103 -> 172.23.120.120:234
Jun 22 15:12:53 s_int@sem-arbeit destroy_conntrack(f6a96ea8)
Jun 22 15:12:53 s_int@sem-arbeit destroy_conntrack: returning ct=f6a96ea8 to slab
Jun 22 15:13:09 s_int@sem-arbeit icmp_error_track: too short
Jun 22 15:13:09 s_int@sem-arbeit ip_conntrack_in: new packet for f6a96ea8
Jun 22 15:13:09 s_int@sem-arbeit Altering reply tuple of f6a96ea8 to tuple c2a75d1c: 1 172.23.120.120:37966 -> 172.23.134.111:0
Jun 22 15:13:09 s_int@sem-arbeit destroy_conntrack(f6a96ea8)
Jun 22 15:13:09 s_int@sem-arbeit destroy_conntrack: returning ct=f6a96ea8 to slab
Jun 22 15:13:09 s_int@sem-arbeit icmp_error_track: too short
Jun 22 15:13:09 s_int@sem-arbeit ip_conntrack_in: new packet for f6ea0ea8
Jun 22 15:13:09 s_int@sem-arbeit Altering reply tuple of f6ea0ea8 to tuple c2a77d1c: 1 172.23.120.120:37966 -> 172.23.134.111:0
Jun 22 15:13:09 s_int@sem-arbeit destroy_conntrack(f6ea0ea8)
Jun 22 15:13:09 s_int@sem-arbeit destroy_conntrack: returning ct=f6ea0ea8 to slab
Jun 22 15:13:09 s_int@sem-arbeit icmp_error_track: too short
Jun 22 15:13:09 s_int@sem-arbeit ip_conntrack_in: new packet for f6ea0ea8
Jun 22 15:13:09 s_int@sem-arbeit Altering reply tuple of f6ea0ea8 to tuple c2a77d1c: 1 172.23.120.120:37966 -> 172.23.134.111:0
Jun 22 15:13:09 s_int@sem-arbeit destroy_conntrack(f6ea0ea8)
Jun 22 15:13:09 s_int@sem-arbeit destroy_conntrack: returning ct=f6ea0ea8 to slab
Jun 22 15:13:15 s_int@sem-arbeit ip_conntrack_in: new packet for f6ea0ea8
Jun 22 15:13:15 s_int@sem-arbeit Altering reply tuple of f6ea0ea8 to tuple c2a77d1c: 17 172.23.255.255:137 -> 172.23.2.17:137
Jun 22 15:13:15 s_int@sem-arbeit destroy_conntrack(f6ea0ea8)
Jun 22 15:13:15 s_int@sem-arbeit destroy_conntrack: returning ct=f6ea0ea8 to slab
Jun 22 15:13:16 s_int@sem-arbeit ip_conntrack_in: new packet for f6eb9ea8
Jun 22 15:13:16 s_int@sem-arbeit Altering reply tuple of f6eb9ea8 to tuple c03c1d34: 6 172.23.120.120:234 -> 172.23.2.30:33015
Jun 22 15:13:16 s_int@sem-arbeit destroy_conntrack(f6eb9ea8)
Jun 22 15:13:16 s_int@sem-arbeit destroy_conntrack: returning ct=f6eb9ea8 to slab
Jun 22 15:13:17 s_int@sem-arbeit ip_conntrack_in: new packet for f6eb9ea8
Jun 22 15:13:17 s_int@sem-arbeit Altering reply tuple of f6eb9ea8 to tuple c03c1d34: 17 172.23.255.255:137 -> 172.23.2.17:137
Jun 22 15:13:17 s_int@sem-arbeit destroy_conntrack(f6eb9ea8)
Jun 22 15:13:17 s_int@sem-arbeit destroy_conntrack: returning ct=f6eb9ea8 to slab
Jun 22 15:13:17 s_int@sem-arbeit ip_conntrack_in: new packet for f6eb9ea8
Jun 22 15:13:17 s_int@sem-arbeit Altering reply tuple of f6eb9ea8 to tuple c03c1d34: 17 172.23.255.255:137 -> 172.23.2.17:137
Jun 22 15:13:17 s_int@sem-arbeit destroy_conntrack(f6eb9ea8)
Jun 22 15:13:17 s_int@sem-arbeit destroy_conntrack: returning ct=f6eb9ea8 to slab
Jun 22 15:13:19 s_int@sem-arbeit ip_conntrack_in: new packet for f6ea0ea8
Jun 22 15:13:19 s_int@sem-arbeit Altering reply tuple of f6ea0ea8 to tuple c2a77d1c: 17 172.23.255.255:137 -> 172.23.2.17:137
Jun 22 15:13:19 s_int@sem-arbeit destroy_conntrack(f6ea0ea8)
Jun 22 15:13:19 s_int@sem-arbeit destroy_conntrack: returning ct=f6ea0ea8 to slab
Jun 22 15:13:19 s_int@sem-arbeit ip_conntrack_in: new packet for f6a96ea8
Jun 22 15:13:19 s_int@sem-arbeit Altering reply tuple of f6a96ea8 to tuple c2a75d1c: 17 172.23.255.255:138 -> 172.23.2.17:138
Jun 22 15:13:19 s_int@sem-arbeit destroy_conntrack(f6a96ea8)
Jun 22 15:13:19 s_int@sem-arbeit destroy_conntrack: returning ct=f6a96ea8 to slab

--------------040006060607060107060800--
