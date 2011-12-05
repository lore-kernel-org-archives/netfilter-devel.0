From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet
 due to helper rejection conditional on LOG_INVALID (resubmit)
Date: Mon, 5 Dec 2011 23:37:38 +0100
Message-ID: <20111205223738.GA6184@1984>
References: <CANtneHLYOANXQ432me_htXrMcQkv-WVpNYTrwmxAjc2gV68iPA@mail.gmail.com>
 <20111204224946.GC28125@1984>
 <CANtneHJbS_3QhAEJ3b7ifN1ywDy7Lj+ycve5X2ydqgY2FC5erg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pete Holland <pholland27@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39416 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab1LEWhn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:37:43 -0500
Content-Disposition: inline
In-Reply-To: <CANtneHJbS_3QhAEJ3b7ifN1ywDy7Lj+ycve5X2ydqgY2FC5erg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 05, 2011 at 10:09:51AM -0800, Pete Holland wrote:
> would you like that I check *net for NULL as is done for *ct, *help,
> and *helper?

No. net is not ever NULL.
