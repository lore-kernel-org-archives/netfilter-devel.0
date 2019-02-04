From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] selftests/netfilter: fix config fragment
 CONFIG_NF_TABLES_INET
Date: Mon, 4 Feb 2019 14:21:55 +0100
Message-ID: <20190204132155.wigblmuifkibg6dk@salvia>
References: <20190129062835.31122-1-naresh.kamboju@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, davem@davemloft.net, linux-kselftest@vger.kernel.org
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190129062835.31122-1-naresh.kamboju@linaro.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 29, 2019 at 06:28:35AM +0000, Naresh Kamboju wrote:
> In selftests the config fragment for netfilter was added as
> NF_TABLES_INET=y and this patch correct it as CONFIG_NF_TABLES_INET=y

Applied, thanks.
