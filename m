Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2515C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 07:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A675861077
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 07:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhG2HND (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 03:13:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40398 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbhG2HNB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 03:13:01 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 87E02642A4;
        Thu, 29 Jul 2021 09:12:26 +0200 (CEST)
Date:   Thu, 29 Jul 2021 09:12:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [nft] Regarding `tcp flags` (and a potential bug)
Message-ID: <20210729071252.GC15962@salvia>
References: <CAGnHSEkt4xLAO_T9KNw2xGjjvC4y=E0LjX-iAACUktuCy0J7gw@mail.gmail.com>
 <CAGnHSEncHuO2BduzGx1L9eVtAozdGb-XabQyrS7S+CO2swa1dw@mail.gmail.com>
 <20210727211116.GA13897@salvia>
 <CAGnHSEknUAcg=bk1D43oZNMt=4GOZUcqh5Vt6=FU+ebRKtqcWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnHSEknUAcg=bk1D43oZNMt=4GOZUcqh5Vt6=FU+ebRKtqcWw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 29, 2021 at 10:27:57AM +0800, Tom Yan wrote:
[...]
> As of the current code (or even according to what you said / implied
> "should and would still be right"), `tcp flags syn` checks and checks
> only whether the syn bit is on:

It is actually the same topic that you are discussing in several
emails: You don't seem to like that the implicit operation for the
bitmask datatype is not ==.

Fair enough.

[..]
> Probably because `{ }` implies a `==`.

Again the same argument from another email: As I said { } implies a
set, which implies an exact match on the value.

For most datatypes, the implicit operation implies '==', except for
the bitmask datatype.
