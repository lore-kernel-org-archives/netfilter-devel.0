From: Amit Kumar <amitkumargupta_wip@yahoo.com>
Subject: Re: Reg Connection Tracking
Date: Fri, 17 Jan 2003 01:40:29 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030117094029.77519.qmail@web41502.mail.yahoo.com>
References: <1042754086.1677.29.camel@knoppix>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1118288282-1042796429=:77129"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ranjeet Shetye <ranjeet.shetye2@zultys.com>,
  netfilter-devel@lists.netfilter.org
In-Reply-To: <1042754086.1677.29.camel@knoppix>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-1118288282-1042796429=:77129
Content-Type: text/plain; charset=us-ascii


Hi,
Well First thing is I am not using LOCAL NAT. I am using NAT for the external outgoing traffic from inhome and RG uses that to convert to valid IP address. Another thing is I am not using NAT available with LINUX. We have wriiten our own NAT, which we have already tested.
Answer to 2nd que is :- I don't know whether ping packet is properly created. 
I also think that ping packet is not getting created properly but i am not sure. I am not using static routing. Well in certain conditions we can switch on the asymmetric routing, but we are not hitting those conditions now.
We have already tested however this stuff on one test setup and this is the second one on which the differences are :-
(1) Different vedor board which i think will not have any effect.
(2) Different Linux Source version. Previously we tested with 2.4.2 and 2.4.5 sources and here it's 2.4.3
(3) CONFIG_SYSCTL is disabled.
But i think the above 3 changes should not effect it.
Regards,
Amit
 
 Ranjeet Shetye <ranjeet.shetye2@zultys.com> wrote:
Things to verify:
1. Do you have local NAT on i.e. NAT for traffic from the machine itself
?
2. Is your ping packet being created in the proper manner ?

Sounds like your request packets and reply packets are being seen by the
netfilter on two different interface. or the ping packet contents that
are used by conntrack are not being created correctly. e.g type, id and
code. If any of those are messed up, your conntrack will start going
beserk cos the replies cannot be matched back to the original traffic. 

Look at the CONFIG_IP_NF_LOCAL_NAT option and your routing tables. Do
you have any static routes or other conditions that can asymmetric
routing ?

Ranjeet.





---------------------------------
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now
--0-1118288282-1042796429=:77129
Content-Type: text/html; charset=us-ascii

<P>Hi,
<P>Well First thing is I am not using LOCAL NAT. I am using NAT for the external outgoing traffic from inhome and RG uses that to convert to valid IP address. Another thing is I am not using NAT available with LINUX. We have wriiten our own NAT, which we have already tested.
<P>Answer to 2nd que is :- I don't know whether ping packet is properly created. 
<P>I also think that ping packet is not getting created properly but i am not sure. I am not using static routing. Well in certain conditions we can switch on the asymmetric routing, but we are not hitting those conditions now.
<P>We have already tested however this stuff on one test setup and this is the second one on which the differences are :-
<P>(1) Different vedor board which i think will not have any effect.
<P>(2) Different Linux Source version. Previously we tested with 2.4.2 and 2.4.5 sources and here it's 2.4.3
<P>(3) CONFIG_SYSCTL is disabled.
<P>But i think the above 3 changes should not effect it.
<P>Regards,
<P>Amit
<P>&nbsp;
<P>&nbsp;<B><I>Ranjeet Shetye &lt;ranjeet.shetye2@zultys.com&gt;</I></B> wrote:
<BLOCKQUOTE style="PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #1010ff 2px solid"><BR>Things to verify:<BR>1. Do you have local NAT on i.e. NAT for traffic from the machine itself<BR>?<BR>2. Is your ping packet being created in the proper manner ?<BR><BR>Sounds like your request packets and reply packets are being seen by the<BR>netfilter on two different interface. or the ping packet contents that<BR>are used by conntrack are not being created correctly. e.g type, id and<BR>code. If any of those are messed up, your conntrack will start going<BR>beserk cos the replies cannot be matched back to the original traffic. <BR><BR>Look at the CONFIG_IP_NF_LOCAL_NAT option and your routing tables. Do<BR>you have any static routes or other conditions that can asymmetric<BR>routing ?<BR><BR>Ranjeet.<BR><BR><BR></BLOCKQUOTE><p><br><hr size=1>Do you Yahoo!?<br>
<a href="http://rd.yahoo.com/mail/mailsig/*http://mailplus.yahoo.com">Yahoo! Mail Plus</a> - Powerful. Affordable. <a href="http://rd.yahoo.com/mail/mailsig/*http://mailplus.yahoo.com">Sign up now</a>
--0-1118288282-1042796429=:77129--
