From: tingwei liu <tingw.liu@gmail.com>
Subject: nfqueue return to iptables
Date: Tue, 2 Feb 2010 18:43:09 +0800
Message-ID: <237044a41002020243n5a4f7066s23e7d2bdc6418393@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:47663 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0BBKnL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:43:11 -0500
Received: by pxi12 with SMTP id 12so5610421pxi.33
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Feb 2010 02:43:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

How can I reinsert the skb to netfilter which is dealed by nfqueue target.
Videlicet, how can let the nfqueue requeue XT_CONTINUE.
thanks.
tony
