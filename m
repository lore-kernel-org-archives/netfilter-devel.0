From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Wed, 04 Jun 2008 09:53:22 +0100
Message-ID: <48465802.2010005@gmx.ch>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch> <484541E0.3020900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50772 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751450AbYFDIx0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:53:26 -0400
In-Reply-To: <484541E0.3020900@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Fabian Hugelshofer wrote:
>> Aligns buffers to maximum alignment of architecture to make the cast of
>> char pointers to struct pointers more portable.
>>
>> Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
> 
> They all seem fine to me, but a union might make it look
> a bit nicer :)

In libnfnetlink the union does not make sense, because multiple casts 
are done from the same buffer at different locations.

For libnetfilter-(conntrack|log) the union would be possible:

Original (aligned):
<< code begin >>
char buf[...] __attribute__ ((aligned));
struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

nfnl_fill_hdr(h->nfnlssh, nmh, 0, pf, queuenum, ...);
<< code end >>

Union style:
<< code begin >>
union {
	char buf[...];
	struct nlmsghdr nmh;
} u;

nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, pf, queuenum, ...);
<< code end >>

I can rewrite it like this, if desired...
