From: Michael Tokarev <mjt@tls.msk.ru>
Subject: flow start_time
Date: Thu, 23 Apr 2009 19:32:41 +0400
Message-ID: <49F08A19.6010909@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([81.13.33.159]:42279 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZDWPdd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:33:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

Right now I'm evaluating various ways to perform traffic accounting
in Linux.  Nowadays solutions are all based on netfilter and packet
queuing over netlink interface.  And most tools used for that sort
of stuff are based on Cisco "flows".  So far so good.

There are several tools available to perform logging of various
statistics which are being logging over netlink, including the
successor of ulogd.  But all the tools I've seen so far perform
"flow management" in userspace in addition to all the housekeeping
the kernel already does - namely, mixing-n-matching various
conntrack entries together, keeping/managing hash tables of
various (src_IP, dst_IP, src_port, dst_port etc) stuff.

For flow-based accounting (compatible with cisco netflows I mean)
this all is only to get one field of the flow structure: it's
the start_time, i.e., in terms of conntrack, it's the time when
the conntrack entry were created.

But isn't it a bit excessive to duplicate all the (quite heavy
and fast-changing) data structures in both kernel- and user-space?
I mean, at least for the "industry standard" format, the one
missing field can be kept by kernel, especially since there,
it costs only extra 4 bytes, and zero CPU, while in duplicating
the whole thing in user space is something entirely else?

I understand that this is not a standard format, not even to
think about "The" standard, and there are other possible formats
too, with their own complications/requirements, and that for
users who does not use such statistics that's 4 bytes wasted
per conntrack which also may mean something...

But still, now not talking about cisco netflows in particular,
but from just logical point of view -- the information exposed
by the kernel is incomplete and lacks this very field, -- flow
start_time -- I think.

So, are there any objections/comments/suggestions about just
adding this one thing (conditionally using CONFIG_foo or not)?
Or maybe it is already there and there's nothing to do?

Thanks!

/mjt
