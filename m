Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B27C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 10:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03296206DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 10:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfLMKg2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 05:36:28 -0500
Received: from correo.us.es ([193.147.175.20]:42322 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfLMKg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 05:36:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3320FBAF0D
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Dec 2019 11:36:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 246F4DA70B
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Dec 2019 11:36:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16097DA70F; Fri, 13 Dec 2019 11:36:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F249CDA781;
        Fri, 13 Dec 2019 11:36:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Dec 2019 11:36:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CBC084265A5A;
        Fri, 13 Dec 2019 11:36:23 +0100 (CET)
Date:   Fri, 13 Dec 2019 11:36:24 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft] main: allow for getopt parser from top-level scope
 only
Message-ID: <20191213103624.xhioyre6ckoar6y2@salvia>
References: <20191212171455.83382-1-pablo@netfilter.org>
 <20191212174535.GI20005@orbyte.nwl.cc>
 <20191212182811.ufw4vxtjfs42zvc7@salvia>
 <20191213103345.GJ20005@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213103345.GJ20005@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 13, 2019 at 11:33:45AM +0100, Phil Sutter wrote:
> Hi,
> 
> On Thu, Dec 12, 2019 at 07:28:11PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Dec 12, 2019 at 06:45:35PM +0100, Phil Sutter wrote:
> > > On Thu, Dec 12, 2019 at 06:14:55PM +0100, Pablo Neira Ayuso wrote:
> > > [...]
> > > > diff --git a/src/main.c b/src/main.c
> > > > index fde8b15c5870..c96953e3cd2f 100644
> > > > --- a/src/main.c
> > > > +++ b/src/main.c
> > > > @@ -202,29 +202,107 @@ static const struct {
> > > >  	},
> > > >  };
> > > >  
> > > > +struct nft_opts {
> > > > +	char		**argv;
> > > > +	int		argc;
> > > > +};
> > > > +
> > > > +static int nft_opts_init(int argc, char * const argv[], struct nft_opts *opts)
> > > > +{
> > > > +	uint32_t scope = 0;
> > > > +	char *new_argv;
> > > > +	int i;
> > > > +
> > > > +	opts->argv = calloc(argc + 1, sizeof(char *));
> > > > +	if (!opts->argv)
> > > > +		return -1;
> > > > +
> > > > +	for (i = 0; i < argc; i++) {
> > > > +		if (scope > 0) {
> > > > +			if (argv[i][0] == '-') {
> > > > +				new_argv = malloc(strlen(argv[i]) + 2);
> > > > +				if (!new_argv)
> > > > +					return -1;
> > > > +
> > > > +				sprintf(new_argv, "\\-%s", &argv[i][1]);
> > > > +				opts->argv[opts->argc++] = new_argv;
> > > > +				continue;
> > > > +			}
> > > > +		} else if (argv[i][0] == '{') {
> > > > +			scope++;
> > > > +		} else if (argv[i][0] == '}') {
> > > > +			scope--;
> > > > +		}
> > > 
> > > This first char check is not reliable, bison accepts commands which lack
> > > spaces in the relevant places:
> > > 
> > > | # nft add chain inet t c{ type filter hook input priority filter\; }
> > > | # echo $?
> > > | 0
> > 
> > Yes, it won't catch that case. Do you think it is worth going further
> > in this preprocessing?
> 
> What about a different approach, namely to iterate over argv in reverse,
> reordering those *argv until **argv != '-'? One would have to make sure
> not to mess ordering, but that should be the only requirement to get
> expected results in any situation.

That's another possibility, yes:

        argv[i][strlen(argv[i]) - 1] == '{'
