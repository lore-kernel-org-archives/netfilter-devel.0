Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1152C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 18:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C052073D
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 18:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfLLSdO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 13:33:14 -0500
Received: from correo.us.es ([193.147.175.20]:59710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbfLLSdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 13:33:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 088551C4394
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 19:33:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE9E1DA707
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 19:33:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3C0DDA702; Thu, 12 Dec 2019 19:33:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA5C6DA70B;
        Thu, 12 Dec 2019 19:33:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Dec 2019 19:33:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CAE2A4265A5A;
        Thu, 12 Dec 2019 19:33:08 +0100 (CET)
Date:   Thu, 12 Dec 2019 19:33:09 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: allow for getopt parser from top-level scope
 only
Message-ID: <20191212183309.ecfvftcw3rxwm6ni@salvia>
References: <20191212171455.83382-1-pablo@netfilter.org>
 <20191212174535.GI20005@orbyte.nwl.cc>
 <nycvar.YFH.7.76.1912121926350.25751@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1912121926350.25751@n3.vanv.qr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 12, 2019 at 07:27:45PM +0100, Jan Engelhardt wrote:
> On Thursday 2019-12-12 18:45, Phil Sutter wrote:
> >[...]
> >> diff --git a/src/main.c b/src/main.c
> >> index fde8b15c5870..c96953e3cd2f 100644
> >> --- a/src/main.c
> >> +++ b/src/main.c
> >> +static int nft_opts_init(int argc, char * const argv[], struct nft_opts *opts)
> >> +{
> >> +	uint32_t scope = 0;
> >> +	char *new_argv;
> >> +	int i;
> >> +
> >> +	opts->argv = calloc(argc + 1, sizeof(char *));
> >> +	if (!opts->argv)
> >> +		return -1;
> >> +
> >> +	for (i = 0; i < argc; i++) {
> >> +		if (scope > 0) {
> >> +			if (argv[i][0] == '-') {
> >> +				new_argv = malloc(strlen(argv[i]) + 2);
> [...]
> 
> Or simply stop taking options after the first-non option.
> This is declared POSIX behavior, and, for glibc, it only needs the
> POSIXLY_CORRECT environment variable, which can be set ahead of
> getopt()/getopt_long() call and unset afterwards again.

I think we tried that already, IIRC it breaks: nft list ruleset -a
which is in the test scripts.

The most sane approach from programmer perspective is to force users
to place options upfront. Otherwise, this needs this ugly
preprocessing which gives a bit more flexibility to users in turn.
