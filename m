From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC] nftables: fix surpression of "permission denied"
 errors
Date: Thu, 9 Jan 2014 18:52:37 +0000
Message-ID: <20140109185235.GA4205@macbook.localnet>
References: <20140108205813.GA5186@macbook.localnet>
 <20140109174025.GA18767@localhost>
 <20140109180141.GA5360@macbook.localnet>
 <20140109184821.GA19233@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51757 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAISwo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:52:44 -0500
Content-Disposition: inline
In-Reply-To: <20140109184821.GA19233@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 09, 2014 at 07:48:21PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 09, 2014 at 06:01:41PM +0000, Patrick McHardy wrote:
> > On Thu, Jan 09, 2014 at 06:40:25PM +0100, Pablo Neira Ayuso wrote:
> 
> > > One error message per line can be too much if we have a big batch,
> > > perhaps we can just point to the first rule in the batch and print
> > > something like: "7 error suppressed.", similar to syslog, where 7 is
> > > the number of rules that follow up after EPERM message.
> > 
> > Well, this was done to stay consistent with any other error type.
> > We could compress similar errors, but there are a few things to
> > consider. One is that it might be hard to point to the correct
> > spot(s) in the error message. Also the output format was chosen to
> > be similar to gcc so f.i. vi could easily jump to rules causing
> > errors in a file. For now I think we should apply this patch, which
> > will treat EPERM like any other error, and then work on something
> > to reduce the output.
> 
> Let's do that, this case is very specific of EPERM. Please, push it to
> master.

Will do.

> > > BTW, with really really big batches, the kernel may fail to allocate
> > > the acknowledgment. We discussed this already with David, and he
> > > thinks it doesn't make sense to send such a big message back to
> > > sender. We can add:
> > > 
> > >  void netlink_ack_len(struct sk_buff *in_skb, struct nlmsghdr *nlh,
> > >                       int err, int len)
> > > 
> > > where len specifies the length would be the original netlink header +
> > > nfnetlink header, so the rules are not sent back to userspace.
> > > 
> > > Let me know, thanks!
> > 
> > Why would it depend on the size of the batch? The errors are allocated
> > for every single message *within* the batch.
> 
> I was refering to the EPERM case and NFNL_MSG_BATCH_BEGIN.

Right. The easy solution would be to move the capable() check to
within batch processing. Processing NFNL_MSG_BATCH_BEGIN obviously
doesn't require special permissions.

> > I agree though that if we can allocate a smaller message without the
> > full contents, this is still better than using sk_err. But I guess
> > that should simply be fallback behaviour of netlink_ack() instead of
> > specifying a length.
> 
> Jamal mentioned that capping can be a possibility (like in ICMP
> errors), but I think David prefered to remove the entire payload. The
> sequence number already refers to the original message so we can
> correlate it with what we have sent. Perhaps netlink_ack() can default
> to that behaviour if it fails to allocate the skbuff, ie. try to
> allocate a small one just containing the netlink error header.

Yes, that's what I meant. This should of course only be the fallback
after failing to allocate the entire message and before resorting to
sk_err. I still dream of being able to pass the offset of the
attribute triggering an error back to userspace to very precisely
point to the error.

> However, the current approach, the length of the begin message is just
> the netlink header + nfnetlink header, so we're not getting a large
> skbuff back in this error case either, so I don't find any path we can
> get big ack messages in nfnetlink at this moment, we can archive this
> problem.

Ok perfect, so no changes required at all :)
