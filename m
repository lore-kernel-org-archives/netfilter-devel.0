From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset: use NFPROTO_ (v2)
Date: Wed, 31 Aug 2011 22:30:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108312229530.13025@frira.zrqbmnf.qr>
References: <1314794637-30141-1-git-send-email-jengelh@medozas.de> <alpine.DEB.2.00.1108312109380.1611@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38438 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab1HaUaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:30:04 -0400
In-Reply-To: <alpine.DEB.2.00.1108312109380.1611@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-08-31 21:13, Jozsef Kadlecsik wrote:

>Hi Jan,
>
>On Wed, 31 Aug 2011, Jan Engelhardt wrote:
>
>> The following changes since commit cdb6bb6cf01909e84bae99af0d83946884f24611:
>> 
>>   ipset 6.8 released (2011-07-11 11:10:47 +0200)
>> 
>> are available in the git repository at:
>>   git://dev.medozas.de/ipset master
>> 
>> Jan Engelhardt (3):
>>       ipset: use NFPROTO_ constants
>>       build: abort autogen on subcommand failure
>>       build: move ipset_errcode into library
>
>Please rebase these patches against commit
>20a52295775126d1bd5740b6543d1ea8ea239b1b and send them again: the 
>compatibility patch I had to wrote on top of your previous batch broke 
>them. Thanks!

Rebased. Same URL.

