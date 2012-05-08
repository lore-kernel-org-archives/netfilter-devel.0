From: Christoph Lameter <cl@linux.com>
Subject: Re: SLUB warning in netfilter code on shutdown
Date: Tue, 8 May 2012 10:33:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205081030020.27713@router.home>
References: <20120508111924.GA14174@otc-wbsnb-06> <20120508112236.GA15404@otc-wbsnb-06>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20120508112236.GA15404@otc-wbsnb-06>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 8 May 2012, Kirill A. Shutemov wrote:

> On Tue, May 08, 2012 at 02:19:24PM +0300, Kirill A. Shutemov wrote:
> > Hi,
> >
> > Screenshot attached.
>
> It's v3.4-rc6 on x86_64. Config attached.

Cannot see the bug report but I guess this is a message related to object
remaining on kmem_cache_destroy? We have other reports on that one as
well. The IPI reduction patch introduces a bug in has_cpu_slab().

Modify the return statement to

return c->page || c->partial;
