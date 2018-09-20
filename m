From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_osf: use enum nft_data_types for
 nft_validate_register_store
Date: Thu, 20 Sep 2018 18:24:40 +0200
Message-ID: <20180920162440.7gyo3jbdpktb3vqs@salvia>
References: <20180918052136.25978-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ffmancera@riseup.net, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918052136.25978-1-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 17, 2018 at 10:21:36PM -0700, Stefan Agner wrote:
> The function nft_validate_register_store requires a struct of type
> struct nft_data_types. NFTA_DATA_VALUE is of type enum
> nft_verdict_attributes. Pass the correct enum type.

Applied, thanks.
