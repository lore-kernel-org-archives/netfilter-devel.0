From: linux lover <linux_lover2004@yahoo.com>
Subject: copying a packet in kernel
Date: Sun, 19 Sep 2004 01:43:13 -0700 (PDT)
Sender: kernelnewbies-bounce@nl.linux.org
Message-ID: <20040919084313.78039.qmail@web52202.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1380025443-1095583393=:76993"
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <kernelnewbies-bounce@nl.linux.org>
To: kernelnewbies <kernelnewbies@nl.linux.org>
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: netfilter-devel.vger.kernel.org

--0-1380025443-1095583393=:76993
Content-Type: text/plain; charset=us-ascii

Hello people,
 i want copy of constructed packet at ip_queue_xmit2() function. For that is there any 
other way than skb_clone(). Cause when i send clone copy to my kernel 
program next processing garbage packet.
Help.
Regards,
linux_lover.
 

		
---------------------------------
Do you Yahoo!?
vote.yahoo.com - Register online to vote today!
--0-1380025443-1095583393=:76993
Content-Type: text/html; charset=us-ascii

<DIV>Hello people,<BR> i want copy of constructed packet at ip_queue_xmit2() function. For that is there any </DIV>
<DIV>other way than skb_clone(). Cause when i send clone copy to my kernel </DIV>
<DIV>program next processing garbage packet.</DIV>
<DIV>Help.<BR>Regards,<BR>linux_lover.</DIV>
<DIV>&nbsp;</DIV><p>
		<hr size=1>Do you Yahoo!?<br><a
href="http://vote.yahoo.com">vote.yahoo.com</a> - Register online to vote today!
--0-1380025443-1095583393=:76993--

--
Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/
