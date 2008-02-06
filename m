From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Get UID from netlink/conntrack
Date: Wed, 6 Feb 2008 22:02:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802062159510.23855@fbirervta.pbzchgretzou.qr>
References: <438194.92391.qm@web30402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Justin McCann <jneilm@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34034 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbYBFVCJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:02:09 -0500
In-Reply-To: <438194.92391.qm@web30402.mail.mud.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 6 2008 12:30, Justin McCann wrote:
>
>I'd like to use libnetfilter_conntrack to track connections per UID
>and/or by PID, but AFAICT the nfnetlink conntrack messages don't
>include the user id, process id, or inode (useful for
>cross-referencing). I noticed that the nfnetlink_log messages have
>the uid, but I don't think I want to invoke the filtering & logging
>subsystem just to track connection changes.

You are facing the same issues as xt_socket (currently, and
unfortunately, still named xt_owner) - in that sockets do not
necessarily have an owner, much less exactly one associated PID.
Just be aware of that.
