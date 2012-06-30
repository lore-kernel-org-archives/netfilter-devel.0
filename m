From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 00:50:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu> <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:50645 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2F3WuC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 18:50:02 -0400
In-Reply-To: <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-07-01 00:31, Jozsef Kadlecsik wrote:

>On Sun, 1 Jul 2012, Jan Engelhardt wrote:
>
>> On Sunday 2012-07-01 00:05, Jozsef Kadlecsik wrote:
>> >> 
>> >> diff --git a/Make_global.am b/Make_global.am
>> >> index 4a8f61a..446c4de 100644
>> >> --- a/Make_global.am
>> >> +++ b/Make_global.am
>> >> @@ -69,7 +69,7 @@
>> >>  # interface. 
>> >>  
>> >>  #            curr:rev:age
>> >> -LIBVERSION = 3:0:1
>> >> +LIBVERSION = 3:0:0
>> >
>> >The new library release is backward compatible with the previous one, so 
>> >age must be incremented. That's why I set LIBVERSION to 3:0:1 from 2:1:0. 
>> 
>> Correct -- if you had stayed with "-version-info", which you did not.
>
>So if it's reverted back (second part of your patch), the the first part 
>is to be skipped.

Since you already have made a release (ipset-6.13) emitting an .so.3
file, I don't think you should go back to .so.2. Hence I am using 3:0:0.
