From: <abirvalg@lavabit.com>
Subject: EILSEQ with libnetfilter_conntrack on multi-threaded app
Date: Wed, 8 Feb 2012 13:27:36 +0000
Message-ID: <20120208132736.0f893b57@wwwwww-701SD>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:36161 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab2BHL2s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:28:48 -0500
Received: from b.earth.lavabit.com (b.earth.lavabit.com [192.168.111.11])
	by karen.lavabit.com (Postfix) with ESMTP id 465FE11B867
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2012 05:28:48 -0600 (CST)
Received: from wwwwww-701sd (46.109.128.192)
	by lavabit.com with ESMTP id 1CKBEID5ISTI
	for <netfilter-devel@vger.kernel.org>; Wed, 08 Feb 2012 05:28:48 -0600
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

My multi-threaded app makes heavy use of libnetfilter_conntrack.
After running properly for a number of hours, at a certain point which I am not able to reproduce a call to conntrack function does not return for good 10 secs, CPU usage of my process spikes to 80% and running conntrack -L from terminal freezes. When the conntrack function returns with retval EILSEQ,  CPU usage drops, conntrack -L unfreezes an dumps the output.

The code in question does:

nfct_query(setmark_handle_out, NFCT_Q_GET, ct_out_udp)

where setmark_handle_out was previously linked to this function

int setmark_out (enum nf_conntrack_msg_type type, struct nf_conntrack *mct,void *data)
{
  nfct_set_attr_u32(mct, ATTR_MARK, nfmark_to_set_out);
  nfct_query(setmark_handle_out, NFCT_Q_UPDATE, mct);  ***
  return NFCT_CB_CONTINUE;
}
 
nfmark_to_set_out is a global variable

***Could this line be the offending one? As I understand, when issuing NFCT_Q_UPDATE, indicating an nfct_handle is just a formality - any handle can be given as an argument, so I'm simply reusing an existing handle.

I really want to get to the bottom of this issue. Please let me know what other actions I can perform to produce some valuable debuginfo.
I'm actually right now keeping the process suspended in gdb, because the issue takes many hours to reproduce.

Here's the link to the offending line 3514 in my project's webgit:
http://leopardflower.git.sourceforge.net/git/gitweb.cgi?p=leopardflower/leopardflower;a=blob;f=lpfw.c;h=c7af69c1def30d1a18e1bf839acbb60064ee3ba2;hb=709b1e87cf17e6e6e9d8a908ad8a6b77359f1d69#l3514

Thanks.

P.S.
Please CC me when responding to this

P.P.S.
I already posted a similar issue on this mailing list
http://marc.info/?t=131827063700008&r=1&w=2	

Back then Pablo responded with:
/quote
Regarding the EILSEQ error:

The second parameter of nfct_open must be 0. However, if you use the
same socket for sending commands and receiving events, then you have
to disable sequence tracking, there is a function in libnfnetlink to
do that.
/unquote

My code does call nfct_open with 0.
Is the note above that I marked with *** a case of using the same socket for sending commands and receiving events?

