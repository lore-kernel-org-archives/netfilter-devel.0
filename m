From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: ip_route_output_key returns wrong gateway info with specific ip rules
Date: Sat, 10 May 2014 03:23:36 -0700
Message-ID: <CAHo-Ooz2dCf5L0_w+kjHOG-byg+f0nPMS58bjUE1AnG3MRGE+Q@mail.gmail.com>
References: <20140509134110.GI10939@kvmbude>
	<CAHo-Ooww_a0jXJGQru9E5mGTW4LUqNi6559AWy79wdHErB0Y8w@mail.gmail.com>
	<CAHo-OoyP69f=4yvct+gy6rPsS3Dps_Ph=tn1SnRkH0yVS2+2OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36294 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEJKXh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 May 2014 06:23:37 -0400
Received: by mail-qc0-f175.google.com with SMTP id w7so5757843qcr.20
        for <netfilter-devel@vger.kernel.org>; Sat, 10 May 2014 03:23:36 -0700 (PDT)
In-Reply-To: <CAHo-OoyP69f=4yvct+gy6rPsS3Dps_Ph=tn1SnRkH0yVS2+2OA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Btw. Obviously you could just skip the '--syn' match, MARK all tcp
packets to those ports, and rely on fwmark rule for everything (and
not just the SYN packets) and not even bother with the 'from
192.168.100.3' rule.

But that would be boring and not showing the issue at hand. ;-)
