From: "James King" <t.james.king@gmail.com>
Subject: xtables-addons git repo inaccessible
Date: Tue, 19 Aug 2008 13:43:13 -0700
Message-ID: <38bcb3ec0808191343m5052813fsfc7b798ea5f84252@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:11190 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYHSUnP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:43:15 -0400
Received: by ik-out-1112.google.com with SMTP id c28so104280ika.5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2008 13:43:13 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan,

Attempting to pull or clone off of your xtables-addons repo (indeed
any repo on git://dev.medozas.de) is currently failing:

$ git pull
fatal: The remote end hung up unexpectedly

$ git clone git://dev.medozas.de/xtables-addons
Initialized empty Git repository in /usr/src/git/a/xtables-addons/.git/
fatal: read error (Connection reset by peer)
fetch-pack from 'git://dev.medozas.de/xtables-addons' failed.

Telneting to dev.medozas.de on port 9418 succeeds, but the remote end
closes the connection immediately.  The repo's gitweb is still
accessible.


Thanks
