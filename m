From: <abirvalg@lavabit.com>
Subject: Re: conntrack EILSEQ followed by ENOBUFS
Date: Thu, 13 Oct 2011 11:11:46 +0000
Message-ID: <20111013111146.57c563e2@wwwwww-701SD>
References: <20111010211702.4a666dfc@wwwwww-701SD>
 <20111012161615.GA14338@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:40415 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1JMIMQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:12:16 -0400
Received: from a.earth.lavabit.com (a.earth.lavabit.com [192.168.111.10])
	by karen.lavabit.com (Postfix) with ESMTP id F1CEF11BB3C
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2011 03:12:15 -0500 (CDT)
Received: from wwwwww-701sd (62.63.182.28)
	by lavabit.com with ESMTP id N4FMM96LIEBW
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2011 03:12:15 -0500
In-Reply-To: <20111012161615.GA14338@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gracias for responding, Pablo.
My problem has now scaled down by 50%. EILSEQ happened due to a race when 2 threads in my app set_attr* to the same stuct nf_conntrack simultaneously.
I only have EBUSY error occasionally. I now upgraded to libnetfilter_conntrack 0.9.1 and the frequency of EBUSY has dropped significantly. I seed a torrent which creates 30 NEW connections per second and leave the machine running for 24  hours.
I put a mark on each of those NEW connection.  I only got 1 EBUSY so far.

Please let me know if you are still interested in getting to the bottom of that 1 EBUSY per 24 hours.

>EBUSY shouldn't happen unless you are playing with the conntrack
>flags or trying to assign some conntrack helper.
>In that case, I'd need some example code that can trigger this error.

No, I don't have any conntrack helpers. And I'm not touching any conntrack flags. Just doing nfct_query(...NFCT_Q_GET...).

Regards.




On Wed, 12 Oct 2011 18:16:15 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Mon, Oct 10, 2011 at 09:17:02PM +0000, abirvalg@lavabit.com wrote:
> > On Linux wwwwww-701SD 2.6.35-30-generic #59-Ubuntu SMP Tue Aug 30
> > 15:58:00 UTC 2011 i686 GNU/Linux
> > with libnetfilter-conntrack3 Version: 0.0.101-1 
> > 
> > Hi, my application uses libnetfiler_conntrack. When I want to set a mark
> > on a connection, I 
> > nfct_set_attr_* all the necessary fields of struct nf_conntrack* and
> > then do
> > nfct_query(setmark_handle, NFCT_Q_GET, ct)
> 
> If the connection already exists,you have to use NFCT_Q_UPDATE.
> 
> > setmark_handle has a callback registered thusly:
> >    if ((nfct_callback_register(setmark_handle, NFCT_T_ALL, setmark,
> > NULL) == -1)) {perror("cb_reg");}
> > 
> > So ct object lands here:
> > 
> > int setmark (enum nf_conntrack_msg_type type, struct nf_conntrack
> > *mct,void *data){
> >   nfct_set_attr_u32(mct, ATTR_MARK, nfmark_to_set);
> >   nfct_query(setmark_handle, NFCT_Q_UPDATE, mct);   ***
> >   return NFCT_CB_CONTINUE;
> >
> > All works fine and dandy and i can see with "conntrack -L" marks being
> > set. At times I get EBUSY from nfct_query(...NFCT_Q_GET...) but I
> > simply call nfct_query(...NFCT_Q_GET...) again and the query goes
> > through.
> 
> EBUSY shouldn't happen unless you are playing with the conntrack
> flags or trying to assign some conntrack helper.
> 
> In that case, I'd need some example code that can trigger this error.
> 
> > Until at a seemingly random point, I start getting:
> > EILSEQ from nfct_query(...NFCT_Q_GET...) (Invalid or incomplete multibyte  or wide
> > character). I don't resend this packet with nfct_query(...NFCT_Q_GET...), From then on every single nfct_query(...NFCT_Q_GET...) returns EILSEQ maybe for a 100 or so queries, until I finally get ENOBUFS and my app hangs.
> > Even calling "conntrack -L" at that point hangs - no output displayed
> > and prog doesn't return.
> 
> > I hope that the line in the code above with *** is not the offending
> > one:NFCT_Q_UPDATE doesn't technically require a handle, yet the API says
> > it should be there, so I put the handle of this very callback.
> > 
> > Please let me know if there is any more info I could provide you with. I
> > am also willing to install conntrack_dbg package and investigate the
> > issue if need be.
> 
> Regarding the EILSEQ error:
> 
> The second parameter of nfct_open must be 0. However, if you use the
> same socket for sending commands and receiving events, then you have
> to disable sequence tracking, there is a function in libnfnetlink to
> do that.

