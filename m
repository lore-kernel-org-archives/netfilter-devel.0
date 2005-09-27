From: "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: 2.6.14-rc2-mm1 (Oops, possibly Netfilter related?)
Date: Tue, 27 Sep 2005 11:59:16 -0700
Message-ID: <925820000.1127847556@flay>
References: <20050921222839.76c53ba1.akpm@osdl.org><4338F136.1020404@reub.net> <20050927004410.29ab9c03.akpm@osdl.org>
Reply-To: "Martin J. Bligh" <mbligh@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	"Seth, Rohit" <rohit.seth@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965046AbVI0S7U@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>,
	Reuben Farrelly <reuben-lkml@reub.net>
In-Reply-To: <20050927004410.29ab9c03.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> No, this is simply a warning - the kernel ran out of 1-order pages in the
> page allocator.  There have been several reports of this after
> mm-try-to-allocate-higher-order-pages-in-rmqueue_bulk.patch was merged,
> which was rather expected.
> 
> I've dropped that patch.  Joel Schopp is working on Mel Gorman's patches
> which address fragmentation at this level.  If that code gets there then we
> can take another look at
> mm-try-to-allocate-higher-order-pages-in-rmqueue_bulk.patch.

Me no understand. We're going to deliberately cause fragmentation in order
to defragment it again later ???

M.
