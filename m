From: Amit Kumar <amitkumargupta_wip@yahoo.com>
Subject: Re: Reg Connection Tracking
Date: Sun, 19 Jan 2003 21:55:31 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030120055531.62252.qmail@web41505.mail.yahoo.com>
References: <1042791460.1694.38.camel@knoppix>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-417593001-1043042131=:61861"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
In-Reply-To: <1042791460.1694.38.camel@knoppix>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-417593001-1043042131=:61861
Content-Type: text/plain; charset=us-ascii


HI List,
Thanks for ur suggestions List.
Well, Now Again I tested the firewall and this time without NAT.
So it means that connection tracking is used only for the iptables cases. Even in that case i have the same problem. My first setup has worked flawlessly and only second one has problems. Another thing is I am using standard PING utility.
Now can anybody give suggestions why connection tracking is not working properly.
I have gone through the connection tracking code also and enabled the kernel debug messages. I saw that as soon as i ping or do some http connection(I am doing this only not tried others as i feel i will get same problem with other services), it keep printing, creating conntrack but it never destroys. 
Any suggestions, now?
Thanks & Regards,
Amit Kumar Gupta.
 
 Ranjeet Shetye <ranjeet.shetye2@zultys.com> wrote:
Hi,

If you've written your own NAT, then I guess my answers can only be
generic at best, cos I dont know the details of your NAT implementation
e.g. what part of the ICMP packet is used to uniquely identify a flow of
ICMP packets, how do you do conn-tracking for the NAT, etc. Sorry about
that.

I'll think about this and come up with some more Q/A if I can.

Is your ping utility a standard issue ping from the linux/gnu/bsd suite
or is that also something you guys have written on your own ?

Did your first test setup work flawlessly ? and only the second one has
problems ? or did they both have problems ?

take care,
Ranjeet.

On Fri, 2003-01-17 at 10:40, Amit Kumar wrote:
> 
> Hi,
> Well First thing is I am not using LOCAL NAT. I am using NAT for the external outgoing traffic from inhome and RG uses that to convert to valid IP address. Another thing is I am not using NAT available with LINUX. We have wriiten our own NAT, which we have already tested.
> Answer to 2nd que is :- I don't know whether ping packet is properly created. 
> I also think that ping packet is not getting created properly but i am not sure. I am not using static routing. Well in certain conditions we can switch on the asymmetric routing, but we are not hitting those conditions now.
> We have already tested however this stuff on one test setup and this is the second one on which the differences are :-
> (1) Different vedor board which i think will not have any effect.
> (2) Different Linux Source version. Previously we tested with 2.4.2 and 2.4.5 sources and here it's 2.4.3
> (3) CONFIG_SYSCTL is disabled.
> But i think the above 3 changes should not effect it.
> Regards,
> Amit
> 
> Ranjeet Shetye wrote:
> Things to verify:
> 1. Do you have local NAT on i.e. NAT for traffic from the machine itself
> ?
> 2. Is your ping packet being created in the proper manner ?
> 
> Sounds like your request packets and reply packets are being seen by the
> netfilter on two different interface. or the ping packet contents that
> are used by conntrack are not being created correctly. e.g type, id and
> code. If any of those are messed up, your conntrack will start going
> beserk cos the replies cannot be matched back to the original traffic. 
> 
> Look at the CONFIG_IP_NF_LOCAL_NAT option and your routing tables. Do
> you have any static routes or other conditions that can asymmetric
> routing ?
> 
> Ranjeet.
> 
> 
> 
> 
> 
> ---------------------------------
> Do you Yahoo!?
> Yahoo! Mail Plus - Powerful. Affordable. Sign up now





---------------------------------
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now
--0-417593001-1043042131=:61861
Content-Type: text/html; charset=us-ascii

<P>HI List,
<P>Thanks for ur suggestions List.
<P>Well, Now Again I tested the firewall and this time without NAT.
<P>So it means that connection tracking is used only for the iptables cases. Even in that case i have the same problem. My first setup has worked flawlessly and only second one has problems. Another thing is I am using standard PING utility.
<P>Now can anybody give suggestions why connection tracking is not working properly.
<P>I have gone through the connection tracking code also and enabled the kernel debug messages. I saw that as soon as i ping or do some http connection(I am doing this only not tried others as i feel i will get same problem with other services), it keep printing, creating conntrack but it never destroys. 
<P>Any suggestions, now?
<P>Thanks &amp; Regards,
<P>Amit Kumar Gupta.
<P>&nbsp;
<P>&nbsp;<B><I>Ranjeet Shetye &lt;ranjeet.shetye2@zultys.com&gt;</I></B> wrote:
<BLOCKQUOTE style="PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #1010ff 2px solid"><BR>Hi,<BR><BR>If you've written your own NAT, then I guess my answers can only be<BR>generic at best, cos I dont know the details of your NAT implementation<BR>e.g. what part of the ICMP packet is used to uniquely identify a flow of<BR>ICMP packets, how do you do conn-tracking for the NAT, etc. Sorry about<BR>that.<BR><BR>I'll think about this and come up with some more Q/A if I can.<BR><BR>Is your ping utility a standard issue ping from the linux/gnu/bsd suite<BR>or is that also something you guys have written on your own ?<BR><BR>Did your first test setup work flawlessly ? and only the second one has<BR>problems ? or did they both have problems ?<BR><BR>take care,<BR>Ranjeet.<BR><BR>On Fri, 2003-01-17 at 10:40, Amit Kumar wrote:<BR>&gt; <BR>&gt; Hi,<BR>&gt; Well First thing is I am not using LOCAL NAT. I am using NAT for the external outgoing traffic from inhome and RG uses that to conv
 ert to valid IP address. Another thing is I am not using NAT available with LINUX. We have wriiten our own NAT, which we have already tested.<BR>&gt; Answer to 2nd que is :- I don't know whether ping packet is properly created. <BR>&gt; I also think that ping packet is not getting created properly but i am not sure. I am not using static routing. Well in certain conditions we can switch on the asymmetric routing, but we are not hitting those conditions now.<BR>&gt; We have already tested however this stuff on one test setup and this is the second one on which the differences are :-<BR>&gt; (1) Different vedor board which i think will not have any effect.<BR>&gt; (2) Different Linux Source version. Previously we tested with 2.4.2 and 2.4.5 sources and here it's 2.4.3<BR>&gt; (3) CONFIG_SYSCTL is disabled.<BR>&gt; But i think the above 3 changes should not effect it.<BR>&gt; Regards,<BR>&gt; Amit<BR>&gt; <BR>&gt; Ranjeet Shetye <RANJEET.SHETYE2@ZULTYS.COM>wrote:<BR>&gt; Thing
 s to verify:<BR>&gt; 1. Do you have local NAT on i.e. NAT for traffic from the machine itself<BR>&gt; ?<BR>&gt; 2. Is your ping packet being created in the proper manner ?<BR>&gt; <BR>&gt; Sounds like your request packets and reply packets are being seen by the<BR>&gt; netfilter on two different interface. or the ping packet contents that<BR>&gt; are used by conntrack are not being created correctly. e.g type, id and<BR>&gt; code. If any of those are messed up, your conntrack will start going<BR>&gt; beserk cos the replies cannot be matched back to the original traffic. <BR>&gt; <BR>&gt; Look at the CONFIG_IP_NF_LOCAL_NAT option and your routing tables. Do<BR>&gt; you have any static routes or other conditions that can asymmetric<BR>&gt; routing ?<BR>&gt; <BR>&gt; Ranjeet.<BR>&gt; <BR>&gt; <BR>&gt; <BR>&gt; <BR>&gt; <BR>&gt; ---------------------------------<BR>&gt; Do you Yahoo!?<BR>&gt; Yahoo! Mail Plus - Powerful. Affordable. Sign up now<BR><BR><BR></BLOCKQUOTE><p><br><h
 r size=1>Do you Yahoo!?<br>
<a href="http://rd.yahoo.com/mail/mailsig/*http://mailplus.yahoo.com">Yahoo! Mail Plus</a> - Powerful. Affordable. <a href="http://rd.yahoo.com/mail/mailsig/*http://mailplus.yahoo.com">Sign up now</a>
--0-417593001-1043042131=:61861--
