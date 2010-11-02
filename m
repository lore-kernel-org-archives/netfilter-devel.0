From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Tue, 2 Nov 2010 14:24:19 -0700
Message-ID: <AANLkTinWdkisCZKiLBgrSTn+KRe4DxMKfhDZXtF6rtAJ@mail.gmail.com>
References: <20101102.135254.226783976.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60705 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0KBVYU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 17:24:20 -0400
Received: by wyf28 with SMTP id 28so7154320wyf.19
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Nov 2010 14:24:19 -0700 (PDT)
In-Reply-To: <20101102.135254.226783976.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There isn't necessarily just one prefix...
I think this would be best served with a userspace daemon listening
for address adds/removes and updating rules as required.
