From: BlackCat <blackcatzilla@gmail.com>
Subject: Capture packets without route
Date: Sun, 5 Apr 2009 20:34:23 +0400
Message-ID: <1033002276.20090405203423@gmail.com>
Reply-To: BlackCat <blackcatzilla@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:19355 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZDEQed (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:34:33 -0400
Received: by fg-out-1718.google.com with SMTP id 16so138407fgg.17
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Apr 2009 09:34:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I try to write an implementation of one of the on-demand routing protocol (AODV)
and have small trouble. When packet arrive from the network they normaly
appear in PRE_ROUTING hook without any route testing. But host
packets comming from transport level are have route testing before
LOCAL_OUT hook in the ip_queue_xmit() function. And packets without
appropriate route are dropped before reach the hook.

To solve this problem I use fake default route via TAP interface. My
question is does any other solution exists?

-- 
Best regards,
 BlackCat

