From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Trouble with nfq_get_timestamp
Date: Sun, 26 Apr 2009 18:43:15 +0200
Message-ID: <17e3a8f80904260943j5ff13304paa523fe88db4344a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35791 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbZDZQnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:43:16 -0400
Received: by fxm2 with SMTP id 2so1890786fxm.37
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2009 09:43:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am currently writing a small user space application where I need the
timestamp of the packets. In the callback-function, I use
nfq_get_timestamp and  provide it with the pointer to a timeval-struct
and the nfq_data sent to the callback function. However, the function
always returns -1 and failes. The get_id() and so forth works
perfectly, so I am wondering if anybody has any hints or knows how to
solve this?

I am currently using nfnetlink 0.0.39 and libnetfilter_queue 0.0.16-1,
but I have tried the newest version as well with no luck (the reason I
chose these are because they are the newest in my packet repo). My
kernel is 2.6.28.

Thanks in advance,
Kristian
