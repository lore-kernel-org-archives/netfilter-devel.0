From: Greg KH <greg@kroah.com>
Subject: Re: netfilter fixes for 4.12.y tree
Date: Sun, 27 Aug 2017 14:52:18 +0200
Message-ID: <20170827125218.GB2038@kroah.com>
References: <20170824133039.GC15739@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824133039.GC15739@breakpoint.cc>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Aug 24, 2017 at 03:30:39PM +0200, Florian Westphal wrote:
> Hi stable team,
> 
> please consider picking up the following commits for
> 4.12.y:
> 
> 36ac344e16e04e3e55e8fed7446095a6458c64e6
> netfilter: expect: fix crash when putting uninited expectation
> 
> 97772bcd56efa21d9d8976db6f205574ea602f51
> netfilter: nat: fix src map lookup
> (this causes severe issues when lots of nat mappings are active as we
>  run out of local source ports).
> 
> f55ce7b024090a51382ccab2730b96e2f7b4e9cf
> netfilter: nfnetlink: Improve input length sanitization in nfnetlink_rcv
> 
> all cherry-pick cleanly.

All now applied, thanks.

greg k-h
