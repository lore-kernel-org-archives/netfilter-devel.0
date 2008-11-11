From: "OpenSource Dev" <dev.opensource@gmail.com>
Subject: Re: Re[2]: how to update payload using QUEUE
Date: Tue, 11 Nov 2008 02:54:43 -0600
Message-ID: <c813aacf0811110054h7f51d7bg7088d77abe6de602@mail.gmail.com>
References: <c813aacf0811091503u26425f2fw368689d7d0ea6d6b@mail.gmail.com>
	 <1189733016.20081110095859@yandex.ru>
	 <c813aacf0811101648l169bdffne799c41d014733d9@mail.gmail.com>
	 <69704515.20081111095600@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Kuzin Andrey" <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:19839 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYKKIyp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:54:45 -0500
Received: by ug-out-1314.google.com with SMTP id 39so662158ugf.37
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Nov 2008 00:54:43 -0800 (PST)
In-Reply-To: <69704515.20081111095600@yandex.ru>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I found some useful links for you !
>
> Here use checksum compute for tcp and ip packets (some code from TCPDUMP):
> http://code.google.com/p/quefuzz/source/browse/trunk/quefuzz.c?r=5

This really works great. I will sure try some other methods too and
try to find out which one is better.

Right now I can ping two machines with modified ICMP payload and new
checksum value :)
But TCP is not working yet. I am pretty sure I have some code mixup somewhere.

Thanks for your help!

Bikrant


>
> Here use another cksum() function:
> https://trac.luffy.cx/udpproxy/browser/src
> https://trac.luffy.cx/udpproxy/browser/src/cksum.c
> https://trac.luffy.cx/udpproxy/browser/src/proxy.c
>
> Question is what function calculate checksum faster and rigth for
> nf_queue ?!
>
> May be this help to you !
> Write something about that. I also need this experience, but
> i don't have any time for experiments now.
>
> Any comments from nfq developers also appreciated.
> Why your nfq_set_verdict with payload don't compute checksum
> automatically ???!!!
> Google say what whole the world have difficults with that.
