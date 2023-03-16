Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB89C6FD19
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 11:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCPLdJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCPLcg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 07:32:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB456BCFC2
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 04:32:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pclqM-0006Xp-6z; Thu, 16 Mar 2023 12:32:26 +0100
Date:   Thu, 16 Mar 2023 12:32:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v3 1/2] pcap: simplify opening of output file
Message-ID: <20230316113226.GJ4072@breakpoint.cc>
References: <20230316110754.260967-1-jeremy@azazel.net>
 <20230316110754.260967-2-jeremy@azazel.net>
 <20230316112449.GI4072@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316112449.GI4072@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Instead of statting the file, and choosing the mode with which to open
> > it and whether to write the PCAP header based on the result, always open
> > it with mode "a" and _then_ stat it.  This simplifies the flow-control
> > and avoids a race between statting and opening.
> > 
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  output/pcap/ulogd_output_PCAP.c | 42 ++++++++++++---------------------
> >  1 file changed, 15 insertions(+), 27 deletions(-)
> > 
> > diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
> > index e7798f20c8fc..220fc6dec5fe 100644
> > --- a/output/pcap/ulogd_output_PCAP.c
> > +++ b/output/pcap/ulogd_output_PCAP.c
> > @@ -220,33 +220,21 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
> >  {
> 
> > +	struct stat st_of;
> > +
> > +	pi->of = fopen(filename, "a");
> > +	if (!pi->of) {
> > +		ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
> > +			  filename,
> > +			  strerror(errno));
> > +		return -EPERM;
> > +	}
> > +	if (fstat(fileno(pi->of), &st_of) == 0 && st_of.st_size == 0) {
> > +	    if (!write_pcap_header(pi)) {
> > +		    ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
> > +			      strerror(errno));
> > +		    return -ENOSPC;
> 
> LGTM, but should that fclose() before -ENOSPC?

AFAICS this doesn't really matter, ulogd will exit().

SIGHUP case doesn't handle errors.
