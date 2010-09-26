From: Mistick Levi <gmistick@gmail.com>
Subject: Fwd: TCP ack in libnetfilter_queue
Date: Sun, 26 Sep 2010 07:53:35 +0200
Message-ID: <AANLkTi=X0E3keLqnedFG7_BWim3fJvqU+O2RaFUv1+MT@mail.gmail.com>
References: <AANLkTimxj_yVspgWQB2tHF+=ZGvEh1sdga+RdnD_t_SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51433 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0IZFx5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Sep 2010 01:53:57 -0400
Received: by fxm3 with SMTP id 3so1331704fxm.19
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2010 22:53:56 -0700 (PDT)
In-Reply-To: <AANLkTimxj_yVspgWQB2tHF+=ZGvEh1sdga+RdnD_t_SQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
did'nt get any reply on the users list.... Hope anyone here could help out.


---------- Forwarded message ----------
From: Mistick Levi <gmistick@gmail.com>
Date: Thu, Sep 23, 2010 at 4:12 PM
Subject: TCP ack in libnetfilter_queue
To: netfilter@vger.kernel.org


Hey,

i wrote a filter using libnetfilter_queue api, and i want to send
messages to the queue in a specific way...
I want to get the first packet after the TCP 3-way-handshak is
finished ( meaning - only data!)..

i tried using conntrack with "ESTABLISHED" status, but then i start
getting messages to the queue from the last message of the
handshake... ( meaning the last ack )... and i dont want that since it
contain no data....

any help will be appreciated.. thanks.

Yechiel Levi
