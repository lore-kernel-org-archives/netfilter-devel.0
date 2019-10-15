Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17EEC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 16:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46D920872
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 16:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbfJOQzX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:55:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:37204 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfJOQzX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 12:55:23 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iKPnF-0008Nj-IE; Tue, 15 Oct 2019 18:35:29 +0200
Date:   Tue, 15 Oct 2019 18:35:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 5/6] obj/ct_timeout: Avoid array overrun in
 timeout_parse_attr_data()
Message-ID: <20191015163529.GB12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191015141658.11325-1-phil@nwl.cc>
 <20191015141658.11325-6-phil@nwl.cc>
 <20191015155716.n5amfyrcs5pe42cd@salvia>
 <20191015162130.GZ12661@orbyte.nwl.cc>
 <20191015163346.kxbhiht44qgg3hma@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015163346.kxbhiht44qgg3hma@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 06:33:46PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 15, 2019 at 06:21:30PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Tue, Oct 15, 2019 at 05:57:16PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 15, 2019 at 04:16:57PM +0200, Phil Sutter wrote:
> > > > Array 'tb' has only 'attr_max' elements, the loop overstepped its
> > > > boundary by one. Copy array_size() macro from include/utils.h in
> > > > nftables.git to make sure code does the right thing.
> > > > 
> > > > Fixes: 0adceeab1597a ("src: add ct timeout support")
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  include/utils.h      | 8 ++++++++
> > > >  src/obj/ct_timeout.c | 2 +-
> > > >  2 files changed, 9 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/include/utils.h b/include/utils.h
> > > > index 3cc659652fe2e..91fbebb1956fd 100644
> > > > --- a/include/utils.h
> > > > +++ b/include/utils.h
> > > > @@ -58,6 +58,14 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
> > > >  		ret = remain;				\
> > > >  	remain -= ret;					\
> > > >  
> > > > +
> > > > +#define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
> > > > +
> > > > +#define __must_be_array(a) \
> > > > +	BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
> > > > +
> > > > +#define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> > > > +
> > > >  const char *nftnl_family2str(uint32_t family);
> > > >  int nftnl_str2family(const char *family);
> > > >  
> > > > diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
> > > > index a439432deee18..a09e25ae5d44f 100644
> > > > --- a/src/obj/ct_timeout.c
> > > > +++ b/src/obj/ct_timeout.c
> > > > @@ -134,7 +134,7 @@ timeout_parse_attr_data(struct nftnl_obj *e,
> > > >  	if (mnl_attr_parse_nested(nest, parse_timeout_attr_policy_cb, &cnt) < 0)
> > > >  		return -1;
> > > >  
> > > > -	for (i = 1; i <= attr_max; i++) {
> > > > +	for (i = 1; i < array_size(tb); i++) {
> > > 
> > > Are you sure this is correct?
> > > 
> > > array use NFTNL_CTTIMEOUT_* while tb uses netlink NFTA_* attributes.
> > 
> > The old code can't be correct. Basically it was:
> > 
> > | struct nlattr *tb[attr_max];
> > [...]
> > | for (i = 1; i <= attr_max; i++) {
> > |   if (tb[i]) {
> > [...]
> > 
> > So in the last round, it accesses 'tb[attr_max]' which is out of bounds.
> 
> I see, thanks for explaining.
> 
> > Regarding the question of whether the array is big enough at all, I had
> > a look at values in 'timeout_protocol' array struct field values
> > 'attr_max': either NFTNL_CTTIMEOUT_TCP_MAX or NFTNL_CTTIMEOUT_UDP_MAX.
> > Both are last items in unions so serve only for defining array sizes.
> > Without checking differences between NFTNL_CTTIMEOUT_* and respective
> > NFTA_* symbols, I'd bet the array is large enough! :)
> 
> OK!

Is that a synonym for ACK? ;)
