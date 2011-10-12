From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack EILSEQ followed by ENOBUFS
Date: Wed, 12 Oct 2011 18:16:15 +0200
Message-ID: <20111012161615.GA14338@1984>
References: <20111010211702.4a666dfc@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: abirvalg@lavabit.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41106 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1JLQQY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:16:24 -0400
Content-Disposition: inline
In-Reply-To: <20111010211702.4a666dfc@wwwwww-701SD>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 10, 2011 at 09:17:02PM +0000, abirvalg@lavabit.com wrote:
> On Linux wwwwww-701SD 2.6.35-30-generic #59-Ubuntu SMP Tue Aug 30
> 15:58:00 UTC 2011 i686 GNU/Linux
> with libnetfilter-conntrack3 Version: 0.0.101-1 
> 
> Hi, my application uses libnetfiler_conntrack. When I want to set a mark
> on a connection, I 
> nfct_set_attr_* all the necessary fields of struct nf_conntrack* and
> then do
> nfct_query(setmark_handle, NFCT_Q_GET, ct)

If the connection already exists,you have to use NFCT_Q_UPDATE.

> setmark_handle has a callback registered thusly:
>    if ((nfct_callback_register(setmark_handle, NFCT_T_ALL, setmark,
> NULL) == -1)) {perror("cb_reg");}
> 
> So ct object lands here:
> 
> int setmark (enum nf_conntrack_msg_type type, struct nf_conntrack
> *mct,void *data){
>   nfct_set_attr_u32(mct, ATTR_MARK, nfmark_to_set);
>   nfct_query(setmark_handle, NFCT_Q_UPDATE, mct);   ***
>   return NFCT_CB_CONTINUE;
>
> All works fine and dandy and i can see with "conntrack -L" marks being
> set. At times I get EBUSY from nfct_query(...NFCT_Q_GET...) but I
> simply call nfct_query(...NFCT_Q_GET...) again and the query goes
> through.

EBUSY shouldn't happen unless you are playing with the conntrack
flags or trying to assign some conntrack helper.

In that case, I'd need some example code that can trigger this error.

> Until at a seemingly random point, I start getting:
> EILSEQ from nfct_query(...NFCT_Q_GET...) (Invalid or incomplete multibyte  or wide
> character). I don't resend this packet with nfct_query(...NFCT_Q_GET...), From then on every single nfct_query(...NFCT_Q_GET...) returns EILSEQ maybe for a 100 or so queries, until I finally get ENOBUFS and my app hangs.
> Even calling "conntrack -L" at that point hangs - no output displayed
> and prog doesn't return.

> I hope that the line in the code above with *** is not the offending
> one:NFCT_Q_UPDATE doesn't technically require a handle, yet the API says
> it should be there, so I put the handle of this very callback.
> 
> Please let me know if there is any more info I could provide you with. I
> am also willing to install conntrack_dbg package and investigate the
> issue if need be.

Regarding the EILSEQ error:

The second parameter of nfct_open must be 0. However, if you use the
same socket for sending commands and receiving events, then you have
to disable sequence tracking, there is a function in libnfnetlink to
do that.
