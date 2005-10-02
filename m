From: Paul Jackson <pj@sgi.com>
Subject: Re: 2.6.14-rc2-mm1 (Oops, possibly Netfilter related?)
Date: Sun, 2 Oct 2005 10:13:19 -0700
Message-ID: <20051002101319.659afcde.pj@sgi.com>
References: <20050921222839.76c53ba1.akpm@osdl.org>
	<4338F136.1020404@reub.net>
	<20050927004410.29ab9c03.akpm@osdl.org>
	<925820000.1127847556@flay>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: akpm@osdl.org, reuben-lkml@reub.net, linux-kernel@vger.kernel.org,
	netfilter-devel@lists.netfilter.org, rohit.seth@intel.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751130AbVJBRNj@vger.kernel.org>
To: "Martin J. Bligh" <mbligh@mbligh.org>
In-Reply-To: <925820000.1127847556@flay>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Martin, responding to Andrew:
> > I've dropped that patch.  Joel Schopp is working on Mel Gorman's patches
> > which address fragmentation at this level.  If that code gets there then we
> > can take another look at
> > mm-try-to-allocate-higher-order-pages-in-rmqueue_bulk.patch.
> 
> Me no understand. We're going to deliberately cause fragmentation in order
> to defragment it again later ???

I thought that the patches of Mel Gorman and Joel Schopp were reducing
fragmentation, not causing it.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
