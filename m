From: Natty McButterpants <ipv6natlover@yahoo.com>
Subject: NAT for IPv6 Update
Date: Fri, 21 May 2004 15:44:19 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040521224419.25928.qmail@web90007.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1468037630-1085179459=:23934"
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

--0-1468037630-1085179459=:23934
Content-Type: text/plain; charset=us-ascii

Just an update, we have UDP getting NAT'ed properly, and hope to have TCP done by the weekend.  We may also setup TFTP before releasing the code, not sure yet.  Expect a posting of the code sometime within the next week.  If you are specifically interested in getting the code, email us.  Our primary difficulty has been the way to re-calculate the checksum using the in6_addr struct instead of the old 32int, but we got it figured out.  Man is this going to upset the IETF or what? :)  

		
---------------------------------
Do you Yahoo!?
Yahoo! Domains - Claim yours for only $14.70/year
--0-1468037630-1085179459=:23934
Content-Type: text/html; charset=us-ascii

<DIV>Just an update, we have UDP getting NAT'ed properly, and hope to have TCP done by the weekend.&nbsp; We may also setup TFTP before releasing the code, not sure yet.&nbsp; Expect a posting of the code sometime within the next week.&nbsp; If you are specifically interested in getting the code, email us.&nbsp; Our primary&nbsp;difficulty has been the way to re-calculate the checksum using the in6_addr struct instead of the old 32int, but we got it figured out.&nbsp; Man is this going to upset the IETF or what? :)&nbsp; </DIV><p>
		<hr size=1><font face=arial size=-1>Do you Yahoo!?<br>Yahoo! Domains - <a href="http://us.rd.yahoo.com/evt=23613/*http://smallbusiness.promotions.yahoo.com/offer">Claim yours for only $14.70/year</a>
--0-1468037630-1085179459=:23934--
