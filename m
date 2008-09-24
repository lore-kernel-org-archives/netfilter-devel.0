From: Alexey Mikhailov <karma@galois.botik.ru>
Subject: Conntrack flow expirations
Date: Wed, 24 Sep 2008 10:38:57 +0400
Message-ID: <877i929hfi.fsf@galois.botik.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pier.botik.ru ([193.232.174.1]:60995 "EHLO pier.botik.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbYIXH3q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:29:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

I'm working on some accounting application based on connection tracking
subsytem. Basically, i just gather information from expired flows. But
there's problem, any TCP flow can live for 4 or 5 days for example, and
I need to get more or less real-time processing. So I want to have some
expiration mechanism. I need to:

 a) I don't want flows to live more than 30 minutes
 b) If flow is inactive for 15 secs I want to get it expired as well

So here comes my question, how do I specify expiration time-out for
long lived flows? I have found 

net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 5 DAYS

If I will change it to 30 MINS will it make trick? But there're
other protocols like UDP: how can I specify active timeout for
it? Another question, if it will affect underlying packet
converstation (i want it to remain undisturbed)? And last
question is how do I specify inactive timeout? I'm not sure that
it's possible but I can write it. And if so, can you please advice
me how I better done it: nf_ct_extend.. for example.

So many questions in so little message but I really looking forward
for your support.

Thank you in advance,
-- Alexey

P.S.: I'm not subscribed to list so please CC me your replies.

