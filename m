From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Checkentry called twice?
Date: Tue, 31 Mar 2009 14:03:18 +0200
Message-ID: <17e3a8f80903310503r3fd630d6m7822f406e3694d9d@mail.gmail.com>
References: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50936 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZCaMDV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:03:21 -0400
Received: by fxm2 with SMTP id 2so2398403fxm.37
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2009 05:03:18 -0700 (PDT)
In-Reply-To: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After looking more into this, it seems that checkentry is called for
every rule up to and including the one I added. For example, if give
each a unique ID and outputs the id, then the first three -A give me:

First -A:
0

Second -A:
0
1

Third -A:
0
1
2

And so forth. If I instead use -I, the new rule is printed first.

-Kristian
