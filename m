From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons 1.38: libipset uses symbol that's not in
 library
Date: Sun, 28 Aug 2011 19:42:02 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108281941560.12106@frira.zrqbmnf.qr>
References: <201108261325.09143.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41256 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1H1RmE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 13:42:04 -0400
In-Reply-To: <201108261325.09143.a.miskiewicz@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-08-26 13:25, Arkadiusz Miskiewicz wrote:

>Unresolved symbols found in: /home/users/arekm/tmp/xtables-addons-1.38-root-
>arekm/usr/lib64/libipset.so.1.0.0
>        ipset_errcode

Fixed, thanks.

