From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_defrag_ipv6.o included twice
Date: Wed, 28 Aug 2013 00:50:11 +0200
Message-ID: <20130827225011.GA15556@localhost>
References: <BLU0-SMTP246C0F210C1747FE63C4E97AC4E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Nathan Hintz <nlhintz@hotmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP246C0F210C1747FE63C4E97AC4E0@phx.gbl>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Aug 22, 2013 at 10:09:12PM -0700, Nathan Hintz wrote:
> 'nf_defrag_ipv6' is built as a separate module; it shouldn't be
> included in the 'nf_conntrack_ipv6' module as well.

Applied, thanks.
