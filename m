From: Natty McButterpants <ipv6natlover@yahoo.com>
Subject: NAT for IPv6 FINISHED!!!!!
Date: Mon, 24 May 2004 14:19:02 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040524211902.69395.qmail@web90004.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-271857283-1085433542=:67125"
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

--0-271857283-1085433542=:67125
Content-Type: text/plain; charset=us-ascii

Gentlemen,
     We have finished the NAT development for IPv6.  It properly translates ICMPv6, UDP, and TCP packets.  We still need to clean up the code, perform a few more tests and what not.  We used ping6, traceroute6, and rlogin along with Ethereal and staring at a lot of tcpdump hex output in order to test the NAT.  We have not yet ported over support for application level stuff like TFTP, FTP, etc, but it does not appear to be too difficult and we may get that out at some point.  Additionally, we need to compile in DNAT support into the ip6tables user-space tool, as right now SNAT is all that is compiled in.  The code is rough, but it works, and as soon as we get it annotated and cleaned up into a tarball, we'll send it out to whomever wants it.  
 
In response to Jozsef Kadlecsik's question:
>     I hope this work is based on Yasuyuki Kozakai's nf_conntrack
>generalization...
>
>Best regards,
>Jozsef

     Yes, we used USAGI's 2.6.5 kernel with their included connection tracking suite to develop and test our NAT.  We only had to make a few minor modifications.
 
 
 

		
---------------------------------
Do you Yahoo!?
Friends.  Fun. Try the all-new Yahoo! Messenger
--0-271857283-1085433542=:67125
Content-Type: text/html; charset=us-ascii

<DIV>Gentlemen,</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp; We have finished the NAT development for IPv6.&nbsp; It properly translates ICMPv6, UDP, and TCP packets.&nbsp; We still need to clean up the code, perform a few more tests and what not.&nbsp; We used ping6, traceroute6, and rlogin along with Ethereal and staring at a lot of tcpdump hex output in order to test the NAT.&nbsp; We have not yet ported over support for application level stuff like TFTP, FTP, etc, but it does not appear to be too difficult and we may get that out at some point.&nbsp; Additionally, we need to compile in DNAT support into the ip6tables user-space tool, as right now SNAT is all that is compiled in.&nbsp; The code is rough, but it works, and as soon as we get it annotated and cleaned up into a tarball, we'll send it out to whomever wants it.&nbsp; </DIV>
<DIV>&nbsp;</DIV>
<DIV>In response to Jozsef Kadlecsik's question:</DIV>
<DIV>&gt;&nbsp;&nbsp;&nbsp;&nbsp; I hope this work is based on Yasuyuki Kozakai's nf_conntrack<BR>&gt;generalization...<BR>&gt;<BR>&gt;Best regards,<BR>&gt;Jozsef<BR></DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp; Yes, we used USAGI's 2.6.5 kernel with their included connection tracking suite to develop and test our NAT.&nbsp; We only had to make a few minor modifications.</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV><p>
		<hr size=1><font face=arial size=-1>Do you Yahoo!?<br>Friends.  Fun. <a href="http://messenger.yahoo.com/">Try the all-new Yahoo! Messenger</a>
--0-271857283-1085433542=:67125--
