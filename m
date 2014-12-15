From: Tomer Eliyahu <tomereliyahu1@gmail.com>
Subject: Question regarding iptables-nftables compatibility layer with libiptc
Date: Mon, 15 Dec 2014 16:33:59 +0200
Message-ID: <CA+eXE3yHB3WWrxzXNLrWD-YAO5=YnBP8s2Zke3_cjaFzdg9wUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37337 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaLOOeA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:34:00 -0500
Received: by mail-lb0-f175.google.com with SMTP id u10so9002619lbd.20
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2014 06:33:59 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Regarding applications which use libiptc directly, such as openwrt's
firewall package - does the iptables-nftables compatibility layer
support translating libiptc calls to nftables calls?

If not - is there any plan to add such support or should every such
application be upgraded for nftables support?

Best Regards,

Tomer
