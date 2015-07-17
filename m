From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: Re: nf_conntrack: falling back to vmalloc.
Date: Fri, 17 Jul 2015 16:34:06 +0200
Message-ID: <55A9125E.2080807@gmx.de>
References: <55A8C428.1000005@gmx.de> <20150717101009.GN25674@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
	Marcelo Leitner <mleitner@redhat.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55261 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbGQOeW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2015 10:34:22 -0400
In-Reply-To: <20150717101009.GN25674@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/17/2015 12:10 PM, Florian Westphal wrote:
> Do you run containers?

No, I just run 4 Gentoo chroot images in parallel - but I do that since autumn last year.

Unfortunately I cannot see any correlation to an os/sw upgrade or a config change which could cause these messages nowadays to be appear.
Therefore I do wonder if some network related "traffic" causes this, b/c that box acts as a Tor exit relay too.


-- 
Toralf, pgp key: 872AE508 0076E94E
