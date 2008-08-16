From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't work
Date: Sun, 17 Aug 2008 07:48:21 +0800
Message-ID: <412e6f7f0808161648g428b0717u237afb6a7c2874b8@mail.gmail.com>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
	 <48A5CEFE.5090407@netfilter.org>
	 <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
	 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>
	 <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>
	 <Pine.LNX.4.64.0808161947450.20963@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Pablo Neira Ayuso" <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:14409 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYHPXsW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:48:22 -0400
Received: by ti-out-0910.google.com with SMTP id b6so623715tic.23
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 16:48:21 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0808161947450.20963@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 17, 2008 at 2:21 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Sat, 16 Aug 2008, Changli Gao wrote:
>
>> > But as the ECN options has not been documented so far, I think it'd be
>> > better to rename them at the same time to something like
>> >
>> > --ecn-tcp-cwr-remove
>> > --ecn-tcp-ece-remove
>> > --ecn-ip-ect-set
>> >
>> > and clashing with the ecn options were resolved.
>>
>> It sounds a good idae. But in order to avoid clashing, we'd better
>> change all the options for all matches in this way:
>>
>> match: foo
>> match-options: --foo-bar
>
> I think changing the existing clashing option names (with keeping the old
> ones for backward compatibility) is just enough - we can use the "rule"
> above for future new matches.
>

Well, If so, we'd better make this rule well documented to let more
people know the issue we talked here if they don't obey it.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
