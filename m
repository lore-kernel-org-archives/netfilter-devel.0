From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 15:27:18 +0100
Message-ID: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:43334 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbZCYO1V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:27:21 -0400
Received: by mu-out-0910.google.com with SMTP id g7so32353muf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2009 07:27:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have a setup where I have a sender and a multihomed receiver
connected through a switch, and I am working on a module that
currently does more or less the same as RAWDNAT [1] (at least it is
supposed to). My goal is to redirect packets destined for one
interface on the multihomed receiver to the other, and changing the IP
address works. Unfortunately, the packet keeps the original
destination MAC-address, so it arrives at the wrong interface on the
multihomed receiver. The sender has the correct mapping between IP's
and MAC's (arp_filter is 1 on the receiver) and it works when I do the
redirection using DNAT or for example ping each interface separately.
Does anyone have any suggestions or hints? Reconstructing the SKB
would most likely solve it, but that seems a bit drastic.

My theory is that the original MAC-address is somehow added to the SKB
before it reaches the output-part of the RAW-table (which is where I
hook in), because of the sender's mapping between the original
destination IP and MAC. However, I have not been able to figure this
out. Also, I  looked at the NAT-code, but it seems to "only" change
IP-address as well. Have I overlooked something or am I correct?

Btw, RAWDNAT throws up a couple of errors on my machine, so I have not
been able to see it it does what I want to do.

Please let me know if you need more information.

Thanks,
Kristian

[1] - http://dev.medozas.de/gitweb.cgi?p=xtables-addons;a=blob;f=extensions/libxt_RAWDNAT.c;h=1d50b9188ae5e1e2b257ac15afcb2857c9353c25;hb=RAWNAT
