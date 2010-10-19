From: Mistick Levi <gmistick@gmail.com>
Subject: libnetfilter-queue and the Callback
Date: Tue, 19 Oct 2010 19:31:54 +0200
Message-ID: <AANLkTim6E5h=sQHiQj=ORscPnpbaJbyt6A8-PgqSmTzV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45367 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0JSRc2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:32:28 -0400
Received: by vws2 with SMTP id 2so1629315vws.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Oct 2010 10:32:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
a quick question.
when i register a queue ( create_queue) i specify the callback, then i
need a loop that will use the fd (socket) and recv the packets from
the queue...
if so,
 1. why do i need to call "handle_packet", what is the process that
happens ? ( For example: why can't i just process the buffer as is and
return a verdict).
 or,
2. why if i register a callback, i also need to be the one that
"executing" that callback, and not be called by the netfilter hook
QUEUE ?

3. In the callback i need to return - lower than 0 to "stop
processing" else, it will continue processing. What does this
processing mean? since most example's show only the "return
set_verdict", though i don't have to return a verdict at that point. (
So what does the cb return value is used for ? )
 4. If i return "stop processing " in the callback, will the packet
drop? or what?...
 5. Set verdict is the function that actually reinject the packet and
continue it's process . right?


Kind regards
Yechiel Levi
