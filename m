From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] libxtables: abolish AI_CANONNAME
Date: Wed, 8 Mar 2017 17:46:23 +0100
Message-ID: <20170308164623.GC4076@salvia>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308162658.5697-1-jengelh@inai.de>
 <20170308162658.5697-3-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752380AbdCHQzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:55:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0CC91AEA68
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:46:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E359EDA729
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:46:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A285BDA807
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:46:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308162658.5697-3-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 05:26:57PM +0100, Jan Engelhardt wrote:
> ares->ai_canonname is never used, so there is no point in requesting
> that piece of information with AI_CANONNAME.

I already had one like this here that derived from my previous patch,
anyway. Applied.
