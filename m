From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [{ip,ip6}tables-compat PATCH] nft: fix network prefixes
Date: Tue, 26 Aug 2014 21:29:18 +0200
Message-ID: <20140826192918.GA3394@salvia>
References: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
 <20140826085513.GA3800@salvia>
 <CAFpD06RPw3pMaLHzXWdMZ7BnzXH1Sh7n68biqpR+o4k5j9=Nkg@mail.gmail.com>
 <CAFpD06SEXxqe2297-N-129tK2=Z2tAiV5fs_1Xc9AvWLnsEuVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55199 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbaHZT2s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:28:48 -0400
Content-Disposition: inline
In-Reply-To: <CAFpD06SEXxqe2297-N-129tK2=Z2tAiV5fs_1Xc9AvWLnsEuVg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 01:45:42PM +0200, Giuseppe Longo wrote:
> I forgot to say that netlink code seems correct:
> ip filter INPUT 26
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
>   [ cmp eq reg 1 0x0000a8c0 ]
>   [ match name tcp rev 0 ]
>   [ match name conntrack rev 3 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 accept ]

Then, fix the patch description and resubmit, thanks Giuseppe.

