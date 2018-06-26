From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: nf_log: fix uninit read in
 nf_log_proc_dostring
Date: Tue, 26 Jun 2018 18:05:05 +0200
Message-ID: <20180626160505.cabcyt6yraw5jnjz@salvia>
References: <20180620163345.212776-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jann Horn <jannh@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620163345.212776-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 20, 2018 at 06:33:45PM +0200, Jann Horn wrote:
> When proc_dostring() is called with a non-zero offset in strict mode, it
> doesn't just write to the ->data buffer, it also reads. Make sure it
> doesn't read uninitialized data.

Applied, thanks.
