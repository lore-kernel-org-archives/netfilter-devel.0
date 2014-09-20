From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset save issue
Date: Sat, 20 Sep 2014 19:54:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409201951540.13762@blackhole.kfki.hu>
References: <CAL-yc8-6miUn_dg=cDtUzsJC_XKtTnt78xdcnXtH0AnbuJ-nmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stig Thormodsrud <stig@ubnt.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:34452 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbaITRy1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:54:27 -0400
In-Reply-To: <CAL-yc8-6miUn_dg=cDtUzsJC_XKtTnt78xdcnXtH0AnbuJ-nmQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 18 Sep 2014, Stig Thormodsrud wrote:

> I know the max group name length is 32 characters, but I'm running
> into a problem with "save" if the group name is 29 characters.  For
> example:
> 
> ubnt@ERL:~$ sudo ipset create  A234567890123456789 bitmap:port range 1-65535
> ubnt@ERL:~$ sudo ipset add  A234567890123456789 4512-65535
> ubnt@ERL:~$ sudo ipset save  A234567890123456789 > file
> ipset v6.21.1: Internal error at printing to output buffer
> ubnt@ERL:~$
> 
> But if I change it to 28 characters it works:
> 
> ubnt@ERL:~$ sudo ipset create  A23456789012345678 bitmap:port range 1-65535
> ubnt@ERL:~$ sudo ipset add A23456789012345678 4512-65535
> ubnt@ERL:~$ sudo ipset save A23456789012345678 > file
> ubnt@ERL:~$
> ubnt@ERL:~$ sudo ipset -V
> ipset v6.21.1, protocol version: 6
>  
> Ideas?

That's a strange (v)sprintf issue: instead of reporting the length of the 
string which would have been written, it simply returns an error code.

The patch below fixes it and it'll be in the next release in a few days:

diff --git a/lib/session.c b/lib/session.c
index cbef026..da162b0 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -716,13 +716,7 @@ retry:
 			fmt, args);
 	va_end(args);
 
-	if (ret < 0) {
-		ipset_err(session,
-			 "Internal error at printing to output buffer");
-		longjmp(printf_failure, 1);
-	}
-
-	if (ret >= IPSET_OUTBUFLEN - len) {
+	if (ret < 0 || ret >= IPSET_OUTBUFLEN - len) {
 		/* Buffer was too small, push it out and retry */
 		D("print buffer and try again: %u", len);
 		if (loop++) {
@@ -750,13 +744,7 @@ retry:
 	ret = fn(session->outbuf + len, IPSET_OUTBUFLEN - len,
 		 session->data, opt, session->envopts);
 
-	if (ret < 0) {
-		ipset_err(session,
-			"Internal error at printing to output buffer");
-		longjmp(printf_failure, 1);
-	}
-
-	if (ret >= IPSET_OUTBUFLEN - len) {
+	if (ret < 0 || ret >= IPSET_OUTBUFLEN - len) {
 		/* Buffer was too small, push it out and retry */
 		D("print buffer and try again: %u", len);
 		if (loop++) {

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
