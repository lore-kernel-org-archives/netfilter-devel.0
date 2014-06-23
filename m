From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 0/2 libnetfilter_conntrack] zero value handling of mark
 and zone
Date: Mon, 23 Jun 2014 19:12:36 +0900
Message-ID: <20140623101235.GA29052@gmail.com>
References: <20140617120405.GA24712@gmail.com>
 <20140619151611.GC13029@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41371 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaFWKMn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:12:43 -0400
Received: by mail-pa0-f54.google.com with SMTP id et14so5722869pad.27
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 03:12:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140619151611.GC13029@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 19, 2014 at 05:16:11PM +0200, Florian Westphal wrote:
> I've updated the regression test suite in qa/test_api
> with your reported bug case:
> 
> http://git.netfilter.org/libnetfilter_conntrack/commit/?id=169b1a3f37a70018aa402d90ba564ad01cb3a4cd

Thanks to you, things we should do has made obvious:

    assert(test_cmp_attr32(ATTR_ZONE, true, false, 0, 0, NFCT_CMP_STRICT) == 1);
    assert(test_cmp_attr32(ATTR_ZONE, false, true, 0, 0, NFCT_CMP_STRICT) == 1);
    assert(test_cmp_attr32(ATTR_ZONE, true, false, 0, 0, NFCT_CMP_MASK) == 1);

and I worked, but it's dirty-looking. Is there more sophiscated way?
