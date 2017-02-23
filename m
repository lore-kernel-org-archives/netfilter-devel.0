From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] uapi: stop including linux/sysctl.h in
 uapi/linux/netfilter.h
Date: Thu, 23 Feb 2017 21:51:57 +0100
Message-ID: <20170223205157.GA7527@salvia>
References: <20170222230652.GA14373@altlinux.org>
 <87poi93d19.fsf@xmission.com>
 <20170223024928.GA17115@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbdBWUwL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 15:52:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4F3A96EC1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:52:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5D83DA725
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:52:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C242EDA816
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:52:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170223024928.GA17115@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 05:49:28AM +0300, Dmitry V. Levin wrote:
> linux/netfilter.h is the last uapi header file that includes
> linux/sysctl.h but it does not depend on definitions provided
> by this essentially dead header file.

Applied, thanks.
