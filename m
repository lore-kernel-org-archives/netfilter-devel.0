From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: Should xt_osf_remove_callback() return negative
 on errors?
Date: Fri, 13 Nov 2009 09:32:32 +0100
Message-ID: <4AFD19A0.90608@trash.net>
References: <4AFB3B9D.1080606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbZKMIca (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:32:30 -0500
In-Reply-To: <4AFB3B9D.1080606@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roel Kluin wrote:
> Return a negative error value

Applied, thanks.
