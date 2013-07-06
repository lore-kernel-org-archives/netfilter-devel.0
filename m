From: Scott Baillie <scott.a.baillie@gmail.com>
Subject: ip6tables-save LOG target output is different to iptables-save
Date: Sat, 6 Jul 2013 13:42:00 +1000
Message-ID: <CAC+BxFrOpO8UWdd4xa146AsZN52A2hSOmaTiyvOmQK-qktzVPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:39856 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3GFDmC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 23:42:02 -0400
Received: by mail-qe0-f50.google.com with SMTP id f6so1492790qej.23
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 20:42:00 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I am using  ip6tables-save  version  v1.4.14 and have noticed
that the output of the LOG target is different to the output from
iptables-save  version  v1.4.14.

I am sorry but I have not checked to see if this problem has been
fixed with later versions so this problem may already be fixed
but here is the output from the LOG target in my version :


Output from ip6tables-save has quotes
------------------------------
-A INPUT -j LOG --log-prefix "prefix1"


Output from iptables-save does not have quotes
------------------------------------------------
-A INPUT -j LOG --log-prefix prefix1


Regards,

Scott.
