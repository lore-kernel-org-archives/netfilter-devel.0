From: Drunkard Zhang <gongfan193@gmail.com>
Subject: ipset v6.24: Comment string is too long!
Date: Wed, 30 Dec 2015 10:35:41 +0800
Message-ID: <CAJiejCQizhn--05MnVzKFLyEFki=K6xzJbL+_b7yVgxYKYmitA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: maillist-netfilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35175 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbL3CgC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 21:36:02 -0500
Received: by mail-wm0-f49.google.com with SMTP id f206so25507293wmf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 18:36:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi ;-)

    I'm trying ipset, and misleaded by the error message: "ipset
v6.24: Comment string is too long!", when doing this:

15:26:34 ~ # ipset create bypass hash:net
15:26:40 ~ # ipset add bypass 42.62.0.0/16 comment "cnc"
ipset v6.24: Comment string is too long!

it took me some time to identify where the problem is: "comment"
extension should be enabled when creating the set.

So, WOULD YOU PLEASE replace these words with more accurate sentence?
In this situation, say "'comment' extension not enabled", others say
"Comment string is too long!".

Or, emphasize/highlight "extensions must be enabled before use" in man page.

Sincerely.
