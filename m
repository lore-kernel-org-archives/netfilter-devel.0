From: =?iso-8859-1?q?graham=20g?= <grinna369@yahoo.com.au>
Subject: Re: COPS Backend
Date: Mon, 5 May 2003 00:23:30 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030504142330.29152.qmail@web13305.mail.yahoo.com>
References: <20030427123509.GU990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-852154147-1052058210=:25575"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20030427123509.GU990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-852154147-1052058210=:25575
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit


Not directly related to iptables/netfilter as such, but I am currently working on an implementation of the COPS and COPS-PR protocol stack in Java. The idea is that you can use a Policy Based Management tool to define global network security policies. These policies are then distributed to various firewall devices with COPS-PR, where the policies are enforced. Of course, the system could also ship out policies to other network devices, such as COPS enabled routers, IPsec gateways etc.Im working with Linux boxes at the moment and am working on a very simple proto-type that simply calls the iptables user space tool to add / delete firewall rules when policies are shipped to the device. Anyway suggestions, comments or ideas from anyone would be much appreciated . Development is still in the extreme early stages.  
Harald Welte <laforge@netfilter.org> wrote:On Wed, Apr 16, 2003 at 11:55:39AM +1000, graham g wrote:
> 
> Hello
> Has anyone looked into developing a COPS interface for iptables as a
> means of remote configuration of multiple distributed firewalls ? 

not that the netfilter core team is aware of. 

If you are planning to implement something into this direction, please
feel free to discuss it on this mailinglist.

-- 
- Harald Welte http://www.netfilter.org/
============================================================================
"Fragmentation is like classful addressing -- an interesting early
architectural error that shows how much experimentation was going
on while IP was being designed." -- Paul Vixie
> ATTACHMENT part 2 application/pgp-signature 


---------------------------------
Yahoo! Mobile
- Check & compose your email via SMS on your Telstra or Vodafone mobile.
--0-852154147-1052058210=:25575
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

<DIV><BR>Not directly related to iptables/netfilter as such, but I am currently working on an implementation of the COPS and COPS-PR protocol stack in Java. The idea is that you can use a Policy Based Management tool to define global network security policies. These policies are then distributed to various firewall devices with COPS-PR, where the policies are enforced. Of course, the system could also ship out policies to other network devices, such as COPS enabled routers, IPsec gateways etc.Im working with Linux boxes at the moment and am working on a very simple proto-type that simply calls the iptables user space tool to add / delete firewall rules when policies are shipped to the device. Anyway suggestions, comments&nbsp;or ideas from anyone would be much appreciated . Development is still in the extreme early stages.</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV><BR><B><I>Harald Welte &lt;laforge@netfilter.org&gt;</I></B> wrote:</DIV>
<BLOCKQUOTE style="PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #1010ff 2px solid">On Wed, Apr 16, 2003 at 11:55:39AM +1000, graham g wrote:<BR>&gt; <BR>&gt; Hello<BR>&gt; Has anyone looked into developing a COPS interface for iptables as a<BR>&gt; means of remote configuration of multiple distributed firewalls ? <BR><BR>not that the netfilter core team is aware of. <BR><BR>If you are planning to implement something into this direction, please<BR>feel free to discuss it on this mailinglist.<BR><BR>-- <BR>- Harald Welte <LAFORGE@NETFILTER.ORG>http://www.netfilter.org/<BR>============================================================================<BR>"Fragmentation is like classful addressing -- an interesting early<BR>architectural error that shows how much experimentation was going<BR>on while IP was being designed." -- Paul Vixie<BR>&gt; ATTACHMENT part 2 application/pgp-signature </BLOCKQUOTE><p><br><hr size=1>
<a href="http://au.rd.yahoo.com/mail/tagline/?http://au.mobile.yahoo.com/sms/mail/index.html" target=_blank><b>Yahoo! Mobile</b></a><br>
- Check & compose your email via SMS on your Telstra or Vodafone mobile.
--0-852154147-1052058210=:25575--
