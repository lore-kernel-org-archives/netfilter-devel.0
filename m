From: Mahdi Samadi <my_seclab@yahoo.com>
Subject: Why "Connection tracking" decreases performance of netfilter!? any idea ?
Date: Tue, 22 Apr 2003 07:34:55 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030422143455.19432.qmail@web80506.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1325421988-1051022095=:18876"
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

--0-1325421988-1051022095=:18876
Content-Type: text/plain; charset=us-ascii

Hello to allDose any know why connection tracking decreases the performance of Linux?Is it any way to have both of them? (connection tracking and performance)I alse check this situation by changing the value of "ip_conntrack_max" to high, but performance is still very bad,Is there a configuration for kernel to solve this problem? I checked the performance by netperf,  when i have no connection-tracking result is as below:  (Throughtput is 94 M/s and number of connect/request/response is  2793/sec)-------- No conntrack ------------client <-cross cable-> Linux <-cross cable-> server :
./netperf -t TCP_STREAM -l 60 -H x.x.x.x

TCP STREAM TEST to x.x.x.x

Recv Send Send

Socket Socket Message Elapsed

Size Size Size Time Throughput

bytes bytes bytes secs. 10^6bits/sec



87380 16384 16384 60.01 94.12

----------------------------------------

./netperf -t TCP_CRR -l 120 -H x.x.x.x

TCP Connect/Request/Response TEST to x.x.x.x

Local /Remote

Socket Size Request Resp. Elapsed Trans.

Send Recv Size Size Time Rate

bytes Bytes bytes bytes secs. per sec



131070 131070 1 1 119.99 2793.74

16384 87380

--------------With Conntrack------------------

But when i enable Conntection tracking, performance is as below (Throughtput is 93 M/s and number of connect/request/response is  140/sec)

./netperf -t UDP_STREAM -l 60 -H x.x.x.x -- -m 1024

UDP UNIDIRECTIONAL SEND TEST to x.x.x.x

Socket Message Elapsed Messages

Size Size Time Okay Errors Throughput

bytes bytes secs # # 10^6bits/sec



65535 1024 60.00 687698 0 93.90

65535 60.00 686612 93.75

./netperf -t TCP_CRR -l 120 -H x.x.x.x

TCP Connect/Request/Response TEST to x.x.x.x

Local /Remote

Socket Size Request Resp. Elapsed Trans.

Send Recv Size Size Time Rate

bytes Bytes bytes bytes secs. per sec



131070 131070 1 1 119.99 140.56

16384 87380

------------------------------
Thanks,Be success--samadi 


---------------------------------
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
--0-1325421988-1051022095=:18876
Content-Type: text/html; charset=us-ascii

<DIV>Hello to all</DIV>
<DIV>Dose any know why connection tracking decreases the performance of Linux?</DIV>
<DIV>Is it any way to have both of them? (connection tracking and performance)</DIV>
<DIV>I alse&nbsp;check this situation by changing the value of&nbsp;"ip_conntrack_max" to high, but performance is still very bad,</DIV>
<DIV>Is there a configuration for kernel to solve this problem?</DIV>
<DIV>&nbsp;</DIV>
<DIV>I checked the performance by netperf,&nbsp; when i have no connection-tracking result is as below:&nbsp; (Throughtput is 94 M/s and&nbsp;number of connect/request/response is&nbsp; 2793/sec)</DIV>
<DIV><FONT face="Courier New" size=2>-------- No conntrack ------------</FONT></DIV>
<DIV><FONT face="Courier New" size=2>
<DIV><FONT face="Courier New" size=2>client &lt;-cross cable-&gt; Linux &lt;-cross cable-&gt; server :</DIV></FONT></DIV>
<DIV><FONT face="Courier New" size=2>
<P align=left>./netperf -t TCP_STREAM -l 60 -H x.x.x.x</P>
<P align=left>TCP STREAM TEST to x.x.x.x</P>
<P align=left>Recv Send Send</P>
<P align=left>Socket Socket Message Elapsed</P>
<P align=left>Size Size Size Time Throughput</P>
<P align=left>bytes bytes bytes secs. 10^6bits/sec</P>
<P align=left></P>
<P align=left>87380 16384 16384 60.01 94.12</P>
<P align=left>----------------------------------------</P><FONT face="Courier New" size=2>
<P align=left>./netperf -t TCP_CRR -l 120 -H x.x.x.x</P>
<P align=left>TCP Connect/Request/Response TEST to x.x.x.x</P>
<P align=left>Local /Remote</P>
<P align=left>Socket Size Request Resp. Elapsed Trans.</P>
<P align=left>Send Recv Size Size Time Rate</P>
<P align=left>bytes Bytes bytes bytes secs. per sec</P>
<P align=left></P>
<P align=left>131070 131070 1 1 119.99 2793.74</P>
<P align=left>16384 87380</P>
<P align=left>--------------With Conntrack------------------</P>
<P align=left>But when i enable Conntection tracking, performance is as below (Throughtput is 93 M/s and&nbsp;number of connect/request/response is&nbsp; 140/sec)</P><FONT face="Courier New" size=2>
<P align=left>./netperf -t UDP_STREAM -l 60 -H x.x.x.x -- -m 1024</P>
<P align=left>UDP UNIDIRECTIONAL SEND TEST to x.x.x.x</P>
<P align=left>Socket Message Elapsed Messages</P>
<P align=left>Size Size Time Okay Errors Throughput</P>
<P align=left>bytes bytes secs # # 10^6bits/sec</P>
<P align=left></P>
<P align=left>65535 1024 60.00 687698 0 93.90</P>
<P>65535 60.00 686612 93.75</P></FONT>
<P align=left></FONT></FONT>./netperf -t TCP_CRR -l 120 -H x.x.x.x</P>
<P align=left>TCP Connect/Request/Response TEST to x.x.x.x</P>
<P align=left>Local /Remote</P>
<P align=left>Socket Size Request Resp. Elapsed Trans.</P>
<P align=left>Send Recv Size Size Time Rate</P>
<P align=left>bytes Bytes bytes bytes secs. per sec</P>
<P align=left></P>
<P align=left>131070 131070 1 1 119.99 140.56</P>
<P align=left>16384 87380</P>
<P align=left>------------------------------</P></FONT></DIV>
<DIV>Thanks,</DIV>
<DIV>Be success</DIV>
<DIV>--samadi</DIV>
<DIV>&nbsp;</DIV><p><br><hr size=1>Do you Yahoo!?<br>
<a href="http://us.rd.yahoo.com/search/mailsig/*http://search.yahoo.com">The New Yahoo! Search</a> - Faster. Easier. Bingo.
--0-1325421988-1051022095=:18876--
