From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH v2] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Mon, 24 Nov 2014 13:51:57 +0100
Message-ID: <20141124125157.GA11139@salvia>
References: <20141124095149.17111.54015.stgit@nfdev.cica.es>
 <20141124111251.GA9308@salvia>
 <CAOkSjBj2ejY=rVcGhaBJ7uPP=a_Fzj5qrbnMLtB22P61V_7i9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59641 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaKXMty (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:49:54 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBj2ejY=rVcGhaBJ7uPP=a_Fzj5qrbnMLtB22P61V_7i9Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 01:12:33PM +0100, Arturo Borrero Gonzalez wrote:
> On 24 November 2014 at 12:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> --- a/iptables/xtables-eb.c
> >> +++ b/iptables/xtables-eb.c
> >> @@ -616,6 +616,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
> >>               case 'E': /* Rename chain */
> >>               case 'X': /* Delete chain */
> >>                       /* We allow -N chainname -P policy */
> >> +                     /* XXX: Not in ebtables-compat */
> >>                       if (command == 'N' && c == 'P') {
> >>                               command = c;
> >>                               optind--; /* No table specified */
> >> @@ -1146,9 +1147,15 @@ check_extension: */
> >>       cs.fw.ethproto = htons(cs.fw.ethproto);
> >>
> >>       if (command == 'P') {
> >> -             if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
> >> +             if (selected_chain < 0) {
> >> +                     xtables_error(PARAMETER_PROBLEM,
> >> +                                   "Default policy in user-defined"
> >> +                                   " chains is mandatory RETURN");
> >
> > The intended error should something like:
> >
> > ... , "Policy %s only allowed from base chains", policy);
> >
> > right? I can mangle the patch here. Thanks.
> 
> Ok, thanks.

Applied, thanks.

I have used "Policy XYZ not allowed for user defined chains" so we
basically disable policies from user-defined chains in
ebtables-compat.
