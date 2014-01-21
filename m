From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] build: resolve build failure involving
 linux/netlink.h
Date: Tue, 21 Jan 2014 13:25:22 +0100
Message-ID: <20140121122522.GA22917@localhost>
References: <1390261922-13182-1-git-send-email-jengelh@inai.de>
 <1390261922-13182-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44111 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbaAUMZ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:25:29 -0500
Content-Disposition: inline
In-Reply-To: <1390261922-13182-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 12:52:01AM +0100, Jan Engelhardt wrote:
> This was seen with a sufficiently-old /usr/include/linux
> (from Linux 2.6.32).
> 
> 	In file included from common.c:10:
> 	/usr/include/linux/netlink.h:34: error: expected
> 	specifier-qualifier-list before 'sa_family_t'
> 
> The solution is to include <linux/*> last of all system headers.

applied.
