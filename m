From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH xtables-addons] build: fix configure compatiblity with
 POSIX shells
Date: Sun, 3 Apr 2016 18:01:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1604031800440.5788@nerf40.vanv.qr>
References: <080ce332d72f144b21b5d63986b6e8ebd9bc3095.1459542934.git.mschiffer@universe-factory.net> <alpine.LSU.2.20.1604031202380.31323@nerf40.vanv.qr> <57010529.3030404@universe-factory.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Matthias Schiffer <mschiffer@universe-factory.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:41758 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbcDCQBd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Apr 2016 12:01:33 -0400
In-Reply-To: <57010529.3030404@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-04-03 13:57, Matthias Schiffer wrote:
>> To test its resilience against silly krel strings (not exactly unheard of),
>> let's pretend that
>> 
>> 	krel="4x.6.0"
>> 
>> checking kernel version that we will build against... ./configure: line
>> 11957: 4x: value too great for base (error toke
>> n is "4x")
>> ./configure: line 8: printf %s\n: command not found
>
>Weird, what version/variant of awk are you using (or were you just changing
>the value of krel in an artificial test and dropped the awk call
>altogether)? krel should be cut off at the first character not in the set
>[0-9.], so krel would be "4" and version 4.0.0.0 should result.

Aha; yes, I had dropped awk altogether.
