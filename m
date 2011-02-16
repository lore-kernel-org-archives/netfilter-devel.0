From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: can libnetfilter_conntrack be used to write a userspace
 connection tracker?
Date: Wed, 16 Feb 2011 09:52:36 -0800
Message-ID: <AANLkTim9ANWYvJ5NGBt_8roRLzC21Kep1ZGHU48nwkPY@mail.gmail.com>
References: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>
	<4D2E1EF6.1010003@netfilter.org>
	<AANLkTi=CjQZW5mOmgsk8yjk3Q10iDQp4VLYFqM43T+Ah@mail.gmail.com>
	<4D5BCF12.5010001@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44735 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1BPRwi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:52:38 -0500
Received: by vxb37 with SMTP id 37so691978vxb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2011 09:52:37 -0800 (PST)
In-Reply-To: <4D5BCF12.5010001@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 16, 2011 at 5:20 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Probably you have hit one of the bugs that went into 2.6.37. Please, try
> the patch attached. IIRC, this is fixed in -stable and 2.6.38 and later
> kernels.

Since I'm not yet building my kernels from source, its easier for me
to build a newer kernel than to find an old one and patch it.

Stable is 2.6.37, I'll try 2.6.38-rc5.

userspace connection trackers seems a bit bleading edge, I'd be happy
to build your latest code from git if you point me to it.

I'm now two steps back since upgrading from ubuntu's default kernel
2.6..35 and tools 0.9.14.

It used to be everything but setting expectations was working for me,
but I no longer get updates at all about the conntrack table, and
neither does conntrack -E or -L:

% sudo conntrack -L conntrack
conntrack v0.9.15 (conntrack-tools): 0 flow entries have been shown.

% sudo cat /proc/net/nf_conntrack
ipv4     2 unknown  2 530 src=0.0.0.0 dst=224.0.0.1 [UNREPLIED]
src=224.0.0.1 dst=0.0.0.0 mark=0 ipv4     2 tcp      6 45 CLOSE_WAIT
src=127.0.0.1 dst=127.0.0.1 sport=35780 dport=9999 src=127.0.0.1
dst=127.0.0.1 sport=9999 dport=35780 [ASSURED] mark=0 ipv4     2 tcp
   6 108 SYN_SENT src=127.0.0.1 dst=127.0.0.1 sport=58000 dport=36011
[UNREPLIED] src=127.0.0.1 dst=127.0.0.1 sport=36011 dport=58000 mark=0

% conntrack --version
conntrack v0.9.15 (conntrack-tools)

% grep -i version /usr/local/lib/pkgconfig/libn* /usr/lib/pkgconfig/libn
/usr/local/lib/pkgconfig/libnetfilter_conntrack.pc:Version: 0.9.0
/usr/local/lib/pkgconfig/libnetfilter_queue.pc:Version: 1.0.0
/usr/local/lib/pkgconfig/libnfnetlink.pc:Version: 1.0.0
grep: /usr/lib/pkgconfig/libn: No such file or directory

% uname -a
Linux samtu 2.6.37-020637rc2-generic #201011160905 SMP Tue Nov 16
10:15:47 UTC 2010 i686 GNU/Linux

Cheers,
Sam
