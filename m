From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: `iptables -m tcp --syn` doesn't do what the man says
Date: Fri, 30 Mar 2012 23:50:13 +0200
Message-ID: <1333144213.2325.2613.camel@edumazet-glaptop>
References: <4F761E8E.9000708@gmail.com>
	 <1333142365.2325.2579.camel@edumazet-glaptop>  <4F762859.4080801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Artyom Gavrichenkov <ximaera@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53245 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936367Ab2C3VuT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:50:19 -0400
Received: by wgbdr13 with SMTP id dr13so964611wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Mar 2012 14:50:18 -0700 (PDT)
In-Reply-To: <4F762859.4080801@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2012-03-31 at 01:40 +0400, Artyom Gavrichenkov wrote:
> 31.03.2012 01:19, Eric Dumazet =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=
=BB:
> > FYI current linux kernel just drops this kind of message (SYN+FIN)
>=20
> OK, thanks for clarification, I should have missed this commit.
>=20

You're welcome.

I just realize I made a typo in the Changelog...

Dont call conn_request() if the TCP flags includes SYN flag

->

Dont call conn_request() if the TCP flags includes FIN flag


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
