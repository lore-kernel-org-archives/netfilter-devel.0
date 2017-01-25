From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC/PATCH 0/3] Fix ctnetlink regressions
Date: Wed, 25 Jan 2017 01:36:40 +0100
Message-ID: <20170125003640.GA3120@salvia>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbdAYAgu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 19:36:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C276F210575
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Jan 2017 01:36:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1E7DA7EE4
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Jan 2017 01:36:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CECF4DA2D3
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Jan 2017 01:36:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2017 at 09:14:05PM -0800, Kevin Cernekee wrote:
> These patches address a problem I am seeing on Linux 4.4.  They do not
> apply as-is to the master branch.  But I wanted to run them past the list
> first to gather feedback on whether this is a reasonable approach.

1/3 and 3/3 look fine.

Regarding 2/3, I'd suggest a new ctnetlink_update_status() and you use
it from ctnetlink_glue_parse_ct(). This new function allows us to set
status bits leaving what is already set intact, as you proposed.

So we leave ctnetlink_change_status() in place, but not being called
from the userspace helper path.

Thanks for fixing up this mess Kevin.
