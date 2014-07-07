From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 6/7] autotools conversion: commit the rest of the
 configure.ac changes.
Date: Mon, 7 Jul 2014 15:14:27 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1407071513100.20461@nerf08.vanv.qr>
References: <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de> <1404728169-7899-7-git-send-email-giorgio.nicole@arcor.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:58285 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaGGNO2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:14:28 -0400
In-Reply-To: <1404728169-7899-7-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2014-07-07 12:16, Giorgio Dal Molin wrote:
>+
>+AS_CASE([$enable_debug],
>+	[yes],[
>+	AC_DEFINE([DEBUG],1,[Debug enabled])
>+	DEBUG_CPPFLAGS="-g -DDEBUG"
>+	])
>+
>+AC_SUBST(DEBUG_CPPFLAGS)

-g should not be in DEBUG_CPPFLAGS (but DEBUG_CFLAGS)
because it's strictly speaking not a preprocessor flag.
