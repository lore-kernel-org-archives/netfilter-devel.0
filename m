Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D224C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 10:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F188520665
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 10:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfHBKfh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 06:35:37 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33144 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbfHBKfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 06:35:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1htUuN-0002el-Ov; Fri, 02 Aug 2019 12:35:35 +0200
Date:   Fri, 2 Aug 2019 12:35:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v6] meta: Introduce new conditions 'time', 'day' and
 'hour'
Message-ID: <20190802103535.mkogus6kjurmvfrj@breakpoint.cc>
References: <20190802071038.5509-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802071038.5509-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
> an hour in the day (which is converted to the number of seconds since midnight) and a day of week.
> 
> When converting an ISO date (eg. 2019-06-06 17:00) to a timestamp,
> we need to substract it the GMT difference in seconds, that is, the value
> of the 'tm_gmtoff' field in the tm structure. This is because the kernel
> doesn't know about time zones. And hence the kernel manages different timestamps
> than those that are advertised in userspace when running, for instance, date +%s.
> 
> The same conversion needs to be done when converting hours (e.g 17:00) to seconds since midnight
> as well.
> 
> The result needs to be computed modulo 86400 in case GMT offset (difference in seconds from UTC)
> is negative.
> 
> We also introduce a new command line option (-t, --seconds) to show the actual
> timestamps when printing the values, rather than the ISO dates, or the hour.
> 
> Some usage examples:
> 
> 	time < "2019-06-06 17:00" drop;
> 	time < "2019-06-06 17:20:20" drop;
> 	time < 12341234 drop;
> 	day "Sat" drop;
> 	day 6 drop;
> 	hour >= 17:00 drop;
> 	hour >= "17:00:01" drop;
> 	hour >= 63000 drop;
> 
> We need to convert an ISO date to a timestamp
> without taking into account the time zone offset, since comparison will
> be done in kernel space and there is no time zone information there.
> 
> Overwriting TZ is portable, but will cause problems when parsing a
> ruleset that has 'time' and 'hour' rules. Parsing an 'hour' type must
> not do time zone conversion, but that will be automatically done if TZ has
> been overwritten to UTC.
> 
> Hence, we use timegm() to parse the 'time' type, even though it's not portable.
> Overwriting TZ seems to be a much worse solution.
> 
> Finally, be aware that timestamps are converted to nanoseconds when
> transferring to the kernel (as comparison is done with nanosecond
> precision), and back to seconds when retrieving them for printing.
> 
> We swap left and right values in a range to properly handle
> cross-day hour ranges (e.g. 23:15-03:22).

Might make sense to also do this for days.

> The first time, we need to call expr_evaluate_range, error printing
> disabled, because otherwise an error (example below) will be printed
> even though the ruleset was eventually successfully evaluated. This
> might be misleading for the end user.
> 
>     meta-test:25:11-21: Error: Range has zero or negative size
>                     hour eq 23:15-03:22 drop;
>                             ^^^^^^^^^^^

nft add inet filter input meta hour '"12:22-12:23"' counter
-> gets parsed as 'meta hour 12:22'.

Could this at least throw an error?  Its not obvious why this doesn't
work as expected.

('"12:22"-"12:23"' will work of course).

nft --debug=netlink add inet filter input meta day '"Sat"-"Fri"' counter

... doesn't do anything.  nft returns 1, but no error is shown.

Looks like range errors are not displayed anymore:
nft --debug=netlink add inet filter input tcp dport 23-22

should throw an error message.
