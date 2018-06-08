From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove include/net/netfilter/nft_dup.h
Date: Fri, 8 Jun 2018 12:42:48 +0200
Message-ID: <20180608104248.szkrj5ytw3yxjoqt@salvia>
References: <1528400289-28004-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528400289-28004-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 07, 2018 at 07:38:09PM +0000, Corentin Labbe wrote:
> include/net/netfilter/nft_dup.h was introduced in d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
> but was never user since this date.
> 
> Furthermore, the only struct in this file is unused elsewhere.

Applied.
