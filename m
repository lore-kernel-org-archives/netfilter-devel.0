From: Fr3DBr <fr3dbr@gmail.com>
Subject: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 18:58:57 -0300
Message-ID: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37318 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2CWV66 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:58:58 -0400
Received: by pbcun15 with SMTP id un15so2907849pbc.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 14:58:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm writting a module to deal with certain packets, and i wanted to
DROP then initially, store it, and at an later moment, reinject it
before the routing decision.

What would be the method i could call, to place the packet again in
the stack at this point ?!

Thanks,

Fred
