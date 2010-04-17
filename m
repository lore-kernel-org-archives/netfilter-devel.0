From: Ali Hamidi <ali.hamidi759@gmail.com>
Subject: packet squeezer problem
Date: Sat, 17 Apr 2010 13:47:23 +0430
Message-ID: <g2g6a3fa21004170217x19bdb8d2x1c7d3631d4b2f829@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:35203 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab0DQJR0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:17:26 -0400
Received: by bwz25 with SMTP id 25so3891953bwz.28
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Apr 2010 02:17:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have two ubuntu 8.04 machines with kernel and I need to network
traffic between these two machines to be compressed. I used your
packet squeezer and change its hook. I used both IP_PRE_ROUTING and
IP_POST_ROUTING Instead of IP_FORWARD and the two hook functions point
to your hook function. I think this does not change the logic of
packet squeezer. I ran this module on my machines but the one who
start tcp connection hung. Please help me to solve this problem.
