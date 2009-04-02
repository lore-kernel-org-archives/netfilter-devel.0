From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Buffering and libnetfilter
Date: Thu, 2 Apr 2009 16:12:43 +0200
Message-ID: <17e3a8f80904020712r65e6f994g51d95756ef6efb1b@mail.gmail.com>
References: <17e3a8f80904020612u4ccbff81h5b9a009fe1e81227@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53596 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbZDBOMr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:12:47 -0400
Received: by fxm2 with SMTP id 2so545390fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2009 07:12:44 -0700 (PDT)
In-Reply-To: <17e3a8f80904020612u4ccbff81h5b9a009fe1e81227@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I forgot to add a couple of things. I have tried adjusting the
receiver buffer size with nfnl_rcvbufsiz and also adjusted the rmem
and wmem-proc variables.

I currently just use the test application that comes with the code,
but I never forward the packets (the callback-function just returns
1). Of course the final application want to do this, but my goal is to
find out about the buffersize, how many packets I can keep on the
NFQUEUE and how to make sure I later stay within the limits. When
testing I use iperf and what happens is that the test application
suddenly stops printing out messages (after queuing 37 packets).

Thanks,
Kristian
