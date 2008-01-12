From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] openlog() to syslog for global ulogd log messages
Date: Sat, 12 Jan 2008 15:41:41 +0100
Message-ID: <4788D1A5.6040708@trash.net>
References: <20080111150910.582899000@andrew.endian.com> <20080111152824.041585000@andrew.endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49275 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762430AbYALOqe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:46:34 -0500
In-Reply-To: <20080111152824.041585000@andrew.endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:

 > When [global]'s logfile is syslog, ulogd should log it's own
 > mesasages (not the firewall log lines) to syslog, which it
 > does'nt because openlog() is missing. This patch adds openlog()
 >
 > Signed-off-by: Peter Warasin <peter@endian.com>


Applied, but I changed the spaces used for intending to tabs.
