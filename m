From: Giacomo <delleceste@gmail.com>
Subject: iptables -t nat -A OUTPUT -j DNAT ... checksum incorrect
Date: Wed, 5 Aug 2009 14:53:02 +0200
Message-ID: <885896af0908050553kefeadd2l2fb30190ade2f521@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52686 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160AbZHEMxC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:53:02 -0400
Received: by ewy10 with SMTP id 10so71089ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2009 05:53:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all.

With the rule


iptables -t nat -A OUTPUT -p tcp -j DNAT -d 151.8.71.28
--to-destination 140.105.5.88:8080


I see the GET http request with checksum incorrect (on the wireshark
traffic analyzer):

Checksum: x incorrect, should be y (maybe caused by "TCP checksum offload?)

Is it normal?

Why does this happen?

Thanks

Giacomo

--
