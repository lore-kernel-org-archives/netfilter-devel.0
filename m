From: Tamas Lengyel <tamas.k.lengyel@gmail.com>
Subject: libnetfilter_queue: Another Valgrind complaint with nfq_set_mode
Date: Sat, 15 Jun 2013 22:46:03 +0200
Message-ID: <CABfawhn5aHcRneVvZLLFd_Ut7jFkMWh3M7jvXRvMKao6EdWp-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47246 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3FOUqF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:46:05 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so1415128wgh.14
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jun 2013 13:46:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I encountered another Valgrind complaint with libnetfilter_queue but
this time I have been unable to track it down. The error is benign but
here it is anyway:

1 errors in context 1 of 1:
Syscall param socketcall.sendto(msg) points to uninitialised byte(s)
  at 0x614D723: ??? (syscall-template.S:82)
  by 0x5D2CFC2: nfnl_send (in /usr/lib/libnfnetlink.so.0.2.0)
  by 0x5D2EC22: nfnl_query (in /usr/lib/libnfnetlink.so.0.2.0)
  by 0x5B279FF: nfq_set_mode (libnetfilter_queue.c:625)

Tamas
