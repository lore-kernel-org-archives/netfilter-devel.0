Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5D1C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 13:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhLPNMg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:12:36 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58310 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbhLPNMf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 08:12:35 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C69BE605BA;
        Thu, 16 Dec 2021 14:10:04 +0100 (CET)
Date:   Thu, 16 Dec 2021 14:12:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 0/6] Some more code de-duplication
Message-ID: <Ybs7PVP5W5V8X2nx@salvia>
References: <20211216125840.385-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211216125840.385-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 16, 2021 at 01:58:34PM +0100, Phil Sutter wrote:
> No change in patches 1 to 3 and 6.
> 
> Patch 4 is new: Extend program_version field with variant string instead
> of introducing a separate field. This made patch 5 a bit smaller, due to
> less differences between basic_exit_err() and xtables_exit_error().

LGTM, thanks
