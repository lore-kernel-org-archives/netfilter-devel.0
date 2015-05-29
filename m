From: Ryan Johnston <ryan@mediapixel.co.nz>
Subject: libnetfilter_queue multi-threaded nfq_handle shared or unique?
Date: Fri, 29 May 2015 21:41:51 +1200
Message-ID: <CAJ0j+bpXpBO2ufrqd3o5FjRhruuMD+ed+VAPok1PESBGPphbMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34654 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbbE2Jlw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 05:41:52 -0400
Received: by ykfl8 with SMTP id l8so20861248ykf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2015 02:41:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When creating each thread for a multi-threaded NFQ application do I:

a) Share the nfq_handle between each thread/queue
b) Create a new nfq_handle for every thread/queue

Cheers :)!
