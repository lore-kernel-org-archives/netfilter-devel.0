From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: add tests for comp match options
Date: Wed, 7 Feb 2018 00:40:26 +0100
Message-ID: <20180206234026.kergadbnl5hd7uvf@salvia>
References: <20180206180330.24879-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932106AbeBFXkb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 18:40:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04F673066A0
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 00:40:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8C45BAAA4
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 00:40:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180206180330.24879-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 06, 2018 at 11:33:30PM +0530, Harsha Sharma wrote:
> This patch adds test for ipcomp flow match specified by its SPI value
> and move tests for ipcomp protocol to libxt_policy.t

Applied, thanks Harsha.
