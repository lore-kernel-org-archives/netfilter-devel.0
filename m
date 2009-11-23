From: David Miller <davem@davemloft.net>
Subject: Re: netfilter: xt_limit: fix invalid return code in
 limit_mt_check()
Date: Mon, 23 Nov 2009 09:53:14 -0800 (PST)
Message-ID: <20091123.095314.117228474.davem@davemloft.net>
References: <4B0A838D.3020907@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4B0A838D.3020907@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 23 Nov 2009 13:43:57 +0100

> This patch fixes an invalid return value in the limit match.
> Please apply or pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Pulled, thanks Patrick.
