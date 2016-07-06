From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: DoS attack mitigation in netfilter
Date: Wed, 06 Jul 2016 10:18:06 +0200
Message-ID: <1467793086.1273.12.camel@edumazet-glaptop3.roam.corp.google.com>
References: <577C8ADD.60007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, eric@netfilter.org
To: Vikas <vikas.c.kumar@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33807 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbcGFISN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 04:18:13 -0400
Received: by mail-io0-f173.google.com with SMTP id g13so193272596ioj.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Jul 2016 01:18:12 -0700 (PDT)
In-Reply-To: <577C8ADD.60007@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-07-06 at 10:06 +0530, Vikas wrote:
> Hi,
> 
> Wanted to explore options netfilter provides to mitigate DoS/SYN attacks.
> Even if there is mechanism to incorporate rate limiter solution for high 
> incoming volume traffic then it would help.
> 
> Any input in this regard will be appreciated.

SYN attacks are no longer a problem with current linux kernels.

(linux-4.7 can really absorb about 6Mpps SYN on a single listener, and
more for SO_REUSEPORT enabled listeners)

There is absolutely nothing you can do for a SYN attack, especially not
trying to rate limit it, as you might drop valid SYN packets and thus
hurt real users.

It is simply best to deal with it, as for other kinds of attacks.


