From: "Kumar Shobhit (IFIN DC COM)" <Shobhit.Kumar@infineon.com>
Subject: blocking/allowing particular protocol
Date: Wed, 17 Mar 2004 15:50:31 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C40C09.79C35560"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
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

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C40C09.79C35560
Content-Type: text/plain

Hi,
I am pretty new to all this stuff. I want to know if it is possible to
block/allow a particular 
protocol. For example, HTTP can work on various ports, So instead of
blocking/allowing a particular port
can I allow/block HTTP itself i.e to allow HTTP traffic on any port. 
If yes, then please let me know the way to do it. I may have missed
something in the iptables tutorial
so any pointers will be a great help.
Another question which I couldn't find an answer to is, when in the
conntrack/NAT code is the ip_nat_info 
structure initialized
 
Thanking you with Best Regards
Shobhit

------------------------------------------------- 
Shobhit Kumar         | www.infineon.com 
Infineon Technologies | shobhit.kumar@infineon.com 
Bangalore, India      | phone: 91-80-51392365
-------------------------------------------------  

I find that the harder I work, the more luck I seem to have

*Disclaimer*
"This e-mail and any attachments are confidential and may contain trade
secrets or privileged or undisclosed information. They may also be subject
to copyright protection. Please do not copy, distribute or forward this
email to anyone unless authorised. If you are not a named addressee, you
must not use, disclose, retain or reproduce all or any part of the
information contained in this e-mail or any attachments. If you have
received this email by mistake please notify the sender immediately by
return email and destroy/delete all copies of the email." 

 

------_=_NextPart_001_01C40C09.79C35560
Content-Type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii">
<TITLE>Message</TITLE>

<META content="MSHTML 6.00.2800.1264" name=GENERATOR></HEAD>
<BODY>
<DIV><SPAN class=321462010-17032004><FONT face=Arial 
size=2>Hi,</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>I am pretty new to 
all this stuff. I want to know if it is possible to block/allow a particular 
</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>protocol. For 
example, HTTP can work on various ports, So instead of blocking/allowing a 
particular port</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>can I allow/block 
HTTP itself i.e to allow HTTP traffic on any port. </FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>If yes, then please 
let me know the way to do it. I may have missed something in the iptables 
tutorial</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>so any pointers will 
be a great help.</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>Another question 
which I couldn't find an answer to&nbsp;is, when in the conntrack/NAT code is 
the <STRONG>ip_nat_info </STRONG></FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>structure 
initialized</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial 
size=2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial size=2>Thanking you with 
Best Regards</FONT></SPAN></DIV>
<DIV><SPAN class=321462010-17032004><FONT face=Arial 
size=2>Shobhit</FONT></SPAN></DIV>
<DIV align=left>
<DIV class=Section1>
<P align=left><SPAN 
style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">-------------------------------------------------</SPAN> 
<BR><SPAN style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Shobhit 
Kumar&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | www.infineon.com</SPAN> 
<BR><SPAN style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Infineon 
Technologies | shobhit.kumar@infineon.com</SPAN> <BR><?xml:namespace prefix = 
st1 ns = "urn:schemas-microsoft-com:office:smarttags" 
/><st1:place><st1:City><SPAN 
style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">Bangalore</SPAN></st1:City><SPAN 
style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">, 
</SPAN><st1:country-region><SPAN 
style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">India</SPAN></st1:country-region></st1:place><SPAN 
style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
| phone: 91-80-51392365</SPAN><BR><SPAN 
style="FONT-SIZE: 10pt; FONT-FAMILY: 'Courier New'">-------------------------------------------------</SPAN>&nbsp;<?xml:namespace 
prefix = o ns = "urn:schemas-microsoft-com:office:office" 
/><o:p>&nbsp;</o:p></P>
<P align=center><SPAN style="FONT-SIZE: 13.5pt; COLOR: navy">I find that the 
harder I work, the more luck I seem to have</SPAN></P><SPAN 
style="FONT-SIZE: 7.5pt; FONT-FAMILY: 'Courier New'"><B>
<P><FONT color=#0000ff>*Disclaimer*<BR>"This e-mail and any attachments are 
confidential and may contain trade secrets or privileged or undisclosed 
information. They may also be subject to copyright protection. Please do not 
copy, distribute or forward this email to anyone unless authorised. If you are 
not a named addressee, you must not use, disclose, retain or reproduce all or 
any part of the information contained in this e-mail or any attachments. If you 
have received this email by mistake please notify the sender immediately by 
return email and destroy/delete all copies of the email."</FONT> 
</P></B></SPAN></DIV></DIV>
<DIV>&nbsp;</DIV></BODY></HTML>

------_=_NextPart_001_01C40C09.79C35560--
