From: "Anton VG" <anton.vazir@gmail.com>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 17:34:16 +0500
Message-ID: <c4b050a10805150534y776a2e3bnf75b5ffe8e3c320d@mail.gmail.com>
References: <200805151421.23862.anton.vazir@gmail.com>
	 <200805151535.31933.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
	 <200805151557.28368.anton.vazir@gmail.com>
	 <1210854755.32691.14.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: "Henrik Nordstrom" <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:39668 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYEOMeU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 08:34:20 -0400
Received: by fg-out-1718.google.com with SMTP id 19so326204fgg.17
        for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2008 05:34:17 -0700 (PDT)
In-Reply-To: <1210854755.32691.14.camel@henriknordstrom.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hm... I feel I've tried iptables-restore, but speed was about the same.

2008/5/15 Henrik Nordstrom <henrik@henriknordstrom.net>:
> On tor, 2008-05-15 at 15:57 +0500, Anton wrote:
>> Definitelly what my test shows - while rule-inserts - if you
>> try to insert 10000 rules - after a several hundreds - it
>> will be inserting like a 1 rule in 1 second and slowness
>> will progress :)
>
> If you need to change add many rules then iptables-restore is the tool
> to use. Batches the updates in a single transaction, instead of one
> transaction per rule...
>
> Regards
> Henrik
>
>
