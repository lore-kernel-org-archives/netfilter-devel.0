From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] Link nfct and helper modules with `-z
 lazy`
Date: Thu, 22 Sep 2016 16:28:00 +0200
Message-ID: <20160922142800.GA3058@salvia>
References: <1473627259-33065-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933209AbcIVO2V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:28:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B48D89D33C
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:28:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A02D3DA818
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:28:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D77CDA819
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:28:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473627259-33065-1-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 01:54:19PM -0700, Kevin Cernekee wrote:
> Some distributions, such as Gentoo and Chrome OS, try to link all
> programs with `-z now` as a security hardening measure.  This breaks
> nfct, because nfct cannot satisfy all of the helper modules' symbols.
> Therefore nfct implicitly depends on lazy binding.
> 
> Have autoconf probe the linker to see if `-z lazy` works, and if so,
> use it to link nfct and the helpers.
> 
> conntrackd itself is unaffected, and should still work with `-z now`.

Applied, thanks for your patience.
