From: Wiktor Kolodziej <wiktor@zhr.pl>
Subject: [xtables-addons] extensions in a non-modular kernel
Date: Thu, 3 Dec 2009 11:54:38 +0100
Message-ID: <6fbd78aa0912030254p2382b23do6bc7a8700a013e47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:57373 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbZLCKyc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:54:32 -0500
Received: by ywh12 with SMTP id 12so1293608ywh.21
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Dec 2009 02:54:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Is there any easy way to compile extensions into a non-modular kernel?

I've found in Jan's "An Introduction to Xtables-addons" that this is
possible, but can you please give me some more info how to do it?
What do you mean by "editing some kernel Makefile to descend into
xtables-addons/extensions" ?

Wiktor
