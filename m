From: vDev <vijaypas@gmail.com>
Subject: TCP LAST ACK incorrectly treated as invalid
Date: Mon, 20 Oct 2014 16:58:12 -0500
Message-ID: <CAC=w+U7t8K2yjKtj7NDfS-xrCLRxoZ_hPxBU=EiD57v+eQnCMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46013 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaJTV6N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:58:13 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so212727wib.8
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2014 14:58:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It looks like TCP conntrack is incorrectly treating "LAST ACK" (ACK
from peer for last FIN) as the sequence number comparison does not
take into account that the last ACK sequence number will be one
greater than the previous sequence number.

Here's the code that seems to be the cause of it in tcp_in_window()
[nf_conntrack_proto_tcp.c]:

       pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
                 before(seq, sender->td_maxend + 1),
                 after(end, sender->td_end - receiver->td_maxwin - 1),
                 before(sack, receiver->td_end + 1),
                 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));

        if (before(seq, sender->td_maxend + 1) &&
            after(end, sender->td_end - receiver->td_maxwin - 1) &&
            before(sack, receiver->td_end + 1) &&
            after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {

III in pr_debug will be 0 as "before(sack, receiver->td_end + 1)" will
evaluate to false as sack will be equal to (receiver->td_end + 1) for
the last ACK. The sequence number will be one greater in the last ACK.

Any feedback will be helpful. Thanks for looking into this.
