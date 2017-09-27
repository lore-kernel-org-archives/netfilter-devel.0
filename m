From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] ct: make ct event set work with COMMA syntax
Date: Wed, 27 Sep 2017 19:38:04 +0200
Message-ID: <20170927173807.29882-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37596 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750852AbdI0Rhw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 13:37:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'ct event set label' and 'ct event set new or label' work, but
'ct event set new, label' did not:

  nft add rule filter input ct event set new,label
  Error: syntax error, unexpected label

First two patches do a bit of refactoring, 3rd patch makes the
real change.

I have a few more patches on top of this to avoid need
of 'meta nfproto' to indicate address type when 'ct saddr' is used
in inet family.

I will followup with those once these patches are in.

