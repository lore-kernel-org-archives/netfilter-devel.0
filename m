From: Sebastian Gomez <segomez@utp.edu.co>
Subject: Help with appending data to packets and the best way to create a
 message nonce for cryptography
Date: Thu, 5 Mar 2015 20:41:54 -0500
Message-ID: <CAC8psFbdfpEnSg_ONsfKLyK8A-yGR=KFYs=CkumUKzdn8n5pcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39723 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbbCFBly (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 20:41:54 -0500
Received: by obcwp18 with SMTP id wp18so6606380obc.6
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Mar 2015 17:41:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I developed some months ago a simple cryptography x_tables module to
encrypt/decrypt packets when routing as an academic example for my
students. It was a simple caesar cipher, but it worked very nice, and
it was very fast too.

Now I want to show them an example with a good cipher and that
requires me to use a different nonce for each message (a message
counter). The idea would be to have a counter that is incremented each
time the target method is called, and append it to the encrypted
message.

My first question is where should I put the counter. A local variable
should not work since its value would be lost for the next call, but a
global variable might be problematic when many rules use the same
target and I need a different counter for each rule. A very good point
to have it would be in the struct xt_action_param (in the field
tarinfo), but this parameter is declared constant, so I assume it is
not possible to have a variable there to increment.

My other question is if you know what other module can I use as
reference that append data to the packet. I am afraid that at some
point I might receive a skb without enough space to call an skb_put to
put some extra data at the end. But I suppose there should be some
modules that do similar things so I can work based on them.

I would appreciate if you can give me some lights here.

Thank you
