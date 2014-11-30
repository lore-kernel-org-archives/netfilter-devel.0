From: Mike Wright <nobody@nospam.hostisimo.com>
Subject: Re: ipset website
Date: Sun, 30 Nov 2014 13:05:06 -0800
Message-ID: <547B8682.2090207@nospam.hostisimo.com>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr> <547946BA.106@nospam.hostisimo.com> <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr> <547A0277.3040301@nospam.hostisimo.com> <547A3893.1060009@nospam.hostisimo.com> <alpine.DEB.2.10.1411302030150.3940@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from theorb.net ([204.11.228.190]:39635 "HELO b.mx.theorb.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751987AbaK3VFB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:05:01 -0500
In-Reply-To: <alpine.DEB.2.10.1411302030150.3940@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 11/30/2014 11:33 AM, Jozsef Kadlecsik wrote:
>
> According to the diff:
>
> Only in new/ipset.netfilter.org: ipset.php
> Only in new/ipset.netfilter.org: iptables-extensions.php
> Only in new/ipset.netfilter.org: iptables.php
>
> There's no php at the site at all, it's totally static. Please keep
> the html files.

J=F3 napot, J=F3zsef,

html restored.

site: http://ipset.hostisimo.com
diff: http://ipset.hostisimo.com/diff
bzip: http://ipset.hostisimo.com/ipset.netfilter.org.tar.bz2

Other comments?

If not, you may push the changes.

If you use wget to retrieve the site remove diff and=20
ipset.netfilter.org.tar.bz2 before pushing.  If you retrieve the bzip=20
nothing needs to be done.

Mike Wright
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
