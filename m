From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libipt_icmp: Add translation to nft
Date: Mon, 7 Mar 2016 19:20:54 +0100
Message-ID: <20160307182054.GA6823@salvia>
References: <20160306222442.GA20945@sonyv>
 <20160307171408.GB29573@salvia>
 <20160307180445.GA22851@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58020 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbcCGSU7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:20:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 15226ED069
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:20:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 06B50DA8FB
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:20:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EBEC8DA8F9
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:20:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160307180445.GA22851@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 07:04:46PM +0100, Laura Garcia wrote:
> On Mon, Mar 07, 2016 at 06:14:08PM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Mar 06, 2016 at 11:24:44PM +0100, Laura Garcia Liebana wrote:
> > > Add translation for icmp to nftables. Not supported types in nftables
> > > are: any, network-unreachable, host-unreachable, protocol-unreachable,
> > > port-unreachable, fragmentation-needed, source-route-failed,
> > > network-unknown, host-unknown, network-prohibited, host-prohibited,
> > > TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
> > > host-precedence-violation, precedence-cutoff, network-redirect,
> > > host-redirect, TOS-network-redirect, TOS-host-redirect,
> > > router-advertisement, router-solicitation, ttl-zero-during-transit,
> > > ttl-zero-during-reassembly, ip-header-bad and required-option-missing.
> > > 
> > > Examples:
> > > 
> > > $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j LOG
> > > nft add rule ip filter INPUT icmp type echo-reply counter log level warn
> > > 
> > > $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
> > > nft add rule ip filter INPUT icmp type destination-unreachable counter log level warn
> > > 
> > > $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
> > > nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn
> > > 
> > > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > > ---
> > > v2:
> > > 	- Detection of not supported types in nftables, as Shivani suggested.
> > > 
> > >  extensions/libipt_icmp.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 45 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
> > > index 666e7da..89eb36e 100644
> > > --- a/extensions/libipt_icmp.c
> > > +++ b/extensions/libipt_icmp.c
> > > @@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
> > >  }
> > >  
> > >  static void icmp_print(const void *ip, const struct xt_entry_match *match,
> > > -                       int numeric)
> > > +		       int numeric)
> > >  {
> > >  	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
> > >  
> > > @@ -249,6 +249,49 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
> > >  	}
> > >  }
> > >  
> > > +static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
> > > +			     unsigned int code_min, unsigned int code_max)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	if (code_min == code_max)
> > > +		return 0;
> > > +
> > > +	switch (icmptype) {
> > > +	case 0xFF:
> > > +	case 9:
> > > +	case 10:
> > 
> > Why are we skipping these here?
> > 
> 
> These are types which doesn't seem to be supported by nftables: any,
> router-advertisement and router-solicitation, so in this case we would
> return a 0 in order to indicate that the translation is not supported.

I think you can add these two to icmp_type_tbl in nft/src/proto.c, it
would be just a two-liner to support ICMP_ROUTERADVERT and
ICMP_ROUTERSOLICIT.

Regarding 'any', you can just skip translating this. From ip_tables
kernel code I can see this just return true in case 0xff is specified.
so the right translation to me is not to print anything.

> > > +		return 0;
> > > +	default:
> > > +		for (i = 0; ARRAY_SIZE(icmp_codes); ++i)
> > 
> > Missing bracket here.
> > 
> > > +			if (icmp_codes[i].type == icmptype &&
> > > +			    icmp_codes[i].code_min == code_min &&
> > > +			    icmp_codes[i].code_max == code_max)
> > > +				break;
> > > +
> > > +			xt_xlate_add(xl, icmp_codes[i].name);
> > 
> > Same thing. But as I said in the previous patch, are you sure you need
> > this code snippet above at this stage?
> > 
> 
> The brackets are not missing here, sorry for the confusion. Inside the for
> statement we only have the condition. Just the xt_late_add function indentation is not correct.

OK, makes sense.

Then fix this broken indent and resubmit a v2, thanks Laura.
