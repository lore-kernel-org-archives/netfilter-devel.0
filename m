From: Dmitri Seletski <drjoms@gmail.com>
Subject: nooby question
Date: Sun, 24 May 2009 03:07:43 +0100
Message-ID: <4A18ABEF.4080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49599 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZEXCHp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 22:07:45 -0400
Received: by ewy24 with SMTP id 24so2496835ewy.37
        for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2009 19:07:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

I am looking into being able to administer my home network and possibly
more complicated network scenarios.
I can make a rule or two to block ports, but i want more.

ULOG seems to become obsolete. I don't want to use LOG either.

Question is, is there a command line tool or daemon, that is planned to
be actively developed that can possibly track some ipv4/ipv6
information? Let's say, I want to know who and how many times attempted
to connect to SSH port and similar info without trashing my dmesg output.

Thank you in advance.
Dmitri
