From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Some questions about linux kernel networking
Date: Tue, 20 Apr 2010 16:43:31 +0200
Message-ID: <l2qede9a9eb1004200743p454d752ayc5fcb5d778f7145f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39167 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0DTOne (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:43:34 -0400
Received: by wyb39 with SMTP id 39so3323779wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2010 07:43:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all. I am a (very very very) newbie in the linux kernel networking.

I have some problems in the understading two concepts:

1. what the "net_ratelimit()" function does?
2. and the xrlim_allow(...)?

3. what about the field "len" of the struct "sk_buff"? is it the sum
of ip header len and tcp header len?
4. and what about the field nfct?

sorry for the questions. i've tried to find some information in the
kernel source code, but nothing.

Thank you
