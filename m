From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] selftests/netfilter: fix config fragment
 CONFIG_NF_TABLES_INET
Date: Tue, 29 Jan 2019 08:59:53 +0100
Message-ID: <20190129075953.j5qogpvmqalkukoo@breakpoint.cc>
References: <20190129062835.31122-1-naresh.kamboju@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        linux-kselftest@vger.kernel.org
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190129062835.31122-1-naresh.kamboju@linaro.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> In selftests the config fragment for netfilter was added as
> NF_TABLES_INET=y and this patch correct it as CONFIG_NF_TABLES_INET=y

Oh, silly me.  Thanks for fixing this up.

Acked-by: Florian Westphal <fw@strlen.de>
