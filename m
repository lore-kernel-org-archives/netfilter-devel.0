From: Gidon Miller <gmiller@vasonanetworks.com>
Subject: conntrack (nf_conn) locking question
Date: Thu, 8 Sep 2011 11:12:53 +0300
Message-ID: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:57361 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932252Ab1IHIMy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:12:54 -0400
Received: by mail-wy0-f174.google.com with SMTP id 22so403114wyh.19
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2011 01:12:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I hope I'm posting this question to the correct list. if not please
let me know where I should be posting.

I'm writing a kernel module (against 2.6.32) to add functionality to
conntrack to maintain extra state information for certain tcp
connections.
the way I'm doing this is by unregistering the l4proto handler for tcp
on module load and registering my own handler struct which is the same
except for the new(), destroy(), packet() and print_conntrack()
functions. my functions call the original tcp handler functions and
then perform some of their own logic - they change the ct->mark to
hold an id used to reference a table of "my" connection info (that
holds my state and other data). I also have xtables matcher and target
modules that reference this conntrack info and do some logic
accordingly.
therefore I'd like to protect my data and the nf_conn data while in my
handler functions.

this raises a few questions:
1. I see that xtables modules (such as xt_CONNMARK and xt_state) do
not take the ct->lock. what protects the ct entry in this case?
2. since I cant take the ct->lock in my functions (because they call
the tcp functions who take the lock) its not clear to me how to
protect my data. in general, is my approach the correct one?

thanks in advance,
Gidon Miller
