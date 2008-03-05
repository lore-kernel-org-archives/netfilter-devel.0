From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] mm/slab.c - use angle brackets for include
Date: Wed, 05 Mar 2008 13:18:20 -0800
Message-ID: <1204751900.17370.72.camel@localhost>
References: <1204678035.5180.94.camel@localhost>
	 <47CEEFF4.7080605@cs.helsinki.fi>
	 <Pine.LNX.4.64.0803051206160.30357@schroedinger.engr.sgi.com>
	 <1204748782.17370.47.camel@localhost>
	 <Pine.LNX.4.64.0803051250440.30634@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803051250440.30634@schroedinger.engr.sgi.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2008-03-05 at 12:53 -0800, Christoph Lameter wrote:
> On Wed, 5 Mar 2008, Joe Perches wrote:
> > net/netfilter/nf_conntrack_extend.c:26:#include <linux/kmalloc_sizes.h>
> Urgh look at that:

:) at least it's noted as "horrible".

> Guess we need to define a constant KMALLC_MIN_SIZE in include/sl?b_def.h 
> to get rid of this hack?

Seems a likely idea, but maybe netfilter shouldn't bother
with a minimum?

