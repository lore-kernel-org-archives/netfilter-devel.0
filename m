From: "Nir Tzachar" <nir.tzachar@gmail.com>
Subject: QUEUE target and capabilities
Date: Sun, 21 Oct 2007 09:17:28 +0200
Message-ID: <9b2db90b0710210017i196253f5sedfd5348ea42a03a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:33343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJUHRa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:17:30 -0400
Received: by ug-out-1314.google.com with SMTP id z38so778105ugc
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Oct 2007 00:17:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello.

I am writing an application which uses the QUEUE target, and
encountered a simple problem. My goal is to run the application
without root privileges. That is, start the program under root, call
ipq_create_handle, and then drop privileges.

However, as far as I can tell, I cannot communicate with the netlink
socket of netfilter unless the process has the CAP_NET_ADMIN
capability (I may be wrong, but I am basing this on:
/usr/src/linux/net/netfilter/nfnetlink.c:204:   if
(security_netlink_recv(skb, CAP_NET_ADMIN))
).

So, is there a way to use the QUEUE target _after_ dropping privilages?

thanks.
