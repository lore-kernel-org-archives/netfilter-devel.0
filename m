From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Updating variable shared between user and kernel space
Date: Thu, 26 Mar 2009 15:00:25 +0100
Message-ID: <17e3a8f80903260700y2908961ah2218fcd185a76f7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35680 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbZCZOA2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:00:28 -0400
Received: by fxm2 with SMTP id 2so565811fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 07:00:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have a value I would like to share between userspace and kernelspace
(it is store in my target struct and intialized in the user space part
of my module), but when I update it in kernel space it gets the wrong
value. When for example incrementing the value by 1 every time the
rule matches, the values are all messed up (but never larger than the
number of matches/increments). When creating and initializing the
value in the module, it behaves correctly.

I always though that if you try to accesses userspace varibles from
kernel space, you will get a seg. fault or similar, and am therefore a
little confused as to why this do not work. Does anybody know why
and/or how to share variables?

-Kristian
