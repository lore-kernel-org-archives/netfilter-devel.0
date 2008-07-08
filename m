From: "hamid jafarian" <hamid.jafarian@gmail.com>
Subject: Re: New Version of IPtables (iptables-tng) Ver2.0
Date: Tue, 8 Jul 2008 07:13:39 +0430
Message-ID: <464293e60807071943v63c22006p17838c3d88c58234@mail.gmail.com>
References: <464293e60807062032q6c7fd622h6e364eae33018dc1@mail.gmail.com>
	 <alpine.LNX.1.10.0807071002180.28765@fbirervta.pbzchgretzou.qr>
	 <1215420426.16930.46.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Henrik Nordstrom" <henrik@henriknordstrom.net>,
	"Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:12963 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYGHCnm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 22:43:42 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2952436rvb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2008 19:43:39 -0700 (PDT)
In-Reply-To: <1215420426.16930.46.camel@henriknordstrom.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,

This tests are done about 3 years ago, with one P3 system and in the
graphical environment of Fedor C4.

 I redo this tests in CentOS with DualCore 2Ghz Processor..
      New version take about 18s- user: 4s kernel: 14s
      Current version take about 2m
but..

>> # time iptables-restore 10000.rules
>>
>> real    0m0.120s
>> user    0m0.079s
>> sys     0m0.039s
>
> Comparing iptables-restore batches isn't that interesting as a
> performance point, other than when testing libiptc for stupidities..

yes, iptables-restore and iptables-save commands are batch mode
commands (because of the coding style of the current version but not
in this new version) , and not good checks for performance in the
interactive environment..
in the real world, they may be used at the system startup&shutdown..

> I'd say there is something wrong in the time measurements presented on
> the web site
>
> real (total) time: 5m11.622s
> user space time: 0m12.242s
> kernel space time: 0m17.609s
>
> 12s user + 17s kernel is nowhere near 5m real time..
may be, i don't remember that days well but it may be the waiting
times because of system load..

>
> A more interesting test is to show the iptables time for single rule
> modifications as a function of the ruleset size.
>
yes, e.g. when we have 10,000 rule and we want to Replace one.. i will
test this..

i think, the best feature of this version is the classification algorithms..

be happy

-- 
Ya Ali. H.T.
