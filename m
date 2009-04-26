From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Trouble with nfq_get_timestamp
Date: Sun, 26 Apr 2009 19:12:55 +0200
Message-ID: <17e3a8f80904261012w2746cafcv8426dacaf1922355@mail.gmail.com>
References: <17e3a8f80904260943j5ff13304paa523fe88db4344a@mail.gmail.com>
	 <1240765618.6955.1.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eleblond@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:38849 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZDZRM5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:12:57 -0400
Received: by bwz7 with SMTP id 7so1887271bwz.37
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2009 10:12:56 -0700 (PDT)
In-Reply-To: <1240765618.6955.1.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

> Are your packet coming from localhost ? It I remember correctly
> timestamp is only setup for forwarded (or input) packets.

Sorry, I forgot that parth. The packets are either on their way out
from or into the box, so I have tried bout OUTPUT and PREROUTING. I
have also tried casting the memory area after the msg_packet_hw-struct
and it seems to be zero.

-Kristian
