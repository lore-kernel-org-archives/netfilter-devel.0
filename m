From: Raja Reddy <reddyrajareddy@yahoo.com>
Subject: NetFilter NF_IP_FORWARD Hook
Date: Wed, 2 Apr 2003 03:57:17 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030402115717.90435.qmail@web13808.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1608271391-1049284637=:89090"
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

--0-1608271391-1049284637=:89090
Content-Type: text/plain; charset=us-ascii


Hello,

  I am developing a NetFilter Module.  I have 2 (eth0,eth1) interfaces.I hooked at NF_IP_FORWARD. 

I changed destination address of the Packet (skb->nh.iph->saddr).

After that i am getting problems. My Questions are..

1. How to calculate skb->csum checksum.

2. How to calculate skb->h.th->check TCP Checksum.

I gone throught the Netfilter source tree. But saw few  lines of source. I got checksum errors when i applied. 

Please help me to solve this problem.

Thanks in Advance,


Keep Faith on the Supreme Lord Sri Sri Sri Krishna. He will take care of you.


---------------------------------
Do you Yahoo!?
Yahoo! Tax Center - File online, calculators, forms, and more
--0-1608271391-1049284637=:89090
Content-Type: text/html; charset=us-ascii

<P>Hello,</P>
<P>&nbsp; I am developing a NetFilter Module.&nbsp; I have 2 (eth0,eth1) interfaces.I hooked at NF_IP_FORWARD. </P>
<P>I changed destination address of the Packet (skb-&gt;nh.iph-&gt;saddr).</P>
<P>After that i am getting problems. My Questions are..</P>
<P>1. How to calculate skb-&gt;csum checksum.</P>
<P>2. How to calculate skb-&gt;h.th-&gt;check TCP Checksum.</P>
<P>I gone throught the Netfilter source tree. But saw few&nbsp; lines of source. I got checksum errors when i applied. </P>
<P>Please help me to solve this problem.</P>
<P>Thanks in Advance,</P><BR><BR>Keep Faith on the Supreme Lord Sri Sri Sri Krishna. He will take care of you.<p><br><hr size=1>Do you Yahoo!?<br>
<a href="http://us.rd.yahoo.com/finance/mailsig/*http://tax.yahoo.com">Yahoo! Tax Center</a> - File online, calculators, forms, and more
--0-1608271391-1049284637=:89090--
