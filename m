From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [libnetfilter_log PATCH 2/3] Convert kernel to stdint types
Date: Sun, 14 Jun 2015 20:43:51 +0200
Message-ID: <20150614184351.GA24373@euler>
References: <20150516113828.GR14201@euler>
 <20150527122249.GB17945@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:53081 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbFNSoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2015 14:44:15 -0400
Content-Disposition: inline
In-Reply-To: <20150527122249.GB17945@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> On Sat, May 16, 2015 at 01:41:49PM +0200, Felix Janda wrote:
> > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> > ---
> >  include/libnetfilter_log/linux_nfnetlink_log.h | 42 +++++++++++++-------------
> >  1 file changed, 21 insertions(+), 21 deletions(-)
> > 
> > diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
> > index 9f38277..c647581 100644
> > --- a/include/libnetfilter_log/linux_nfnetlink_log.h
> > +++ b/include/libnetfilter_log/linux_nfnetlink_log.h
> > @@ -20,31 +20,31 @@ enum nfulnl_msg_types {
> >  };
> >  
> >  struct nfulnl_msg_packet_hdr {
> > -	__be16		hw_protocol;	/* hw protocol (network order) */
> > -	__u8	hook;		/* netfilter hook */
> > -	__u8	_pad;
> > +	uint16_t		hw_protocol;	/* hw protocol (network order) */
> > +	uint8_t	hook;		/* netfilter hook */
> > +	uint8_t	_pad;
> >  };
> 
> I have skipped this patch in this series. It is mangling a cached
> header from the kernel, I guess there must be a way to make musl happy
> without this change given that we follow the same approach in other
> libraries.
> 
> Thanks.

Yes, the conversion of types is not strictly necessary. As long as
<linux/types.h> is included, everything is fine for musl. I have likely
misunderstood your previous mail. Feel free to ignore patches mangling
kernel headers after updating them.

Thanks for your review and pushing of patches so far!

Felix
