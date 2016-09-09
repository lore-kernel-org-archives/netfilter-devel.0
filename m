From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] fix ether address formatting
Date: Fri,  9 Sep 2016 14:43:13 +0200
Message-ID: <1473424996-26957-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48758 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753033AbcIIMnB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 08:43:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ether addresses were listed as HOST_ENDIAN.
This did not show up for plain payload expressions because
the payload expression postprocessing contained a byteorder
conversion for HOST_ENDIAN.

It also did not show up when testing payload statements
because test suite conveniently used ff:ff:ff ...

So,
1. switch the data type to BIG_ENDIAN
2. fix test case to catch bogus formatting
3. remove the payload byte order conversion, I do not think
   it is required (all tests pass without it after patch #1).

