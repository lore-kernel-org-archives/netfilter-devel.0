From: Justin Yaple <yaplej@gmail.com>
Subject: Re: Recalculate checksums in netfilter queue
Date: Wed, 21 Apr 2010 20:15:34 -0700
Message-ID: <z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
References: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
	 <x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:39478 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0DVDPe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 23:15:34 -0400
Received: by ywh32 with SMTP id 32so4537926ywh.33
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2010 20:15:34 -0700 (PDT)
In-Reply-To: <x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> If you solve this problem, I'll be too grateful, because I'm looking
> for a solution since the last year in order to do NAT in userspace.
> Good luck.


If I get it figured out I will let you know.  Im kind of supprised
that there isnt a function for this in libnetfilter_queue already.  It
seems like it would be a pretty common requirement to recalculate the
tcp, and ip checksums.  I have spent two days trying to get something
to work without much luck.

My understanding is that the one complement of each 16-bit word is
summed, and then the result of that is bitwise complemented.

So for each word we would do something like this.
for each word{
     sum += ~word;
}

then you would take the bitwise complement of that total.
sum = ~sum;
