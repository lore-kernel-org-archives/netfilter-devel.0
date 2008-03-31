From: "Christopher Taylor" <chtaylo3@gmail.com>
Subject: reentrant requirement for nfq_callback
Date: Mon, 31 Mar 2008 13:46:06 -0400
Message-ID: <2590773a0803311046x72c2e4c5y9a6a49a738f3db74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:45792 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYCaRqI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:46:08 -0400
Received: by an-out-0708.google.com with SMTP id d31so455818and.103
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2008 10:46:07 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm assuming that nfq_callback must be reentrant, is this correct?

Respectfully,
Christopher Taylor
