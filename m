From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 18:03:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207011754110.17716@frira.zrqbmnf.qr>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu> <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu> <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr> <alpine.DEB.2.00.1207011409470.2289@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:55207 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab2GAQDY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:03:24 -0400
In-Reply-To: <alpine.DEB.2.00.1207011409470.2289@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-07-01 14:11, Jozsef Kadlecsik wrote:
>> >> 
>> >> Correct -- if you had stayed with "-version-info", which you did not.
>> >
>> >So if it's reverted back (second part of your patch), the the first part 
>> >is to be skipped.
>> 
>> Since you already have made a release (ipset-6.13) emitting an .so.3
>> file, I don't think you should go back to .so.2. Hence I am using 3:0:0.
>
>What I meant is to keep LIBVERSION = 3:0:1, because that's right from 
>backward compatibility view, and restore back -version-info.

What part was unclear?

* 6.13 uses -version-number 3:0:1
* that causes production of .so.3
* it's set in stone
* next incompatible change requires use of .so.4

* going back to .so.2 not a good idea
* humans are prone to errors and
  would reuse .so.3 in error

* therefore the patch makes a clean restart,
  using -version-info 3:0:0, to continue using .so.3
  starting from ipset-6.13 until the next *real*
  incompatible change.

(If you care about the uninteresting third digit,
-version-info 3:1:0 would be wanted.)
