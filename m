From: Fred Leeflang <fredl@dutchie.org>
Subject: ulogd extension
Date: Fri, 30 Oct 2009 21:17:26 +0100
Message-ID: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: vuurmuur-devel@lists.sourceforge.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55543 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZJ3URV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 16:17:21 -0400
Received: by pwj9 with SMTP id 9so845788pwj.21
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2009 13:17:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

For vuurmuur I would like to write an ulogd extension that writes out
a log somewhat comparable to syslog. Currently vuurmuur parses syslog
line generated with the LOG target, we are considering changing this
to having ulogd do this for us through the ULOG target and said
extension. What's the best way to go about doing this to keep the
extension maintainable?

-Fred
