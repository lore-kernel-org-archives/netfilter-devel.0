From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: xt_socket: Restore mark from full sockets
 only
Date: Tue, 26 Sep 2017 20:05:09 +0200
Message-ID: <20170926180509.GA796@salvia>
References: <1506042096-12352-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com,
        harouth@codeaurora.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56223 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967571AbdIZSFO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 14:05:14 -0400
Content-Disposition: inline
In-Reply-To: <1506042096-12352-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 21, 2017 at 07:01:36PM -0600, Subash Abhinov Kasiviswanathan wrote:
> An out of bounds error was detected on an ARM64 target with
> Android based kernel 4.9. This occurs while trying to
> restore mark on a skb from an inet request socket.

Applied, thanks.
