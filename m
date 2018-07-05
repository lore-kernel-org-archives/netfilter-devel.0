From: Greg KH <greg@kroah.com>
Subject: Re: stable request: don't set F_IFACE on ipv6 fib lookups and
 followup fix
Date: Thu, 5 Jul 2018 19:01:22 +0200
Message-ID: <20180705170122.GC4349@kroah.com>
References: <20180625172239.f4zp6imsu7m46jbs@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Andreas Steinmetz <ast@domdv.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625172239.f4zp6imsu7m46jbs@breakpoint.cc>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 25, 2018 at 07:22:39PM +0200, Florian Westphal wrote:
> Hi.
> 
> Please consider applying
> 
> 47b7e7f82802 ("netfilter: don't set F_IFACE on ipv6 fib lookups")
> and its followup commit:
> cede24d1b21d ("netfilter: ip6t_rpfilter: provide input interface for route lookup")
> 
> to 4.14.y.
> 
> For 4.16.y and 4.17.y, please consider applying
> cede24d1b21d ("netfilter: ip6t_rpfilter: provide input interface for route lookup")
> 
> For 4.17.y, consider
> fc6ddbecce44 ("netfilter: xt_connmark: fix list corruption on rmmod").
> 
> For all maintained trees, consider following candiate:
> 
> adc972c5b88829d3 ("netfilter: nf_tables: use WARN_ON_ONCE instead of BUG_ON in nft_do_chain()")

All now queued up, thanks,

greg k-h
