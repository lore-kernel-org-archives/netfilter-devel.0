From: Bruno Moreira Guedes <thbmatrix@gmail.com>
Subject: Flux Between POST_ROUTING Verdicts and Packet Changes
Date: Wed, 24 Jun 2009 17:06:01 -0300
Message-ID: <3fdd6ce00906241306u633996f2n6219580ba8d12a74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:28657 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZFXUF7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:05:59 -0400
Received: by an-out-0708.google.com with SMTP id d40so1971653and.1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2009 13:06:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

Because I can't found many info about some problems, I want to know
what happens betwen the moment I set the verdict in netfilter_queue,
and the moment the packet is changed by the NAT part of netfilter.

Just to explain, I'm jumping all packets from nat::POSTROUTING and
nat::PREROUTING to NFQUEUE, and creating conntrack entries to do
SNAT/DNAT some packets. After creating the conntrack entries, I just
set the verdict to NF_ACCEPT.

It seems to slow down my testing network, and I want to try to found
why it's too slow.

Thank you in the advance.

--Bruno Moreira Guedes
