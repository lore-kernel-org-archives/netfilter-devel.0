From: "Giant Sand Fan's" <rampxxxx@gmail.com>
Subject: ip_route_me_harder question
Date: Wed, 7 Jan 2009 18:19:49 +0100
Message-ID: <417f50830901070919u7c90ac16x5771bece809568e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:3897 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZAGRTv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:19:51 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3054292fgg.17
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jan 2009 09:19:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have a netfilter module that needs to reroute a packet after
unpacking it (minimal encap) in NF_IP_PRE_ROUTING, because the dst
changes. But even when a ip_route_me_harder with RTN_LOCAL works
(ret==0) the packet disappears.

The question is , do i need to use ip_route_me_harder? because when
the dst of encapsulated packet is the local machine it works.

thanks.

-- 
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
