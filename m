From: Laura Garcia <nevola@gmail.com>
Subject: Re: [Outreachy kernel] [PATCH] extensions: libxt_statistic: Add
 translation to nft
Date: Tue, 1 Mar 2016 16:49:36 +0100
Message-ID: <20160301154935.GA3838@sonyv>
References: <20160229212216.GA29706@sonyv>
 <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37256 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbcCAPtm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:49:42 -0500
Received: by mail-wm0-f46.google.com with SMTP id p65so39471410wmp.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 07:49:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 03:21:24PM +0530, Shivani Bhardwaj wrote:
> On Tue, Mar 1, 2016 at 2:52 AM, Laura Garcia Liebana <nevola@gmail.com> wrote:
> 
> Hi Laura,
> 
> > Add translation for random to nftables.
> >
> Here, you are providing translation for module statistic, random is
> just a mode for matching the rule. Please make sure to use correct
> module name in the commit message next time.
> 

Hi Shivani,

The translation is only for random due to the mode nth is not implemented in nft yet.


> > Examples:
> >
> > $ iptables-translate -A INPUT -m statistic --mode random --probability
> > 0.1 -j ACCEPT
> > nft add rule ip filter INPUT meta random 0.10000000009 counter accept
> >
> > $ iptables-translate -A INPUT -m statistic --mode random ! --probability
> > 0.1 -j ACCEPT
> > nft add rule ip filter INPUT meta random != 0.10000000009 counter accept
> >
> 
> The match statistic is not yet supported in nftables, so these
> translations are not going to work. You can track the supported
> extensions here:
> http://wiki.nftables.org/wiki-nftables/index.php/Supported_features_compared_to_xtables,
> you can edit any discrepancies you find on this page.
> 

The nf-next branch includes the random feature and it's working perfectly for me. Should I have to update something in the wiki?


> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > ---
> >  extensions/libxt_statistic.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
> > index b6ae5f5..95d588c 100644
> > --- a/extensions/libxt_statistic.c
> > +++ b/extensions/libxt_statistic.c
> > @@ -133,6 +133,20 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
> >         print_match(info, "--");
> >  }
> >
> > +static int statistic_xlate(const struct xt_entry_match *match,
> > +                          struct xt_xlate *xl, int numeric)
> > +{
> > +       const struct xt_statistic_info *info = (void *)match->data;
> > +
> > +       if (info->mode == XT_STATISTIC_MODE_RANDOM) {
> > +               xt_xlate_add(xl, "meta random%s %.11f ",
> > +                            (info->flags & XT_STATISTIC_INVERT) ? " !=" : "",
> > +                            1.0 * info->u.random.probability / 0x80000000);
> > +       }
> > +
> > +       return 1;
> > +}
> > +
> >  static struct xtables_match statistic_match = {
> >         .family         = NFPROTO_UNSPEC,
> >         .name           = "statistic",
> > @@ -145,6 +159,7 @@ static struct xtables_match statistic_match = {
> >         .print          = statistic_print,
> >         .save           = statistic_save,
> >         .x6_options     = statistic_opts,
> > +       .xlate          = statistic_xlate,
> >  };
> >
> The way you've written the code to carry out the translation is correct.

Ok, thanks for your confirmation.

> Please make sure to check your patches with checkpatch to avoid coding
> style errors.
> 

Sure,

Thanks!

> Thanks,
> Shivani
> 
> >  void _init(void)
> > --
> > 2.7.0
> >
> > --
> > You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> > To post to this group, send email to outreachy-kernel@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20160229212216.GA29706%40sonyv.
> > For more options, visit https://groups.google.com/d/optout.
