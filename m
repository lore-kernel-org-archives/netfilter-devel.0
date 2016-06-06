From: Sylvain Lemieux <slemieux.tyco@gmail.com>
Subject: 4.7-rc2: iptables broken on ARM 32 bits
Date: Mon, 06 Jun 2016 08:52:54 -0400
Message-ID: <1465217574.9851.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: john.stultz@linaro.org, fw@strlen.de, arnd@arndb.de,
	netfilter-devel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35741 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcFFMw7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 08:52:59 -0400
Received: by mail-io0-f177.google.com with SMTP id o189so127063089ioe.2
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2016 05:52:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

the issue with the broken iptables on 32 bits ARM platform
is still present in 4.7-rc2.

The issue was initially reported by John Stultz; please refer
to this link for details: https://lkml.org/lkml/2016/5/26/351

I tested the second solution and this fix the issue for me.

Is there any plan to include a fix in rc3?


Sylvain Lemieux


