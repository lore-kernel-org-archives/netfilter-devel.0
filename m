From: <abirvalg@lavabit.com>
Subject: conntrack EILSEQ followed by ENOBUFS
Date: Mon, 10 Oct 2011 21:17:02 +0000
Message-ID: <20111010211702.4a666dfc@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:46185 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1JJSRM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:17:12 -0400
Received: from d.earth.lavabit.com (d.earth.lavabit.com [192.168.111.13])
	by karen.lavabit.com (Postfix) with ESMTP id 7034211BC44
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Oct 2011 13:17:12 -0500 (CDT)
Received: from wwwwww-701sd (46.109.128.58)
	by lavabit.com with ESMTP id F4B4WV0F6TTU
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Oct 2011 13:17:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Linux wwwwww-701SD 2.6.35-30-generic #59-Ubuntu SMP Tue Aug 30
15:58:00 UTC 2011 i686 GNU/Linux
with libnetfilter-conntrack3 Version: 0.0.101-1 

Hi, my application uses libnetfiler_conntrack. When I want to set a mark
on a connection, I 
nfct_set_attr_* all the necessary fields of struct nf_conntrack* and
then do
nfct_query(setmark_handle, NFCT_Q_GET, ct)

setmark_handle has a callback registered thusly:
   if ((nfct_callback_register(setmark_handle, NFCT_T_ALL, setmark,
NULL) == -1)) {perror("cb_reg");}

So ct object lands here:

int setmark (enum nf_conntrack_msg_type type, struct nf_conntrack
*mct,void *data){
  nfct_set_attr_u32(mct, ATTR_MARK, nfmark_to_set);
  nfct_query(setmark_handle, NFCT_Q_UPDATE, mct);   ***
  return NFCT_CB_CONTINUE;
}

All works fine and dandy and i can see with "conntrack -L" marks being
set. At times I get EBUSY from nfct_query(...NFCT_Q_GET...) but I simply call nfct_query(...NFCT_Q_GET...) again and the query goes through.
Until at a seemingly random point, I start getting:
EILSEQ from nfct_query(...NFCT_Q_GET...) (Invalid or incomplete multibyte  or wide
character). I don't resend this packet with nfct_query(...NFCT_Q_GET...), From then on every single nfct_query(...NFCT_Q_GET...) returns EILSEQ maybe for a 100 or so queries, until I finally get ENOBUFS and my app hangs.
Even calling "conntrack -L" at that point hangs - no output displayed
and prog doesn't return.

I hope that the line in the code above with *** is not the offending
one:NFCT_Q_UPDATE doesn't technically require a handle, yet the API says
it should be there, so I put the handle of this very callback.

Please let me know if there is any more info I could provide you with. I
am also willing to install conntrack_dbg package and investigate the
issue if need be.
Thanks.

