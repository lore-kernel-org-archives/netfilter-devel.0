From: Stephen Hemminger <shemminger@vyatta.com>
Subject: conntrack h323 reassembly
Date: Wed, 28 Apr 2010 16:55:41 -0700
Message-ID: <20100428165541.174eb58e@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:39548 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0D1Xzq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:55:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems that h323 conntrack module can't handle TCP fragments.
Is this a problem for other modules, or is it unique to H323?


More detail:
  https://bugzilla.vyatta.com/show_bug.cgi?id=5127
