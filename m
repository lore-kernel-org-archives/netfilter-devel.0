From: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 31 Jan 2008 13:01:37 +0800
Message-ID: <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>
	 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
	 <47A07FEA.3000702@trash.net>
	 <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
	 <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
	 <47A13573.7090804@trash.net>
	 <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
	 <47A13FBD.8050803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
	lkml <linux-kernel@vger.kernel.org>,
	"Krzysztof Piotr Oledzki" <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:50092 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYAaFBj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:01:39 -0500
Received: by wa-out-1112.google.com with SMTP id v27so834039wah.23
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2008 21:01:38 -0800 (PST)
In-Reply-To: <47A13FBD.8050803@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Jan 31, 2008 11:25 AM, Patrick McHardy <kaber@trash.net> wrote:

> Actually its probably the SYN/ACK that is dropped. Please try whether
>
> modprobe ipt_LOG
> echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid


On the good run, I don't get any message, which is good.

On the bad run, I got the following message ...

boston kernel: nf_ct_tcp: invalid packed ignored IN= OUT=
SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=8162
DF PROTO=TCP SPT=1016 DPT=515 SEQ=3834958843 ACK=0 WINDOW=32792
RES=0x00 SYN URGP=0 OPT (0204400C0402080A0000CC190000000001030307)
UID=0 GID=65534


This message is displayed repeatedly after the job got "stuck", once
ever 3 seconds coinciding with every 3 seconds of the print job sent.

Hope this helps.

Jeff.
