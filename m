From: Kishore Dharmavaram <kishored@servgate.com>
Subject: Memory leaks in ip_conntrack?
Date: Fri, 7 Nov 2003 14:21:13 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B2041@skat.sky.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter@lists.netfilter.org'" <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi All,

I have a Linux box running 2.4.20 kernel with netfilter(ip_conntrack)
compiled-in. When I do stress test on the box I find from /proc/slabinfo
that ip_conntracks have reached maximum value 131072 and box stopped
processing to any traffic, but strange thing is there are only 21 entries in
/proc/net/ip_conntrack. 

My question is why are there only 21 entries in "/proc/net/ip_conntrack"
when /proc/slabinfo shows 131072 entries, does this indicate memory leaks in
netfilter code? 

Please provide me some insight, hints into the problem, is there any way I
can find out rest of ip_conntracks. 

Note: There are application proxies, squid(Http), POP, SMTP, FTP, running on
the Linux box. 

Thanks,
Kishore

[root@Firewall root]# uname -a
Linux Firewall 2.4.20 #9 Thu Oct 30 00:49:56 PST 2003 i686 i686 i386
GNU/Linux
[root@Firewall root]# cat /proc/slabinfo | fgrep ip_conn
ip_conntrack      131072 131080    384 13108 13108    1
[root@Firewall root]#
[root@Firewall root]# cat /proc/net/ip_conntrack | wc -l
     21
[root@Firewall root]#
