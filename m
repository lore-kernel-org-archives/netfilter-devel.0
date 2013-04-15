From: Lawrence Lee <lawrenceqli@gmail.com>
Subject: If the SYN packets return with NS_STOLEN, TCP cannot successfully
 establish the connection
Date: Mon, 15 Apr 2013 19:11:11 +0200
Message-ID: <CAGXkBO9t1rn7Y+pR6mYmY6C2RDJnQ6q3DsXOrm7Nt4M+dtn7Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:59879 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603Ab3DORLM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:11:12 -0400
Received: by mail-ia0-f170.google.com with SMTP id j38so4564619iad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2013 10:11:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

In NF_IP_LOCAL_OUT, I hooked the TCP SYN packets and directly sent out
by dev_queue_xmit, and return with NS_STOLEN. The packets can be
successfully sent out, and the peer replies with SYN+ACK.
Unfortunately, the local host does not accept the packet but replies
with ICMP error information, i.e., destination unreachable (host
administratively prohibited.

Actually, it is the same case if UDP request packets are hooked in the
NF_IP_LCOAL_OUT hook and are return with NS_STOLEN. The UDP response
packets will be dropped with an ICMP error packet.

I think the skb will not be freed with NS_STOLEN. I analyze the
traffic and observe that all address and port information of the
response packets match what in the request packets. I do not know why
the response packets cannot match the sock records. I am not sure if I
misunderstand something. May I know how to fix this issue? Thank you
very much!

Best Regards,
Lawrence
