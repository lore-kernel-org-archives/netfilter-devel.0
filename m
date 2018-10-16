From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: fix DNAT target for shifted portmap ranges
Date: Tue, 16 Oct 2018 19:35:10 +0200
Message-ID: <20181016173510.eokgsdh6nhszmnhx@salvia>
References: <e59ead42affbd4280e678a7c77eda13106d40984.1539701235.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Thierry Du Tre <thierry@dtsystems.be>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e59ead42affbd4280e678a7c77eda13106d40984.1539701235.git.pabeni@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 16, 2018 at 04:52:05PM +0200, Paolo Abeni wrote:
> The commit 2eb0f624b709 ("netfilter: add NAT support for shifted
> portmap ranges") did not set the checkentry/destroy callbacks for
> the newly added DNAT target. As a result, rulesets using only
> such nat targets are not effective, as the relevant conntrack hooks
> are not enabled.
> The above affect also nft_compat rulesets.
> Fix the issue adding the missing initializers.

Applied, thanks Paolo.
