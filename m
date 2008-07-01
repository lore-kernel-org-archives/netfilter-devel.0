From: "Joonwoo Park" <joonwpark81@gmail.com>
Subject: Re: [PATCH 6/8] netfilter: fix string extension for case insensitive pattern matching
Date: Tue, 1 Jul 2008 00:10:21 -0700
Message-ID: <b25c3fa70807010010n496b4f13o28d8c1840359a6a6@mail.gmail.com>
References: <1214034858-1378-1-git-send-email-joonwpark81@gmail.com>
	 <alpine.LNX.1.10.0806210957140.28924@fbirervta.pbzchgretzou.qr>
	 <b25c3fa70806301144x4cd521dfpdd8bb6ef13b8466@mail.gmail.com>
	 <alpine.LNX.1.10.0806302108290.30639@fbirervta.pbzchgretzou.qr>
	 <b25c3fa70806301232w41617d02qa53292f5982c25d0@mail.gmail.com>
	 <48693C4F.20408@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Thomas Graf" <tgraf@suug.ch>, netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:40285 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYGAHKV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:10:21 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2084342rvb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Jul 2008 00:10:21 -0700 (PDT)
In-Reply-To: <48693C4F.20408@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2008/6/30 Patrick McHardy <kaber@trash.net>:
> Joonwoo Park wrote:
>>
>> 2008/6/30 Jan Engelhardt <jengelh@medozas.de>:
>>>
>>> Right, since we copy eader files anyway, we can just make it uint8_t
>>> flags
>>> without the union.
>>
>> I like it :-)
>> Patrick, Thomas, If you want I'll send this fix with version checking
>> patch.
>
> Yes, please also include the suggestions I made previously
> that still apply (should be all of them).
>

ok, as soon as I finish travel, I'll catch up your suggestions, thanks!
