From: Phil Oester <kernel@linuxace.com>
Subject: Re: How to test netfilter SYNPROXY target properly?
Date: Fri, 3 Jan 2014 09:49:31 -0800
Message-ID: <20140103174930.GA9327@home>
References: <CAK3+h2wX3PvcMyNhYWYTnxyQyr9YN_2Mzr21gD4OrpF2P6+TcQ@mail.gmail.com>
 <20140103131908.GA26268@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52943 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaACRtd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:49:33 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so15887133pbb.23
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jan 2014 09:49:32 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140103131908.GA26268@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 03, 2014 at 01:19:08PM +0000, Patrick McHardy wrote:
> I guess you need to put the SYNPROXY rule in FORWARD instead of INPUT.

Though having a manpage for this newly added extension would likely
be helpful.

Phil
