From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-ct 0/2] add new bitmask functions
Date: Wed, 10 Sep 2014 17:45:25 +0900
Message-ID: <20140910084525.GA23549@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54281 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaIJIpc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:45:32 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so3000708pdj.22
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Sep 2014 01:45:32 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

I've changed nfct_bitmask_equal() from previous to use bool,
as you adviced. Would you revew again?
