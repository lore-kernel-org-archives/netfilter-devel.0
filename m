From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libxtables: remove unnecessary nesting from
 host_to_ip(6)addr
Date: Wed, 8 Mar 2017 17:45:56 +0100
Message-ID: <20170308164556.GB4076@salvia>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308162658.5697-1-jengelh@inai.de>
 <20170308162658.5697-2-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752501AbdCHQzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:55:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29B6B1AEA6C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:46:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C491DA725
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:46:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E657DDA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:46:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308162658.5697-2-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 05:26:56PM +0100, Jan Engelhardt wrote:
> The error path already terminally returns from the function, so there
> is no point in having an explicit else block.

Applied.
