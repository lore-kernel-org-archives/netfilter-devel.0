From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: Fwd: ebtables broken for kernel above 2.6.28
Date: Fri, 29 May 2009 11:21:54 +0530
Message-ID: <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>
	 <4A1EB783.4090801@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: buytenh@wantstofly.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:2759 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZE2Fvw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2009 01:51:52 -0400
Received: by yw-out-2324.google.com with SMTP id 5so3335863ywb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2009 22:51:54 -0700 (PDT)
In-Reply-To: <4A1EB783.4090801@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Iam facing problem with ebtables binay on 2.6.28 kernel (same binary
works well with 2.6.27). Its mostly a structure alignment issue with
standard targets like DROP,ACCEPT etc. Message seen by user is
"eb_tables: standard target: invalid size 8 != 4"
Iam trying to fix it, this mail is just to check if its already fixed
by someone else?

Thanks
-Sachin

---------- Forwarded message ----------
From: Bart De Schuymer <bdschuym@pandora.be>
Date: Thu, May 28, 2009 at 9:40 PM
Subject: Re: ebtables broken for kernel above 2.6.28
To: sachin sanap <sachin.sanap.1gb@gmail.com>
Cc: nick@fedchik.org.ua, grzes@gnu.univ.gda.pl


You can ask around on netfilter-devel-owner@vger.kernel.org to see if
it has been fixed.

Regards,
Bart


sachin sanap schreef:
>
> Hi ,
> It seems there is some structure alignment problem with the kernel ,
> since the ebtables binary works correctly with 2.6.27 kernel.Iam
> digging into the problem. This mail is just to confirm that its not
> already fixed.
>
> Thanks
> -Sachin
>
>
>
