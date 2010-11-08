From: Changli Gao <xiaosuo@gmail.com>
Subject: Fwd: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 8 Nov 2010 14:34:07 +0800
Message-ID: <AANLkTinFKxOb2quNxV8HKz3Bgp9CwO_uzqE+7hBd+WxW@mail.gmail.com>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60358 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0KHGe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:34:28 -0500
Received: by fxm16 with SMTP id 16so3757865fxm.19
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Nov 2010 22:34:27 -0800 (PST)
In-Reply-To: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc: netfilter-devel


---------- Forwarded message ----------
From: Changli Gao <xiaosuo@gmail.com>
Date: Mon, Nov 8, 2010 at 2:32 PM
Subject: RFC: netfilter: cache dst_entry in conntrack
To: Patrick McHardy <kaber@trash.net>
Cc: netfilter-devel@lists.netfilter.org


When conntrack is enabled, we can cache dst_entry into the
corresponding conntrack to eliminate the subsequence
ip_route_input_noref() calls for the same connection. The current
implementation is a standalone module. If this idea is welcomed, I'll
try to push it up. Thanks.

Here it is: https://github.com/xiaosuo/xiaosuo/tree/master/nf_rtcache/

--
Regards,
Changli Gao(xiaosuo@gmail.com)



-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
