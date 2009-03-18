From: "Damian Lezama" <damian.lezama@gmail.com>
Subject: Problem changing source IP in user space with NFQUEUE
Date: Wed, 18 Mar 2009 07:56:07 -0700
Message-ID: <49c10b8f.25bc720a.2d7c.4677@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:37917 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZCRO4R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:56:17 -0400
Received: by rv-out-0506.google.com with SMTP id f9so40624rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2009 07:56:15 -0700 (PDT)
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

	I need to change the Source IP of incoming packets in PRE for a
tunnel end (packets to the host or to route to other hosts). If I do it in
PRE the packet just disappears even if my verdict is ACCEPT or REPEAT (it
also disappears if I change the protocol). I tried to use a workaround but
If I change the source IP in INPUT the application sees the old one so I'm
still in trouble. How can I solve this?

Regards,
Damian


