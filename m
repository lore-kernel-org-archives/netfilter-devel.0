From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Apply "netfilter: nf_queue: Make the queue_handler pernet" to
 4.4-stable
Date: Tue, 13 Feb 2018 16:49:22 +0100
Message-ID: <20180213154922.GD14300@kroah.com>
References: <20180210001906.GA134644@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933440AbeBMPtV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Feb 2018 10:49:21 -0500
Content-Disposition: inline
In-Reply-To: <20180210001906.GA134644@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 09, 2018 at 04:19:06PM -0800, Eric Biggers wrote:
> Hi Greg, can you please apply commit dc3ee32e96d7 ("netfilter: nf_queue: Make
> the queue_handler pernet") to 4.4-stable?  syzbot is hitting the crash in
> nfqnl_nf_hook_drop() by interrupting thread creation in pg_net_init().  An OOM
> condition is not required, contrary to what is suggested by the original commit
> message.

Now queued up, thanks.

greg k-h
