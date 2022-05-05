Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94398C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 May 2022 13:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344524AbiEENei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 May 2022 09:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347464AbiEENef (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 May 2022 09:34:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6362618B02
        for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2022 06:30:47 -0700 (PDT)
Date:   Thu, 5 May 2022 15:30:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/4] nft: Fix EPERM handling for extensions
 without rev 0
Message-ID: <YnPRgxocWdlju+Zd@salvia>
References: <20220504103416.19712-1-phil@nwl.cc>
 <20220504103416.19712-5-phil@nwl.cc>
 <YnLfUU8V2G9pY1H7@salvia>
 <YnO+kN5WMlOKbpyl@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnO+kN5WMlOKbpyl@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 05, 2022 at 02:09:52PM +0200, Phil Sutter wrote:
> On Wed, May 04, 2022 at 10:17:21PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, May 04, 2022 at 12:34:16PM +0200, Phil Sutter wrote:
> > > Treating revision 0 as compatible in EPERM case works fine as long as
> > > there is a revision 0 of that extension defined in DSO. Fix the code for
> > > others: Extend the EPERM handling to all revisions and keep the existing
> > > warning for revision 0.
> > > 
> > > Fixes: 17534cb18ed0a ("Improve error messages for unsupported extensions")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  iptables/nft.c                                     | 14 ++++++++++----
> > >  .../shell/testcases/iptables/0008-unprivileged_0   |  6 ++++++
> > >  2 files changed, 16 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/iptables/nft.c b/iptables/nft.c
> > > index 33813ce1b9202..95e6c222682c0 100644
> > > --- a/iptables/nft.c
> > > +++ b/iptables/nft.c
> > > @@ -3510,15 +3510,21 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
> > >  err:
> > >  	mnl_socket_close(nl);
> > >  
> > > -	/* pretend revision 0 is valid -
> > > +	/* ignore EPERM and errors for revision 0 -
> > >  	 * this is required for printing extension help texts as user, also
> > >  	 * helps error messaging on unavailable kernel extension */
> > > -	if (ret < 0 && rev == 0) {
> > > -		if (errno != EPERM)
> > > +	if (ret < 0) {
> > > +		if (errno == EPERM) {
> > > +			fprintf(stderr,
> > > +				"%s: Could not determine whether revision %u is supported, assuming it is.\n",
> > 
> > I'm not sure the user can do much about this error message, to me the
> > revisions concept are developer-only, I don't think we expose this
> > implementation detail in the documentation.
> > 
> > Why warn users in this case?
> 
> You're right, it does not make much sense to be verbose here. I copied
> that error message from libxtables, iptables-legacy does the same if
> socket() fails with EPERM during compatibility check for revisions != 0.
> 
> WDYT, drop both? Leave the one in libxtables alone "for legacy
> purposes"?
> 
> I'd make them debug output, but nft_compatible_revision() does not have
> access to nft_handle which I can't easily change since it is a callback
> in xtables_globals.

If you needs this maybe you can do this before release, there is a
bump in libversion for recent updates in iptables, unless some recent
updates are reworked to be added into xshared.c (at the cost of
slightly increasing size of xtables-multi binaries).

Your call.


