From: =?iso-8859-1?q?Daryl=20ong?= <yjong1977extramail@yahoo.com.sg>
Subject: Help in netfilter kernel module
Date: Thu, 16 Oct 2003 10:55:27 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031016025527.23285.qmail@web13108.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1335691291-1066272927=:22511"
Content-Transfer-Encoding: 8bit
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

--0-1335691291-1066272927=:22511
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

Hi
   i am a new developer in this netfilter module.  i am developing a kernel module on a rehat linux 8 and using iptables v1.2.6a.  i came across a problem when i want to kfree_skb(skb).  When i compile my source code with this command: gcc -march=i486 -03 -D__KERNEL__ -DLINUX -DMODULE -DMODVERSIONS -I/lib/modules/linux/build/linclude -c test.c test.o, it compiles with no error.  But when i try to insmod test.o.  it prompts me an error with test.o: unresolved symbol __kfree_skb.  
 
i have try to use NF_DROP to drop the packet if it doesnt match what i want to filter away.  But as netfilter currently didnt filter for PF_PACKET, my packet is able to go up to application layer.  So i intended to use kfree_skb but encounter the error.  Please tell me if there is any solutions.  Thank you.
 
Regards,
Daryl

 Yahoo! Photos
- A free party for the most "shiok" photo. Join now!
--0-1335691291-1066272927=:22511
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

<DIV>Hi</DIV>
<DIV>&nbsp;&nbsp; i am a new developer in this netfilter module.&nbsp; i am developing a kernel module&nbsp;on a&nbsp;rehat linux 8 and using iptables v1.2.6a.&nbsp; i came across a problem when i want to kfree_skb(skb).&nbsp; When i compile my source code with this command: gcc -march=i486 -03 -D__KERNEL__ -DLINUX -DMODULE -DMODVERSIONS -I/lib/modules/linux/build/linclude -c test.c test.o, it compiles with no error.&nbsp; But when i try to insmod test.o.&nbsp; it prompts me an error with test.o: unresolved symbol __kfree_skb.&nbsp; </DIV>
<DIV>&nbsp;</DIV>
<DIV>i have try to use NF_DROP to drop the packet if it doesnt match what i want to filter away.&nbsp; But as netfilter currently didnt filter for PF_PACKET, my packet is able to go up to application layer.&nbsp; So i intended to use kfree_skb but encounter the error.&nbsp; Please tell me if there is any solutions.&nbsp; Thank you.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Regards,</DIV>
<DIV>Daryl</DIV><p><img src=http://sg.yimg.com/i/sg/icons/16/photos.gif>&nbsp;<b><a 
href="http://sg.rd.yahoo.com/mail/tagline/?http://sg.photos.yahoo.com" 
target=_blank>Yahoo! Photos</a></b><br><small>- A free party for the most "shiok" photo. <a href="http://sg.rd.yahoo.com/mail/tagline/?http://sg.yahoo.com/shiok" target=_blank><b>Join now!</b></a></small>
--0-1335691291-1066272927=:22511--
