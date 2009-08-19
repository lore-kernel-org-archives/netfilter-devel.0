From: fender <frozenspot@gmail.com>
Subject: Re: Couldn't load match `pknock':(null)
Date: Wed, 19 Aug 2009 13:15:03 -0300
Message-ID: <7e36c7130908190915j5faa812fy34fc70626de69761@mail.gmail.com>
References: <7e36c7130908181531r3262c9b6kf3f038f9092cc34f@mail.gmail.com>
	 <alpine.LSU.2.00.0908190407200.24013@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:48146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZHSQPD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:15:03 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1090240fga.17
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2009 09:15:03 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0908190407200.24013@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 18, 2009 at 11:07 PM, Jan Engelhardt<jengelh@medozas.de> wrote:
>
> On Wednesday 2009-08-19 00:31, fender wrote:
>
>>Hi people,
>>
>>I've just applied some patches to the pknock match module to work with
>>kernel > 2.6.28 and iptables 1.4.x.
>>
>>What I get when I try to execute this module is:
>>
>># iptables -m pknock --help
>>iptables v1.4.3: Couldn't load match `pknock':(null)
>>
>>
>>Does anyone have any clue about this issue?
>
> My guess that this had been addressed with commit v1.4.3.1-3-gc4edfa6.

Ok, thanks Jan, I'll try with the 1.4.4.

Cheers,

-- 
Federico

/*
 *  J. Federico Hernandez (fender) {frozenspot; at; gmail; dot; com;}
 *  GPG PubKey: wwwkeys.eu.pgp.net key 6AE78BF2
 *  FP: 26AB 7A1B C2C4 70F8 0E7D  C3F4 9736 5CE2 6AE7 8BF2
 */
