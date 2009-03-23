From: Kunsheng Chen <kunsheng.chen@yahoo.com>
Subject: About conversion between iphdr->saddr and String-format IP Address
Date: Mon, 23 Mar 2009 14:10:45 -0700 (PDT)
Message-ID: <776021.17555.qm@web43411.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48]:35686 "HELO
	n76.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753697AbZCWVNi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:13:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello everyone,

I am looking for some functions to convert ip address in string format into=
 unsigned int and versa vice.

Does it have some function like 'inet_addr' inside kernel for that?=A0 Basi=
cally what I want to do is conver iphdr->s_addr into a String type, which w=
ould give me a readable ip address for debugging.


Any idea is well appreciated,


Thanks,


+Kunsheng



      

