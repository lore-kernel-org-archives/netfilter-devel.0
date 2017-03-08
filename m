From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] libxtables: duplicated loopback address via host_to_ipaddr()
Date: Wed,  8 Mar 2017 17:25:23 +0100
Message-ID: <20170308162526.5525-1-jengelh@inai.de>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:42550 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754035AbdCHQ0V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:26:21 -0500
In-Reply-To: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Pablo wrote:
>libc seem to need if we have 127.0.0.1 and ::1
>entries in /etc/hosts that are common in many distros.

I was trying to imply that this problem is not specific to localhost,
but could happen with any host name. Testing the memory contents for
for just htonl(INADDR_LOOPBACK) does not seem the right thing.

Following is a 3-patch set to illustrate my idea of filtering
all duplicates.
