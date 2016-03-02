From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_sctp: Add translation to nft
Date: Wed, 2 Mar 2016 16:20:37 +0100
Message-ID: <20160302152037.GC5844@salvia>
References: <20160301204056.GA18229@gmail.com>
 <20160302114826.GA3493@salvia>
 <20160302115453.GA4365@salvia>
 <CAKHNQQHaEwP1u0eSzjMnQ2Zc1heLLiHoSYJ+-i4-QP=qBuwzew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbcCBPUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 10:20:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D296A9D33A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:20:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7ABFDA8F9
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:20:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2024DDA38B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:20:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQHaEwP1u0eSzjMnQ2Zc1heLLiHoSYJ+-i4-QP=qBuwzew@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 07:44:51PM +0530, Shivani Bhardwaj wrote:
> On Wed, Mar 2, 2016 at 5:24 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 02, 2016 at 12:48:26PM +0100, Pablo Neira Ayuso wrote:
> >> On Wed, Mar 02, 2016 at 02:10:56AM +0530, Shivani Bhardwaj wrote:
> >> > Add translation for sctp to nftables.
> >> > Full translation of this match awaits the support for --chunk-types
> >> > option.
> >>
> >> Please, keep this documented in the wiki too so we remember there is a
> >> partial translation for this.
> >>
> >> > Examples:
> >> >
> >> > $ sudo iptables-translate -A INPUT -p sctp --dport 80 -j DROP
> >> > nft add rule ip filter INPUT sctp dport 80 counter drop
> >> >
> >> > $ sudo iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
> >> > nft add rule ip filter INPUT sctp sport != 80-100 counter accept
> >>
> >> Applied, thanks Shivani.
> >
> > Sorry, I have to keep this back.
> >
> > This crazy thing seems to be valid:
> >
> >         iptables -I INPUT -p sctp -m sctp
> >
> > and this will be translated as:
> >
> >         nft add rule filter INPUT ip protocol sctp sctp
> 
> dmesg shows me
> 
> x_tables: ip_tables: sctp match: only valid for protocol 132

This happens when:

        iptables -I INPUT -m sctp

> means sctp match is valid for sctp protocol. There should not be an
> sctp match (correct me if I am wrong here), should this be on
> bugzilla?

What I suggest is this:

        const struct xt_sctp_info *einfo =
               (const struct xt_sctp_info *)match->data;

        if (!einfo->flags) <------
                return 0;

        xt_xlate_add(xl, "sctp ");
        if (einfo->flags & XT_SCTP_SRC_PORTS) {

Just skip if there is not flags set.
