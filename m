From: Mike Wright <nobody@nospam.hostisimo.com>
Subject: Re: ipset website
Date: Tue, 02 Dec 2014 10:41:24 -0800
Message-ID: <547E07D4.1090104@nospam.hostisimo.com>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr> <547946BA.106@nospam.hostisimo.com> <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr> <547A0277.3040301@nospam.hostisimo.com> <547A3893.1060009@nospam.hostisimo.com> <alpine.DEB.2.10.1411302030150.3940@blackhole.kfki.hu> <547B8682.2090207@nospam.hostisimo.com> <alpine.DEB.2.10.1412020742150.14469@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from theorb.net ([204.11.228.190]:39653 "HELO b.mx.theorb.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754650AbaLBSlQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:41:16 -0500
In-Reply-To: <alpine.DEB.2.10.1412020742150.14469@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 12/02/2014 12:52 AM, Jozsef Kadlecsik wrote:
> On Sun, 30 Nov 2014, Mike Wright wrote:
>
>> J=F3 napot, J=F3zsef,
>
> =DCdv=F6zletem! :-)
>
>> html restored.
>>
>> site: http://ipset.hostisimo.com
>> diff: http://ipset.hostisimo.com/diff
>> bzip: http://ipset.hostisimo.com/ipset.netfilter.org.tar.bz2
>>
>> Other comments?
>
> The htmlized manpages are renamed from <foo>.man.html to <foo>.html.
> That's not a problem, but you created the diff without the "-N" flag,=
 so
> their contents are missing from the diff file.

Not to worry.  The original man.html pages are still there, unchanged,=20
and used as they are.
>
> However, the best were to separate the common parts (header, menu,
> footer) into files and use SSI to include them into the pages.

They are "included", not using SSI, but CSI (client side includes),=20
which in HTML is the <iframe/> tag.

I did it this way so that whenever the man pages are regenerated using=20
man2html absolutely nothing has to be done.  They will show up=20
automagically.

The site is ready to publish.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
