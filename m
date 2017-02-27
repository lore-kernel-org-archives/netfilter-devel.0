From: Florian Westphal <fw@strlen.de>
Subject: Re: per flow stats collection using libnetfilter_conntrack
Date: Mon, 27 Feb 2017 23:12:58 +0100
Message-ID: <20170227221258.GA30877@breakpoint.cc>
References: <3bbe482c-863f-2b29-e3fd-522b0079ddbb@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tarun Khanna <tkhanna@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57778 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751468AbdB0WOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 17:14:44 -0500
Content-Disposition: inline
In-Reply-To: <3bbe482c-863f-2b29-e3fd-522b0079ddbb@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tarun Khanna <tkhanna@akamai.com> wrote:
> Is it possible to register for callbacks so that a user application is
> updated on a regular basis when the packet or bytes counts change for flows?

No, update to packet/byte count doesn't trigger an event (it would
trigger too often).

> I can poll the stats using something similar to "conntrack -L". However, I
> was wondering if it's possible to be notified regularly on updates.

No.  What semantics would you be interested in?

Dumping is quite fast, whats the problem you need to solve?
