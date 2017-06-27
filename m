From: Greg KH <greg@kroah.com>
Subject: Re: [4.11.y netfilter] 4.11 iptables regression fix
Date: Tue, 27 Jun 2017 13:30:37 +0200
Message-ID: <20170627113037.GH10609@kroah.com>
References: <20170621084151.GD28291@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621084151.GD28291@breakpoint.cc>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 21, 2017 at 10:41:51AM +0200, Florian Westphal wrote:
> Hi.
> 
> Please consider picking up
> 
> commit 324318f0248c31be8a08984146e7e4dd7cdd091d
> Author: Willem de Bruijn <willemb@google.com>
> netfilter: xtables: zero padding in data_to_user
> 
> After this, you will also need to pick
> 
> commit 751a9c763849f5859cb69ea44b0430d00672f637
> Author: Willem de Bruijn <willemb@google.com>
> netfilter: xtables: fix build failure from COMPAT_XT_ALIGN outside CONFIG_COMPAT
> 
> Both apply cleanly to 4.11.  Earlier kernels are not affected.
> 
> Without these two patches we fail to delete rules, e.g.
> 
> iptables -A INPUT -i lo -p icmp --icmp-type 1 -j ACCEPT
> iptables -D INPUT -i lo -p icmp --icmp-type 1 -j ACCEPT
> 
> 2nd command fails to delete the newly added rule.

Now queued up, thanks.

greg k-h
