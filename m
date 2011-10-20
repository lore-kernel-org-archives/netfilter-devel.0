From: hoangtam <tamnghoang@gmail.com>
Subject: add new tcp option
Date: Thu, 20 Oct 2011 17:31:05 +0200
Message-ID: <4EA03EB9.70204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64728 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1JTPbP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:31:15 -0400
Received: by wwe6 with SMTP id 6so4353906wwe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2011 08:31:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
I have done with netfilter to add 4 bytes to tcp header option. I use 
wireshark to check its working, and the result is : for the packets 
without data payload I can see 4 bytes in packet correctly; but for the 
packets with data payload 4 bytes changing. I'm sure that other fields 
of packet (tcp header, ip header) is ok. Any suggestion is appreciated.?
