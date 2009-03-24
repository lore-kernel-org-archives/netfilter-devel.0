From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Correct signatur for target
Date: Tue, 24 Mar 2009 14:06:58 +0100
Message-ID: <17e3a8f80903240606v1efab2eds2a40a1dbe820af00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:7997 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZCXNHB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:07:01 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1007003fkq.5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2009 06:06:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am currently working on an xtables-targetmodule, and have come
across a thing that puzzles me a little bit. As far as I have
understood it, according to both the book "Writing netfilter module"
(excellent by the way, thank you Jan and Nicolas) and my
x_tables.h-file, the signatur for *target is:

static unsigned int (*target) (struct sk_buff *skb,
			       const struct xt_target_param *par)

However, to get it working on my machine (which runs the
2.6.28.8-kernel), the first argument had to be a double pointer for my
module to work as intended. I though the double pointer was there for
compatibility with older kernels. Does any know where I am wrong/what
I have done wrong?

-Kristian
