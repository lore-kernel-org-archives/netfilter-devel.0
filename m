From: jpiszcz <jpiszcz@lucidpixels.com>
Subject: Re: [Fwd: Question with printk warnings in ip_conntrack with 2.4.20.]
Date: Thu, 05 Dec 2002 18:25:49 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEFE07D.4020909@lucidpixels.com>
References: <1038618763.22065.1.camel@rth.ninka.net> <20021205200756.GB11068@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Linux Kernel Mailinglist
 <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
Stange? &nbsp;I am just using vcheck (perl script) that goes out and checks out
software for the latest versions.<br>
<br>
Here is an example of what happens when I run it:<br>
<a class="moz-txt-link-freetext" href="http://www.tu-ilmenau.de/~gomar/stuff/vcheck/">http://www.tu-ilmenau.de/~gomar/stuff/vcheck/</a> <br>
<br>
All it does is goes out to http/ftps site, matches a regex to check for the
latest version of whatever you have, ie: sample entry:<br>
<br>
prog util-linux = {<br>
&nbsp; version&nbsp;&nbsp; = 2.11y<br>
&nbsp; urgency&nbsp;&nbsp; = high<br>
&nbsp; dl&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = no<br>
&nbsp; lastcheck = "2002-12-05 06:07"<br>
&nbsp; url&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; = <a class="moz-txt-link-freetext" href="ftp://ftp.win.tue.nl/pub/home/aeb/linux-local/utils/util-linux/">ftp://ftp.win.tue.nl/pub/home/aeb/linux-local/utils/util-linux/</a><br>
&nbsp; regex&nbsp;&nbsp;&nbsp;&nbsp; = util-linux-(__VER__)\.tar<br>
}<br>
<br>
This program is very useful and those warnings highly annoying. :) <br>
Will there possibly be a /proc or kernel config option for warnings such
as these?<br>
<br>
<br>
Dec&nbsp; 5 18:20:23 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;199.232.41.7, reusing<br>
Dec&nbsp; 5 18:20:25 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;204.214.92.161, reusing<br>
Dec&nbsp; 5 18:20:27 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;209.249.29.67, reusing<br>
Dec&nbsp; 5 18:20:30 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;209.249.29.67, reusing<br>
Dec&nbsp; 5 18:20:35 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;195.37.77.171, reusing<br>
Dec&nbsp; 5 18:21:00 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;216.180.224.6, reusing<br>
Dec&nbsp; 5 18:21:06 lucidpixels kernel: BLOCK: IN=eth1 OUT= MAC=00:a0:24:05:eb:87:00:c0:7b:b1:8d:3b:08:00
SRC=130.239.18.137 DST=66.45.37.187 LEN=1500 TOS=0x00 PREC=0x00 TTL=232 ID=47301
DF PROTO=ICMP TYPE=8 CODE=0 ID=0 SEQ=0 <br>
Dec&nbsp; 5 18:21:18 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;130.239.18.137, reusing<br>
Dec&nbsp; 5 18:21:29 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;130.239.18.137, reusing<br>
Dec&nbsp; 5 18:21:38 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;195.40.6.41, reusing<br>
Dec&nbsp; 5 18:21:42 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;204.80.150.47, reusing<br>
Dec&nbsp; 5 18:21:44 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;199.232.41.7, reusing<br>
Dec&nbsp; 5 18:21:47 lucidpixels kernel: BLOCK: IN=eth1 OUT= MAC=00:a0:24:05:eb:87:00:c0:7b:b1:8d:3b:08:00
SRC=130.239.18.137 DST=66.45.37.187 LEN=1500 TOS=0x00 PREC=0x00 TTL=232 ID=28140
DF PROTO=ICMP TYPE=8 CODE=0 ID=0 SEQ=2 <br>
Dec&nbsp; 5 18:21:57 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;199.232.41.7, reusing<br>
Dec&nbsp; 5 18:22:20 lucidpixels last message repeated 3 times<br>
Dec&nbsp; 5 18:22:21 lucidpixels kernel: BLOCK: IN=eth1 OUT= MAC=00:a0:24:05:eb:87:00:c0:7b:b1:8d:3b:08:00
SRC=130.239.18.173 DST=66.45.37.187 LEN=1500 TOS=0x00 PREC=0x00 TTL=232 ID=48463
DF PROTO=ICMP TYPE=8 CODE=0 ID=0 SEQ=0 <br>
Dec&nbsp; 5 18:22:25 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;130.239.18.173, reusing<br>
Dec&nbsp; 5 18:22:34 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;130.239.18.137, reusing<br>
Dec&nbsp; 5 18:22:36 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;199.232.41.7, reusing<br>
Dec&nbsp; 5 18:22:42 lucidpixels kernel: ip_conntrack: max number of expected
connections 1 of ftp reached for 192.168.168.12-&gt;143.239.1.60, reusing<br>
Dec&nbsp; 5 18:22:43 lucidpixels kernel: BLOCK: IN=eth1 OUT= MAC=00:a0:24:05:eb:87:00:c0:7b:b1:8d:3b:08:00
SRC=130.239.18.173 DST=66.45.37.187 LEN=1500 TOS=0x00 PREC=0x00 TTL=232 ID=63220
DF PROTO=ICMP TYPE=8 CODE=0 ID=0 SEQ=2 <br>
<br>
Harald Welte wrote:<br>
<blockquote type="cite"
 cite="mid20021205200756.GB11068@naboo.club.berlin.ccc.de">
  <blockquote type="cite">
    <pre wrap="">Nov 29 03:29:26 lucidpixels kernel: ip_conntrack: max number of expected 
connections 1 of ftp reached for 192.168.xxx.xxx-&gt;129.128.5.191, reusing
Nov 29 03:29:30 lucidpixels kernel: ip_conntrack: max number of expected 
connections 1 of ftp reached for 192.168.xxx.xxx-&gt;129.132.7.170, reusing
Nov 29 03:29:36 lucidpixels kernel: ip_conntrack: max number of expected 
connections 1 of ftp reached for 192.168.xxx.xxx-&gt;195.113.31.123, reusing

These fill up my logs (kern.info) which I use for logging iptables 
blocked packets.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
the issue is that somebody is doing something very strange to your ftp
server.  Inside an FTP session, there's always only one expectation,
since there is only one unestablished data session per control session
at any given point in time.

  </pre>
  <blockquote type="cite">
    <pre wrap="">Is there anyway to turn this feature off dynamically or should one just 
comment out line #970 in 
/usr/src/linux/net/ipv4/netfilter/ip_conntrack_core.c ?
    </pre>
  </blockquote>
  <pre wrap=""><!---->
feel free to remove the comment.  but in normal ftp protocol behaviour,
the lines above should never be printed.

  </pre>
</blockquote>
<br>
</body>
</html>
