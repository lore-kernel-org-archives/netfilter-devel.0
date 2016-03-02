From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_sctp: Add translation to nft
Date: Wed, 2 Mar 2016 16:10:05 +0100
Message-ID: <20160302151005.GA5844@salvia>
References: <20160301204056.GA18229@gmail.com>
 <20160302114826.GA3493@salvia>
 <20160302115453.GA4365@salvia>
 <CAKHNQQHaEwP1u0eSzjMnQ2Zc1heLLiHoSYJ+-i4-QP=qBuwzew@mail.gmail.com>
 <alpine.LSU.2.20.1603021539140.17720@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52152 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbcCBPKM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 10:10:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3AC4180FE
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:10:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B64ADA388
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:10:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C8367DA388
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:10:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603021539140.17720@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 03:47:32PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2016-03-02 15:14, Shivani Bhardwaj wrote:
> >>
> >> This crazy thing seems to be valid:
> >>
> >>         iptables -I INPUT -p sctp -m sctp
> 
> This is how all protocols are loaded. It can be readily seen
> in a iptables-save dump. One tests the L3 header field, the other
> loads the module for further options to do tests on L4 fields.
> 
> >>
> >> and this will be translated as:
> >>
> >>         nft add rule filter INPUT ip protocol sctp sctp
> 
> that seems correct, does it not?

That translation is not correct in nft:

# nft add rule filter INPUT ip protocol sctp sctp
<cmdline>:1:44-44: Error: syntax error, unexpected end of file,
expecting checksum or sport or dport or vtag
add rule filter INPUT ip protocol sctp sctp
