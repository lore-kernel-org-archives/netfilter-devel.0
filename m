From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Wed, 1 Mar 2017 17:45:53 +0100
Message-ID: <20170301164553.GA8809@salvia>
References: <044a666e507a829f8c1d6dcc19ad78cd9f140ddd.1488142060.git.rgb@redhat.com>
 <CAHC9VhTUSz-tyPyZ7PJAH08sfhuACeUTkEKEnnwM_axQ4UdorQ@mail.gmail.com>
 <20170301162802.GV18258@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paul Moore <paul@paul-moore.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753000AbdCAQqD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 11:46:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4075EE650
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 17:45:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30769DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 17:45:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F95CDA841
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 17:45:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170301162802.GV18258@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 01, 2017 at 11:28:02AM -0500, Richard Guy Briggs wrote:
> On 2017-02-28 17:22, Paul Moore wrote:
> > On Sun, Feb 26, 2017 at 3:49 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Eliminate flipping in and out of message fields, dropping fields in the process.
> > >
> > > Sample raw message format IPv4 UDP:
> > > type=NETFILTER_PKT msg=audit(1487874761.386:228):  mark=0xae8a2732 saddr=127.0.0.1 daddr=127.0.0.1 proto=17^]
> > > Sample raw message format IPv6 ICMP6:
> > > type=NETFILTER_PKT msg=audit(1487874761.381:227):  mark=0x223894b7 saddr=::1 daddr=::1 proto=58^]
> > >
> > > Issue: https://github.com/linux-audit/audit-kernel/issues/11
> > > Test case: https://github.com/linux-audit/audit-testsuite/issues/43
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  net/netfilter/xt_AUDIT.c |  122 ++++++++++-----------------------------------
> > >  1 files changed, 27 insertions(+), 95 deletions(-)
> > >
> > > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> > > index 4973cbd..945fa29 100644
> > > --- a/net/netfilter/xt_AUDIT.c
> > > +++ b/net/netfilter/xt_AUDIT.c
> > > @@ -31,146 +31,78 @@ MODULE_ALIAS("ip6t_AUDIT");
> > 
> > ...
> > 
> > > -static void audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> > > +static bool audit_ip4(struct audit_buffer *ab, struct sk_buff *skb)
> > >  {
> > >         struct iphdr _iph;
> > >         const struct iphdr *ih;
> > >
> > >         ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
> > 
> > It seems like we should be using skb_network_offset(skb) instead of 0
> > above, yes?  Granted, this isn't new, but let's fix it.
> 
> Yes, I agree.  How does this even work now?  Maybe the MAC header hasn't
> been added yet (or has already been processed and stripped off) so that
> skb->data is already pointing at the network header and hence has an
> offset of 0.  Can you be more explicit and elaborate to say if this what
> you were thinking?

skb_header_pointer() takes data from skb->data and packet flowing
through netfilter are guaranteed to find the network header at
skb->data.
