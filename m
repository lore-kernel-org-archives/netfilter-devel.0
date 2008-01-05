From: Ben Lentz <BLentz@channing-bete.com>
Subject: Re: conntrack accounting
Date: Sat, 05 Jan 2008 09:22:02 -0500
Message-ID: <477F928A.70206@channing-bete.com>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org> <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com> <477DA84A.3030304@channing-bete.com> <477EAEF0.4000300@channing-bete.com> <477F7BF1.8060705@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050402010009040909050901"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.channing-bete.com ([12.169.82.107]:48684 "EHLO
	smtp.channing-bete.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYAEO6d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:58:33 -0500
In-Reply-To: <477F7BF1.8060705@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050402010009040909050901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


> Ben Lentz wrote:
>   
>>> One more thing... it looks like daemon mode doesn't detach from it's
>>> controlling terminal, still shows "pts/1", and hangs upon logout:
>>>       
>> Added setsid(), patch attached.
>>     
>
> Applied. Thanks again.
>   
Hmmm... file descriptors for STDIN, STDOUT, and STDERR should be closed, 
too... the setsid() detaches the controlling terminal but a terminal 
still hangs at logout after starting the daemon. A quick-and-dirty patch 
is attached, but there's probably a "better" way to do this.

Thanks very much for considering my patches! I really appreciate the 
work you've done implementing my suggestions!

--------------050402010009040909050901
Content-Type: text/plain;
 name="conntrack-tools-0.9.6-close-fd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack-tools-0.9.6-close-fd.patch"

--- src/main.c.orig	2008-01-04 21:19:52.000000000 -0500
+++ src/main.c	2008-01-04 21:42:52.000000000 -0500
@@ -287,6 +287,10 @@
 			exit(EXIT_FAILURE);
 		}
 
+		close(0);
+		close(1);
+		close(2);
+
 		dlog(STATE(log), LOG_NOTICE, "-- starting in daemon mode --");
 	} else
 		dlog(STATE(log), LOG_NOTICE, "-- starting in console mode --");

--------------050402010009040909050901--
