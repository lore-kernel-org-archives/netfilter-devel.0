From: Florian Westphal <fw@strlen.de>
Subject: stable request: don't set F_IFACE on ipv6 fib lookups and followup
 fix
Date: Mon, 25 Jun 2018 19:22:39 +0200
Message-ID: <20180625172239.f4zp6imsu7m46jbs@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Andreas Steinmetz <ast@domdv.de>
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi.

Please consider applying

47b7e7f82802 ("netfilter: don't set F_IFACE on ipv6 fib lookups")
and its followup commit:
cede24d1b21d ("netfilter: ip6t_rpfilter: provide input interface for route lookup")

to 4.14.y.

For 4.16.y and 4.17.y, please consider applying
cede24d1b21d ("netfilter: ip6t_rpfilter: provide input interface for route lookup")

For 4.17.y, consider
fc6ddbecce44 ("netfilter: xt_connmark: fix list corruption on rmmod").

For all maintained trees, consider following candiate:

adc972c5b88829d3 ("netfilter: nf_tables: use WARN_ON_ONCE instead of BUG_ON in nft_do_chain()")

Thanks,
Florian
