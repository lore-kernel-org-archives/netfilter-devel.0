From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: copy and paste bug in
 nf_tables_getflowtable()
Date: Wed, 10 Jan 2018 15:20:45 +0100
Message-ID: <20180110142045.4jtqqmmuadcshlhd@salvia>
References: <20180110094735.zyfdsonrb76x7cd6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110094735.zyfdsonrb76x7cd6@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 10, 2018 at 12:47:35PM +0300, Dan Carpenter wrote:
> We should be testing "flowtable" instead of "table".

Your robot was too late, sorry :)

I'm taking the patch from Wei Yongjun.

Thank you.
