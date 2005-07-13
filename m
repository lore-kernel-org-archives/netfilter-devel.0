From: Chris Wright <chrisw@osdl.org>
Subject: Re: 2.6.12 netfilter: local packets marked as invalid
Date: Tue, 12 Jul 2005 17:16:08 -0700
Message-ID: <20050713001608.GE19052@shell0.pdx.osdl.net>
References: <42CE8E96.1040905@trash.net> <42CEA5E4.40009@gentoo.org> <42D3B063.3000207@trash.net> <20050712.115835.42775885.davem@davemloft.net> <20050712191945.GL9153@shell0.pdx.osdl.net> <42D44A45.3040301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Wright <chrisw@osdl.org>,
	"David S. Miller" <davem@davemloft.net>, dsd@gentoo.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262402AbVGMASX@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42D44A45.3040301@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy (kaber@trash.net) wrote:
> Chris Wright wrote:
> >* David S. Miller (davem@davemloft.net) wrote:
> >
> >>Now the question is what to do about the 2.6.12.x stable
> >>tree.  I think we put the offending change there, now we
> >>need to revert it there too.  Patrick, could you push this
> >>patch to stable@kernel.org so we can resolve that too?
> >
> >There's the first fix in the queue, I can either drop that one, or
> >patch on top of it.  Dropping what's in the queue[1] is fine for me.
> >Below's the backport that Daniel sent over this morning (which applies
> >if I drop what's in the queue).  Patrick, does that look ok?  I didn't
> >queue this change yet, as I'd prefer it came either from you or with you
> >Cc'd so you can ack it.
> >
> >[1] 
> >http://www.kernel.org/git/?p=linux/kernel/git/chrisw/stable-queue.git;a=blob;h=77843604cf9af8cf5458d97eb56d5346e6d380b3;hb=9aaf5aa7c4e4b8309997d2b433bf7464280799eb;f=queue/netfilter-connection-tracking.patch
> 
> Daniel's patch is fine, thanks.
> 
> ACKed-by: Patrick McHardy <kaber@trash.net>

Great, thanks.
-chris
