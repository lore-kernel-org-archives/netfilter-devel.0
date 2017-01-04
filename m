From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH xtables-addons] build: support for Linux 4.10
Date: Wed, 4 Jan 2017 03:06:49 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701040306380.23774@erq.vanv.qr>
References: <1482765242-31943-1-git-send-email-ralph.sennhauser@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:34948 "EHLO ares41.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760811AbdADCQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2017 21:16:33 -0500
In-Reply-To: <1482765242-31943-1-git-send-email-ralph.sennhauser@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2016-12-26 16:14, Ralph Sennhauser wrote:

>Commit 613dbd95723aee7abd16860745691b6c7bda20dc (netfilter:
>x_tables: move hook state into xt_action_param structure) changes the
>struct xt_action_param, accommodate for it.

Both applied.
