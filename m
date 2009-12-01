From: Fred Leeflang <fredl@dutchie.org>
Subject: nflog_bind_group() question
Date: Tue, 1 Dec 2009 11:44:12 +0100
Message-ID: <30defc5b0912010244i385afe45gac6bc521c19a75da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: vuurmuur-devel@lists.sourceforge.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46705 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZLAKoG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:44:06 -0500
Received: by pwi3 with SMTP id 3so2473572pwi.21
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Dec 2009 02:44:13 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi devs,

We've recently implemented NFLOG support in vuurmuur, I've written an
article on the effort here
http://wordpress.3dn.nl/2009/11/25/iptabes-nflog-support-in-vuurmuur/

I'm curious about something I found out in the process. I've had
ulogd2 running alongside vuurmuur for a while and configured it to
listen to a specific nflog-group. When I had ulogd2 running I would
not be able to run vuurmuur_log which also listens to an nflog-group.
It took me a while to realize that it would not work because of having
ulogd2 running and both trying to listen to the SAME nflog-group.

Does this mean that it's not possible for two applications at the same
time to get netfilter_log messages from the same nflog-group?

-Fred
