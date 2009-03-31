From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Checkentry called twice?
Date: Tue, 31 Mar 2009 13:16:47 +0200
Message-ID: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37884 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCaLQu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:16:50 -0400
Received: by bwz17 with SMTP id 17so2313397bwz.37
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2009 04:16:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am (still) working on a small target for xtables and have
encountered a bug I don't quite understand. It seems that after the
first rule using my target is inserted, checkentry is called twice for
every following rule. The reason I think this is that my output in the
checkentry-function appears twice in the log-files. In addition, for
some reason, the struct in the first call contains the values for the
previous rule. After having studied my checkentry-function in detail,
I don't find anything wrong with it. It does the necessary checks,
creates a unique proc-file for this rule and returns true if
everything is fine, and false otherwise.

I have always though that checkentry is always called once per rule
(it returns true), does anyone have any hints, tips or suggestions to
what might be wrong? Please let me know if you need more information.

Thanks,
Kristian
