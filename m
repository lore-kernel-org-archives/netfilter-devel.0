From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: EILSEQ with libnetfilter_conntrack on multi-threaded app
Date: Thu, 9 Feb 2012 16:54:45 +0100
Message-ID: <20120209155445.GA5951@1984>
References: <20120208132736.0f893b57@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: abirvalg@lavabit.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46643 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2BIPyw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:54:52 -0500
Content-Disposition: inline
In-Reply-To: <20120208132736.0f893b57@wwwwww-701SD>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 08, 2012 at 01:27:36PM +0000, abirvalg@lavabit.com wrote:
> My multi-threaded app makes heavy use of libnetfilter_conntrack.
> After running properly for a number of hours, at a certain point which I am not able to reproduce a call to conntrack function does not return for good 10 secs, CPU usage of my process spikes to 80% and running conntrack -L from terminal freezes. When the conntrack function returns with retval EILSEQ,  CPU usage drops, conntrack -L unfreezes an dumps the output.
> 
> The code in question does:
> 
> nfct_query(setmark_handle_out, NFCT_Q_GET, ct_out_udp)
> 
> where setmark_handle_out was previously linked to this function
> 
> int setmark_out (enum nf_conntrack_msg_type type, struct nf_conntrack *mct,void *data)
> {
>   nfct_set_attr_u32(mct, ATTR_MARK, nfmark_to_set_out);
>   nfct_query(setmark_handle_out, NFCT_Q_UPDATE, mct);  ***
>   return NFCT_CB_CONTINUE;
> }
>  
> nfmark_to_set_out is a global variable
> 
> ***Could this line be the offending one? As I understand, when issuing NFCT_Q_UPDATE, indicating an nfct_handle is just a formality - any handle can be given as an argument, so I'm simply reusing an existing handle.
> 
> I really want to get to the bottom of this issue. Please let me know what other actions I can perform to produce some valuable debuginfo.
> I'm actually right now keeping the process suspended in gdb, because the issue takes many hours to reproduce.
> 
> Here's the link to the offending line 3514 in my project's webgit:
> http://leopardflower.git.sourceforge.net/git/gitweb.cgi?p=leopardflower/leopardflower;a=blob;f=lpfw.c;h=c7af69c1def30d1a18e1bf839acbb60064ee3ba2;hb=709b1e87cf17e6e6e9d8a908ad8a6b77359f1d69#l3514
> 
> Thanks.
> 
> P.S.
> Please CC me when responding to this
> 
> P.P.S.
> I already posted a similar issue on this mailing list
> http://marc.info/?t=131827063700008&r=1&w=2	
> 
> Back then Pablo responded with:
> /quote
> Regarding the EILSEQ error:
> 
> The second parameter of nfct_open must be 0. However, if you use the
> same socket for sending commands and receiving events, then you have
> to disable sequence tracking, there is a function in libnfnetlink to
> do that.
> /unquote
> 
> My code does call nfct_open with 0.

OK.

> Is the note above that I marked with *** a case of using the same socket for sending commands and receiving events?

Let me make this more generic:

If you use the same netlink socket to send and to receive data using
multiple thread/processes, then you have to disable sequence tracking.

This seems to be your case. Basically, a race condition may occur
following this steps:

1) you send a get command from process/thread h1 with seqnum S1.
2) you send an update command from process/thread h2 with seqnum S2.
3) you get the reply for get command, libnfnetlink sequence checks for
S2 but it gets S1. So it hits EILSEQ.

libnfnetlink sequence tracking is not thread safe. This is fixed by
libmnl. I'm still porting libnetfilter_* friends to libmnl, but this
will take time. So your solution is to disable sequence tracking in
libnfnetlink.
