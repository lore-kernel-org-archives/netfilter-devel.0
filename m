Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2824AC2D0C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 18:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ED3822527
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 18:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbfLLS1r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 13:27:47 -0500
Received: from a3.inai.de ([88.198.85.195]:34518 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbfLLS1r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 13:27:47 -0500
Received: by a3.inai.de (Postfix, from userid 25121)
        id D8A425890E9A6; Thu, 12 Dec 2019 19:27:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D1A1260C646CF;
        Thu, 12 Dec 2019 19:27:45 +0100 (CET)
Date:   Thu, 12 Dec 2019 19:27:45 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: allow for getopt parser from top-level scope
 only
In-Reply-To: <20191212174535.GI20005@orbyte.nwl.cc>
Message-ID: <nycvar.YFH.7.76.1912121926350.25751@n3.vanv.qr>
References: <20191212171455.83382-1-pablo@netfilter.org> <20191212174535.GI20005@orbyte.nwl.cc>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2019-12-12 18:45, Phil Sutter wrote:
>[...]
>> diff --git a/src/main.c b/src/main.c
>> index fde8b15c5870..c96953e3cd2f 100644
>> --- a/src/main.c
>> +++ b/src/main.c
>> +static int nft_opts_init(int argc, char * const argv[], struct nft_opts *opts)
>> +{
>> +	uint32_t scope = 0;
>> +	char *new_argv;
>> +	int i;
>> +
>> +	opts->argv = calloc(argc + 1, sizeof(char *));
>> +	if (!opts->argv)
>> +		return -1;
>> +
>> +	for (i = 0; i < argc; i++) {
>> +		if (scope > 0) {
>> +			if (argv[i][0] == '-') {
>> +				new_argv = malloc(strlen(argv[i]) + 2);
[...]

Or simply stop taking options after the first-non option.
This is declared POSIX behavior, and, for glibc, it only needs the
POSIXLY_CORRECT environment variable, which can be set ahead of
getopt()/getopt_long() call and unset afterwards again.
