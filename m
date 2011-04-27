From: Ulrich Weber <ulrich.weber@googlemail.com>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 13:43:22 +0200
Message-ID: <4DB8015A.8050909@gmail.com>
References: <20110427085755.GD2418@omroep.nl> <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr> <4DB7F347.1080107@gmail.com> <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ulrich Weber <ulrich.weber@googlemail.com>,
	Leo Baltus <Leo.Baltus@omroep.nl>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36063 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1D0LnY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:43:24 -0400
Received: by wwk4 with SMTP id 4so3192014wwk.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2011 04:43:23 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/27/2011 01:22 PM, Jan Engelhardt wrote:
> On Wednesday 2011-04-27 12:43, Ulrich Weber wrote:
> 
>> Each fragmented IPv6 packets will traverse netfilter separately,
>> in contrast to IPv4, where its only one refragmented packet.
> 
> Not really. All fragments enter nf_hook_slow, be it IPv4 or IPv6.
> It's just that nf_defrag - which is a netfilter module - collects and 
> suppresses fragments before spitting out the unfragmented one.

nf_ct_frag6_output() sends each fragment itself through netfilter.

Personally I don't like this and would rather see, that IPv6 behaves the
same way as IPv4, sending the unfragmented packet through netfilter...


Cheers
 Ulrich
