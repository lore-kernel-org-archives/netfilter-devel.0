From: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Subject: Implementation of Ebtables target similar to QUEUE
Date: Fri, 28 Sep 2007 21:51:53 +0100 (BST)
Message-ID: <550322.55522.qm@web7903.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web7903.mail.in.yahoo.com ([202.86.4.79]:40272 "HELO
	web7903.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751534AbXI1U6h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:58:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi there,

I have questions regarding the extension of ebtables
code to support target similar to QUEUE target. In my
project, I have a requirement of intercepting packets
inside ebtables and pass some information related to
packet to userspace tool. Ebtables code should wait to
receive reply from userspace tool and then drop or
accept packet. Since, ebtables code run in the context
of interrupt's bottom half, I cannot wait inside that
code path.

To avoid that problem, I would like to create queues
inside ebtables so that I could put that packet into
the queue and start processing the next packet. I can
have other design where I send packets to userspace
and let userspace tool handle the packets. But, I do
not want to cross the user-kernel boundary for each
packet.

I need help in order to achieve my first design:

1) Is my requirement very complex? Can it be achieved
easily?

2) What are the parts of ebtables code i should
change?

3) In case, userspace tool says accept the packet. How
I would implement the fucntionality of getting old
packets from queue and send them out of the network or
for incoming packets send to higher level protocols?

4) Is there any effective way for creating queues
inside ebtables?

I would really appreciate any help or suggestions in
this regard?

Thanks,
Abhinav



      5, 50, 500, 5000 - Store N number of mails in your inbox. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
