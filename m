From: Eugene Strulyov <eugene.strulyov@gmail.com>
Subject: NFQUEUE parallelization
Date: Thu, 24 Sep 2015 12:56:26 -0700
Message-ID: <CAKEqNm=2vnqe_fmSTM4G7xWsHkrXP29f_QxLUf7v7_-f5ESyKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33151 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbIXT41 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 15:56:27 -0400
Received: by oixx17 with SMTP id x17so47451271oix.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2015 12:56:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am implementing a custom filter using the libnetfilter_queue
library. Performance is important, so I am looking at ways to
parallelize it. The options I see are as follows:

- single queue, multiple threads
- multiple queues, multiple threads
- multiple queues, multiple processes (1 per queue)

Which of these options would be most effective?

The guide I found here
https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
says "the nfq_set_verdict2 and nfq_handle_packet function needs to be
protected by lock mechanism." Does that mean that there can be at most
2 threads per queue?

When using multiple queues, is it valid to call nfq_open() multiple
times in the same process? When I do that I get negative numbers for
peer portid. Is this normal?

$ sudo cat /proc/net/netfilter/nfnetlink_queue
  100  27790     0 2 65531     0     0        0  1
  101  -4585     0 2 65531     0     0        0  1
  102  -4586     0 2 65531     0     0        0  1
  103  -4587     0 2 65531     0     0        0  1

Also, how exactly does --queue-balance work? All packets seem to be
directed to one particular queue.

thanks,

Eugene
