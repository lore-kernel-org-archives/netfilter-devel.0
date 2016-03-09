From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Wed, 9 Mar 2016 20:01:21 +0100
Message-ID: <20160309190121.GA12281@salvia>
References: <20160301215243.GA19576@gmail.com>
 <20160302114928.GB3493@salvia>
 <CAKHNQQFDEQ2Wp_rV4TG2OgdayuFJmORdaBhzyAx7VghvjNiBcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54096 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbcCITBc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 14:01:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DDE8D740A
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 20:01:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CEC99DA385
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 20:01:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 26CBEDA385
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 20:01:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFDEQ2Wp_rV4TG2OgdayuFJmORdaBhzyAx7VghvjNiBcg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 07:17:36PM +0530, Shivani Bhardwaj wrote:
> On Wed, Mar 2, 2016 at 5:19 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 02, 2016 at 03:22:43AM +0530, Shivani Bhardwaj wrote:
> >> Add translation for module hop-by-hop to nftables.
> >> Full translation of this match awaits the support for --hbh-opts option.
> >>
> >> Examples:
> >>
> >> $ sudo ip6tables-translate -A INPUT -m hbh --hbh-len 33
> >> nft add rule ip6 filter INPUT hbh hdrlength 33 counter
> >>
> >> $ sudo ip6tables-translate -A INPUT -m hbh ! --hbh-len 33
> >> nft add rule ip6 filter INPUT hbh hdrlength != 33 counter
> >>
> >> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> >> ---
> >>  extensions/libip6t_hbh.c | 17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
> >> index c0389ed..f968036 100644
> >> --- a/extensions/libip6t_hbh.c
> >> +++ b/extensions/libip6t_hbh.c
> >> @@ -164,6 +164,22 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
> >>       print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
> >>  }
> >>
> >> +static int hbh_xlate(const struct xt_entry_match *match,
> >> +                  struct xt_xlate *xl, int numeric)
> >> +{
> >> +     const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
> >> +
> >> +     xt_xlate_add(xl, "hbh ");
> >> +
> >> +     if (optinfo->flags & IP6T_OPTS_LEN) {
> >
> > If no header length is passed, then this will print:
> >
> > nft add rule ip6 filter INPUT hbh counter
> >
> 
> What should be the rule generated in case none of the options is mentioned?
> 
> # iptables-translate -A INPUT -m hbh
> ?

Please, have a look at linux/net/ipv6/netfilter/ip6t_hbh.c and
evaluate what is the behaviour in case -m hbh is passed with not
options.
