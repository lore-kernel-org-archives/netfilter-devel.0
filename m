From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: xt_TCPMSS target dropping SYN packets with data: suggested mod
Date: Fri, 17 Jul 2009 09:44:08 +0200
Message-ID: <873dce860907170044v45353d01sd5f0c5305e9ffdb8@mail.gmail.com>
References: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>
	 <4A5DF7DD.2050908@trash.net>
	 <873dce860907160015n6a37715x10aae10249ece994@mail.gmail.com>
	 <4A5F0C41.5030101@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38361 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934159AbZGQHtW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 03:49:22 -0400
Received: by fxm18 with SMTP id 18so567109fxm.37
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2009 00:49:21 -0700 (PDT)
In-Reply-To: <4A5F0C41.5030101@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Pascal Hambourg<pascal.mail@plouf.fr.eu.org> wrote:
> When the receiver has SYN cookies enabled, it replies to a SYN with a
> SYN-ACK as usual, but does not keep any state for it. Instead the state is
> stored in the ISN (used as a "cookie") of the SYN-ACK and will come back in
> the final ACK of the 3-way handshake. Not keeping state means that any data
> contained in the first SYN segment are discarded.

thanks for your explanation!
Ok, so if the receiver is using syn cookies, the data in the SYN would
be discarded,
and that is fine. But the current implementation of TCPMSS target is
dropping the
whole syn packet (if it is carrying any payload), so the receiver is
not receiving
the syn - in that case, the TCP connection could not be established.

Again, I know that this scenario is very rare and awkward, I wan only thinking
about relaxing that check in the TCPMSS target to let this SYN with data go
through and establish the TCP connection, without caring too much
about the payload.
