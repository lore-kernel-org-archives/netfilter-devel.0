From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/5] Workaround of recvfrom() EAGAIN bug
Date: Sat, 12 Jan 2008 15:48:06 +0100
Message-ID: <4788D326.1000901@trash.net>
References: <20080111150910.582899000@andrew.endian.com> <20080111152824.849353000@andrew.endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49415 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762657AbYALOw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:52:57 -0500
In-Reply-To: <20080111152824.849353000@andrew.endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:

 > This is a workaround which prevents ulogd from logging each
 > time when recvfrom() returns error because of EAGAIN.
 > Since the netlink socket is now O_NONBLOCK, we probably run
 > into the following bug:
 > ...

This is not a workaround, but correct handling of EAGAIN on
a non-blocking socket. This happens because we loop until
there is no more data in the receive-queue.

Applied, thanks.
