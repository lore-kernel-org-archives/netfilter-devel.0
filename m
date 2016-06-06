From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: off-by-one in DecodeQ931
Date: Mon, 6 Jun 2016 16:55:10 +0200
Message-ID: <20160606145510.GB1168@salvia>
References: <CAML0wpEBwXdzWX7g3LDJRDOVM0J7dkuhH8b+96ZhRf54+qUgwQ@mail.gmail.com>
 <20160425152905.GA8621@strlen.de>
 <CAML0wpGWvcpB5GE_zAjOeO6ki_nszaj+hR9yyadwu_3hQno7Cg@mail.gmail.com>
 <CAML0wpGqddtn92Rb2CSmV0kZfTzOxdCU-+dAFG1HUAaqQa8RUw@mail.gmail.com>
 <20160606143555.GC7827@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toby DiPasquale <toby@cbcg.net>, Patrick McHardy <kaber@trash.net>,
	kadlec@blackhole.kfki.hu, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606143555.GC7827@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 06, 2016 at 04:35:55PM +0200, Florian Westphal wrote:
> Toby DiPasquale <toby@cbcg.net> wrote:
> > Is this latest patch OK?
> 
> Yes, I don't know why it wasn't applied yet.
> 
> Pablo?

This doesn't apply.

$ git am /tmp/off-by-one-in-DecodeQ931.patch -s
Applying: off-by-one in DecodeQ931
error: patch failed: net/netfilter/nf_conntrack_h323_asn1.c:846
error: net/netfilter/nf_conntrack_h323_asn1.c: patch does not apply
Patch failed at 0001 off-by-one in DecodeQ931
The copy of the patch that failed is found in:
   patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Could you resubmit using git-format-patch? Thanks.
