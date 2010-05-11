From: Michael Hakimi <yalakvar@gmail.com>
Subject: libNetfilterQueue - Capturing all traffic
Date: Tue, 11 May 2010 10:39:48 +0300
Message-ID: <AANLkTinbYYmNT0eTbFV2NMtUlCr-eFojJaI0TffEZyTK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34342 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0EKHju (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 03:39:50 -0400
Received: by fxm19 with SMTP id 19so43786fxm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2010 00:39:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have a "simple" question regarding libNetfilterQueue and can't find
the answer for it.
I am trying to create an application that captures ALL the incoming
traffic using libNetfilterQueue. In the function nfq_bind_pf I need to
supply the protocol family. If I set it to AF_INET I get only IP
packets, if I set it to AF_PACKET the function fails.
I have also tried AF_UNSPEC but that didn't help.

Is there any way to to this?
Thank in advance for any help.

Regards,
Mickey
