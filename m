From: Aft nix <aftnix@gmail.com>
Subject: no extension found for this protocol
Date: Mon, 24 Sep 2012 17:12:12 +0600
Message-ID: <CAGuaRCvtBG4dn70f=gjkB_ep7LDtWn_eHZJ+2PVtU2sikS94AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34891 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2IXLMM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:12:12 -0400
Received: by ieak13 with SMTP id k13so10470179iea.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Sep 2012 04:12:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've added a target extension. The kernel module(xt_*.ko)  and  the
userspace plugin(libxt_*.so) are there. But when
i try to invoke the rule, it gives me "No extension found for this protocol".

What am i doing wrong here?

cheers.

-- 
-aft
