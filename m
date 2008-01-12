From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] Dont ntohs() mac_len of ULOG, since it is not in
 network byte order
Date: Sat, 12 Jan 2008 15:43:12 +0100
Message-ID: <4788D200.2020900@trash.net>
References: <20080111150910.582899000@andrew.endian.com> <20080111152824.287682000@andrew.endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49294 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbYALOsD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:48:03 -0500
In-Reply-To: <20080111152824.287682000@andrew.endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:

 > Stores mac_len correctly, since within ULOG structire it is not stored
 > in network byte order.
 >
 > Signed-off-by: Peter Warasin <peter@endian.com>

Applied, thanks Peter.
