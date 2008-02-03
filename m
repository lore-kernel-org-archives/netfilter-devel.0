From: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: cups slow on linux-2.6.24
Date: Mon, 4 Feb 2008 00:08:28 +0800
Message-ID: <b6a2187b0802030808v5ca48d96t697c5f3a1c638ded@mail.gmail.com>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	 <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
	 <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
	 <47A13573.7090804@trash.net>
	 <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
	 <47A13FBD.8050803@trash.net>
	 <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com>
	 <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
	 <b6a2187b0801312128j19286ca1x9ba9af5a31ae7a96@mail.gmail.com>
	 <Pine.LNX.4.64.0802011530280.25878@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Patrick McHardy" <kaber@trash.net>,
	lkml <linux-kernel@vger.kernel.org>,
	"Krzysztof Piotr Oledzki" <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:34896 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYBCQIa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 11:08:30 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2355787wah.23
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Feb 2008 08:08:29 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.0802011530280.25878@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Feb 2, 2008 10:44 PM, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

> Could I ask you to make two another tests? (I have been unable to
> reproduce the bug so far, but it must be my fault.)

You need to send more than 510 jobs to see the problem.

> In both cases enable loggin invalid messages as Patrick wrote in a previous mail:
> # modprobe ipt_LOG
> # echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

Ok.

> In the first case run the unpatched 2.4.24 kernel and before doing
> any printing, start dumping all the traffic at the 515 port so that we
> won't miss any connection and send the dump file:
> # tcpdump -i lo -s 0 -w dump.pcap tcp port 515

Attached are the file dump1.bad, and dmesg.bad.

The console only starts printing out the "nf_ct_tcp: invalid packed
ignored" messages after the 22 seconds "pause". Look for pause at
"23:40:27.454677", and resume at "23:40:59.469704". The first console
message at "23:40:59".

> In the second case run the patched kernel and just start printing: do you
> get any 'nf_ct_tcp: invalid SYN' kernel message?

No such message. Even after trying many times. But there's still a 26
"pause" from "23:49:41.368812" to "23:50:07.392278". It's able to
resume and continue printing in "burst".

These tests were ran with just 520 jobs using:

for((i=1; i<520;i++)); do echo $i | lpr -Plp; done


Sorry for the delay. Traveling.

Thanks,
Jeff.
