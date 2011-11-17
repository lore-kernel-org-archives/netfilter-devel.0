From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: Question about tcp reopen in tcp_in_window
Date: Thu, 17 Nov 2011 20:12:05 +0800
Message-ID: <4EC4FA15.8000607@cn.fujitsu.com>
References: <4EC4AF32.5050901@cn.fujitsu.com> <alpine.DEB.2.00.1111170904040.27634@blackhole.kfki.hu> <4EC4CE41.2060003@cn.fujitsu.com> <alpine.DEB.2.00.1111171035110.27950@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1KQMLf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:11:35 -0500
In-Reply-To: <alpine.DEB.2.00.1111171035110.27950@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2011=E5=B9=B411=E6=9C=8817=E6=97=A5 17:41, Jozsef Kadlecsik =E5=
=86=99=E9=81=93:
> No, but I still don't get what's the problem with the code segment yo=
u=20
> cited. You left out the comment:

Thanks Jozsef Kadlecsik.
Actually there is no any problem,I just want to know wath's the use of =
this code segment.

> We destroy the connection in the reopen case, and in that path the co=
de=20
> segment above won't be called as you noticed.

Maybe there is the other path?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
