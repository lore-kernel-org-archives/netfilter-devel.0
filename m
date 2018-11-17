From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_cttimeout: fetch timeouts for
 udplite and gre, too
Date: Sat, 17 Nov 2018 12:17:00 +0100
Message-ID: <20181117111700.iypnxoj2hdycnxcm@salvia>
References: <0000000000004f5883057acf6af2@google.com>
 <20181117103229.24678-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181117103229.24678-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Nov 17, 2018 at 11:32:29AM +0100, Florian Westphal wrote:
> syzbot was able to trigger the WARN in cttimeout_default_get() by
> passing UDPLITE as l4protocol.  Alias UDPLITE to UDP, both use
> same timeout values.
> 
> Furthermore, also fetch GRE timeouts.  GRE is a bit more complicated,
> as it still can be a module and its netns_proto_gre struct layout isn't
> visible outside of the gre module.
> 
> Work around this by forcing the timeouts to be the first structure
> member, then use plain net_generic().
> 
> A followup nf-next patch could make gre tracker be built-in as well
> if needed, its not that large.
> 
> Last, make the WARN() mention the missing protocol value in case
> anything else is missing.

Applied, thanks Florian.
