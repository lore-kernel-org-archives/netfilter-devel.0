From: hoangtam <tamnghoang@gmail.com>
Subject: Netfilter data retransmit
Date: Thu, 20 Oct 2011 09:33:18 +0200
Message-ID: <4E9FCEBE.5000404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45473 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1JTHdU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Oct 2011 03:33:20 -0400
Received: by wwe6 with SMTP id 6so3729253wwe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2011 00:33:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I add to TCP option 4 bytes using Netfilter hooks ( LOCAL_OUT ) and then 
recalculate the checksum correctly. When I send the packets using "wget 
www.google.com" , I see that the packet "Http Get" can not reach to the 
server, it re-transmits over time. Please help me with this.
