From: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 31 Jan 2008 10:23:26 +0800
Message-ID: <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>
	 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
	 <47A07FEA.3000702@trash.net>
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
Received: from wa-out-1112.google.com ([209.85.146.179]:31589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYAaCX1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:23:27 -0500
Received: by wa-out-1112.google.com with SMTP id v27so764672wah.23
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2008 18:23:26 -0800 (PST)
In-Reply-To: <47A07FEA.3000702@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Jan 30, 2008 9:47 PM, Patrick McHardy <kaber@trash.net> wrote:

> A binary dump would be more useful:
>
> tcpdump -i lo -w <outfile>
>
> and I guess Jozsef also wants "-s 0" so the full packets are included.

Attached. Again, both runs with this command to print ...

for((i=1; i<1001;i++)); do echo $i | lpr -Plp; done

In the good file (lo.good), look for this timestamp (08:38:11.818587)
when it paused then continue again at 08:38:22.477261. That's almost
11 seconds of "sleep" ... (may be a feature of TCP/IP?).

In the bad file (lo.bad), look for 08:47:55.434722 where it paused,
and then continue at
08:48:24.449176. That's 28 seconds of sleep. But, after it continued,
lpstat shows it's printing a job every 3 seconds. All 100 jobs take
approx 1400 seconds to complete as compared to under 100 seconds for
the good run.

Again, using latest linux, one with
17311393f969090ab060540bd9dbe7dc885a76d5 reverted, and the other
without.


Thanks,
Jeff.
