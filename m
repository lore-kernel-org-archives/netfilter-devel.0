From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 00/13] Transparent Proxying Patches, Take 4
Date: Tue, 02 Oct 2007 22:39:42 +0200
Message-ID: <20071002203942.11052.7303.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:50753 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbXJBUjo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:39:44 -0400
Received: from nessa.odu ([152.66.208.5])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0JPA007OPXBMQF70@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 22:38:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Here's the next round of tproxy patches, hopefully fixing problems
which came up last time I've posted these patches[1].

I'd like to thank you and Jan Engelhardt the huge help you've
provided.  (Jan himself did a lot of fixes/cleanups!)

The most important changes relative to the previous versions[1] are:

  * the patch implementing the propagation of IP_TRANSPARENT to
    routing output now does not change the signature of
    request_sock_opt.send_ack but uses a flag in inet_request_sock
    itself
  * TCP port redirection support patch
    adds loc_port to struct inet_request_sock unconditionally
  * TPROXY target is an xt_* target now and has proper 32 bit mark
    values in the target info structure

Additionally there are code cleanups all over the place (thanks Jan).



References:
[1] http://marc.info/?l=netfilter-devel&m=119118672703285&w=2

-- 
KOVACS Krisztian
