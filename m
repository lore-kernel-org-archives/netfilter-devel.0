From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] workqueue: convert
 cancel_rearming_delayed_work[queue]() users to cancel_delayed_work_sync()
Date: Tue, 14 Dec 2010 11:52:13 -0800
Message-ID: <20101214195213.GA9965@suse.de>
References: <4D078B6D.5060202@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com,
	benh@kernel.crashing.org, mchehab@infradead.org,
	davem@davemloft.net, netdev@vger.kernel.org, cbou@mail.ru,
	dwmw2@infradead.org, zbr@ioremap.net, bfields@fieldses.org,
	neilb@suse.de, aelder@sgi.com, xfs-masters@oss.sgi.com,
	cl@linux-foundation.org, penberg@cs.helsinki.fi,
	akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
	Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D078B6D.5060202@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Dec 14, 2010 at 04:21:17PM +0100, Tejun Heo wrote:
> cancel_rearming_delayed_work[queue]() has been superceded by
> cancel_delayed_work_sync() quite some time ago.  Convert all the
> in-kernel users.  The conversions are completely equivalent and
> trivial.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

