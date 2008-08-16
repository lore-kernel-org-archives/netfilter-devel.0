From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't work
Date: Sat, 16 Aug 2008 08:05:00 +0800
Message-ID: <412e6f7f0808151705j58845461y952805d122bcf2a7@mail.gmail.com>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
	 <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:60241 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYHPAFC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:05:02 -0400
Received: by ti-out-0910.google.com with SMTP id b6so495992tic.23
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2008 17:05:01 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 16, 2008 at 3:31 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>> Then I checked the source code of iptables. It seems that the extra
>> options for each match are global for each individual command. It is
>> out of my exception. I used to think that options are only available
>> for that match. So I "fixed" this issues quickly. After patching, the
>> command options contain the default global options and the last match
>> or the target extra options.
>
> With your patch applied we'd loose supporting multiple matches of the same
> type.
>

No we don't loose that function. Look at this example:

 iptables -t mangle -A PREROUTING --match a --mac-source
00:11:22:33:44:55 --match a --mac-source 00:11:22:33:44:55 -j ACCEPT
a: 0x60e5e0
a: 0x60eb10

a and b are both the modified match mac. To identify them, I output
their name and option address in their match function. As you see, it
works well without any error.

        switch (c) {
        case '1':
                printf("a: %p\n", macinfo);

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
