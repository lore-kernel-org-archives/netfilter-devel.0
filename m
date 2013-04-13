From: Lawrence Lee <lawrenceqli@gmail.com>
Subject: TCP packets sent by dev_queue_xmit cannot successfully establish the connection
Date: Sat, 13 Apr 2013 16:13:47 +0200
Message-ID: <CAGXkBO8o4bTjoLJEraj0BsxULGFWDxWpEjtamPVyGSZgH-QqHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:41624 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3DMONs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:13:48 -0400
Received: by mail-ia0-f172.google.com with SMTP id k38so3207500iah.31
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2013 07:13:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In NF_IP_LOCAL_OUT, I hooked the TCP SYN packets and directly sent out
by dev_queue_xmit. The packets can be successfully sent out, and the
peer replies with SYN+ACK. Unfortunately, the local host does not
accept the packet but replies with ICMP error information, i.e.,
destination unreachable (host administratively prohibited. May I know
how to fix this issue? Thanks.

Best Regards,
Qi
