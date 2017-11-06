From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ebtables: clean up initialization of buf
Date: Mon, 6 Nov 2017 14:50:02 +0100
Message-ID: <20171106135002.GA7055@salvia>
References: <20171016102402.10358-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171016102402.10358-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 16, 2017 at 11:24:02AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> buf is initialized to buf_start and then set on the next statement
> to buf_start + offsets[i].  Clean this up to just initialize buf
> to buf_start + offsets[i] to clean up the clang build warning:
> "Value stored to 'buf' during its initialization is never read"

Applied, thanks.
