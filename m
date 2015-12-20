From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Support of different targets in nftables
Date: Sun, 20 Dec 2015 14:59:58 +0530
Message-ID: <CAKHNQQEvQ9-RTOFjyrvonCZ-miiwucBcw_M+KufJ2yhjrK2a7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:32921 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbbLTJaT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Dec 2015 04:30:19 -0500
Received: by mail-wm0-f47.google.com with SMTP id p187so34884799wmp.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 01:30:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

While doing the translations, I see that iptables-translate is able to
produce output only for the target ACCEPT. For all others, it shows

nft # <rules>

Why is it so?

Thank you
