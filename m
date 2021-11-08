Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCF8C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 11:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF54061458
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 11:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbhKHLIX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 06:08:23 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47050 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbhKHLIK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 06:08:10 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 581DA6063C;
        Mon,  8 Nov 2021 12:03:27 +0100 (CET)
Date:   Mon, 8 Nov 2021 12:05:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xlate-test: Print full path if testing all files
Message-ID: <YYkEc/7q3dyA00X8@salvia>
References: <20211106205201.14284-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211106205201.14284-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 06, 2021 at 09:52:01PM +0100, Phil Sutter wrote:
> Lines won't become too long and it's more clear to users where test
> input comes from this way.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>
