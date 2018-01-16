From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 1/2] netfilter: nf_defrag: mark xt_table
 structures 'const' again
Date: Tue, 16 Jan 2018 01:48:06 +0100
Message-ID: <20180116004806.xwwar6ewwuj3wrhv@salvia>
References: <20180115154918.4176669-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180115154918.4176669-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 15, 2018 at 04:49:05PM +0100, Arnd Bergmann wrote:
> As a side-effect of adding the module option, we now get a section
> mismatch warning:
> 
> WARNING: net/ipv4/netfilter/iptable_raw.o(.data+0x1c): Section mismatch in reference from the variable packet_raw to the function .init.text:iptable_raw_table_init()
> The variable packet_raw references
> the function __init iptable_raw_table_init()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Applied, thanks Arnd.
