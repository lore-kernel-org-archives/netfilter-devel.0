From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: iptables-compat translation for TCPMSS
Date: Tue, 17 Oct 2017 14:00:37 +0200
Message-ID: <20171017120037.GA13186@salvia>
References: <1508068939-17220-1-git-send-email-aastha.gupta4104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com, netfilter-devel@vger.kernel.org
To: Aastha Gupta <aastha.gupta4104@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753475AbdJQMAl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:00:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E2D74D651
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:00:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EFC3DA804
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:00:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1508068939-17220-1-git-send-email-aastha.gupta4104@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 15, 2017 at 05:32:19PM +0530, Aastha Gupta wrote:
> Since path mtu support was added, we can now add
> iptables-compat translation for TCPMSS extension.

Applied, thanks.
