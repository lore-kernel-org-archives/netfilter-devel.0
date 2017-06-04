From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next RFC 0/5] netfilter: add net namespace support for
 cthelper
Date: Sun, 4 Jun 2017 18:07:53 +0200
Message-ID: <20170604160753.GA843@breakpoint.cc>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59018 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751306AbdFDQIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 12:08:21 -0400
Content-Disposition: inline
In-Reply-To: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> This patch set aims to add net namespace support for the ct helper,
> it is a little large, but I try my best to split them to a relative
> smaller patches, which will help to review. Comments are welcome.

Why?  Could you explain what kind of functionality is added here, or
what problem is fixed?

Why do we need per netns complexity for helpers?

I'm fine with patch #1 of course.
