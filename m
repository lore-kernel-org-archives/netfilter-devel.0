From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: conntrack: fix calculation of next bucket
 number in early_drop
Date: Sat, 3 Nov 2018 14:16:20 +0100
Message-ID: <20181103131620.alepdriguhu2rxc3@salvia>
References: <20181025191543.15061-1-vasilykh@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>, stable@vger.kernel.org
To: Vasily Khoruzhick <vasilykh@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181025191543.15061-1-vasilykh@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 25, 2018 at 12:15:43PM -0700, Vasily Khoruzhick wrote:
> If there's no entry to drop in bucket that corresponds to the hash,
> early_drop() should look for it in other buckets. But since it increments
> hash instead of bucket number, it actually looks in the same bucket 8
> times: hsize is 16k by default (14 bits) and hash is 32-bit value, so
> reciprocal_scale(hash, hsize) returns the same value for hash..hash+7 in
> most cases.
> 
> Fix it by increasing bucket number instead of hash and rename _hash
> to bucket to avoid future confusion.

Applied, thanks.
