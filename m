From: Jan Engelhardt <jengelh@medozas.de>
Subject: Fwd: kaber: Delayed Mail (still being retried)
Date: Wed, 24 Mar 2010 18:51:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003241849020.25215@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58205 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab0CXRvs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:51:48 -0400
Content-ID: <alpine.LSU.2.01.1003241849022.25215@obet.zrqbmnf.qr>
Content-Description: Notification
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,


I'm getting a problem line from your mail server, so I hope you still
receive from the mailing list of this.

<kaber@trash.net>: host mail.trash.net[213.144.137.162] said: 451 4.3.5 Server
    configuration problem (in reply to RCPT TO command)

Mar 24 17:15:28 borg postfix/qmgr[26258]: EB267F0C32B98: from=<jengelh@medozas.de>, size=1902, nrcpt=2 (queue active)
Mar 24 17:15:28 borg postfix/smtp[26260]: Host offered STARTTLS: [mail.trash.net]
Mar 24 17:15:29 borg postfix/smtp[26260]: EB267F0C32B98: host mail.trash.net[2001:1620:2001::10] said: 451 4.3.5 Server configuration problem (in reply to RCPT TO command)
Mar 24 17:15:29 borg postfix/smtp[26260]: Host offered STARTTLS: [mail.trash.net]
Mar 24 17:15:30 borg postfix/smtp[26260]: EB267F0C32B98: to=<kaber@trash.net>, relay=mail.trash.net[213.144.137.162]:25, delay=3208, delays=3206/0.02/1.1/1.2, dsn=4.3.5, status=deferred (host mail.trash.net[213.144.137.162] said: 451 4.3.5 Server configuration problem (in reply to RCPT TO command))
