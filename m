From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: ctnetlink loop
Date: Fri, 3 Dec 2010 14:58:41 +0100
Message-ID: <20101203135841.GA23610@mail.eitzenberger.org>
References: <20101203133903.GG13225@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab0LCN6o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:58:44 -0500
Content-Disposition: inline
In-Reply-To: <20101203133903.GG13225@mail.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[changed netfilter-devel address]

I is even stuck for O_NONBLOCK sockets, which may be due to nfnl_mutex
being held in the receive path.

 /holger

