From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/5] Logs also ipulog_strerror() and strerror() within
 ULOG plugin
Date: Sat, 12 Jan 2008 15:44:29 +0100
Message-ID: <4788D24D.10602@trash.net>
References: <20080111150910.582899000@andrew.endian.com> <20080111152824.583966000@andrew.endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49321 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762657AbYALOtU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:49:20 -0500
In-Reply-To: <20080111152824.583966000@andrew.endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:

 > This patch logs also the string representations ipulog:_strerror()
 > and strerror() when an error occurred during receivement of packets
 > within the ULOG plugin
 >
 > Signed-off-by: Peter Warasin <peter@endian.com>

Applied, thanks.
