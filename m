From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] netfilter: nf_tables: fix a typo in
 nf_tables_getflowtable()
Date: Wed, 10 Jan 2018 14:40:48 +0100
Message-ID: <20180110134048.os7dotrxppsb45kc@salvia>
References: <1515567894-188104-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515567894-188104-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 10, 2018 at 07:04:54AM +0000, Wei Yongjun wrote:
> Fix a typo, we should check 'flowtable' instead of 'table'.

Applied, thanks.
