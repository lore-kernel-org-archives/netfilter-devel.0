From: Fred Leeflang <fredl@dutchie.org>
Subject: documentation?
Date: Tue, 17 Nov 2009 12:26:05 +0100
Message-ID: <30defc5b0911170326g3a685bc7r8e211d1b54d38462@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37453 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZKQL0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:26:00 -0500
Received: by pwi3 with SMTP id 3so3907716pwi.21
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2009 03:26:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

is there any documentation for libnetfilter_log other than doxygen?
I'm observing that nflog_bind_group() returns 0 when trying to bind to
a group that's already bound by another proc, is that expected
behavior?

tnx,
Fred
