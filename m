From: Glenn Sams <pyromanci@gmail.com>
Subject: Centos 6.5 xtables Addons
Date: Thu, 14 Aug 2014 09:42:38 -0400
Message-ID: <CACuimbnEMuR3jn6RGMQg=_nMgKeZ0HLpxZ+LrCw5tZiuxrg5qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40557 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaHNNmi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:42:38 -0400
Received: by mail-ob0-f174.google.com with SMTP id vb8so965515obc.5
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Aug 2014 06:42:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok,

I have a odd problem. I just got done doing the base configuring of my
CentOS 6.5 server. Adding in fail2ban, postfix, apache, mysql, ect
ect.

I then went in and started to add the xtable addons. I downloaded
version 1.47.1, as that is the version (to my knowledge) the lastest
version for my kernel 2.6.32-431.23.3.el6.x86_64, and then compiled
it.

After compiling with IPv6 options disabled, compiling with ipv6
enabled has always thrown errors for me, I went in downloaded the
geoip database and built it with the xt_geoip_build the BE and LE
folder were in /usr/share/xt_geoip/.

I then proceeded to add this rule:

-A INPUT -m geoip ! --src-cc US -j REJECT --reject-with icmp-net-unreachable

But when I did, I got this message:
iptables: Invalid argument. Run `dmesg' for more information.

The last entry in dmesg was this:
xt_geoip: unable to load 'US' into memory: -12

I then tired these rules:
-A INPUT -m geoip --src-cc US -j ACCEPT
-A INPUT -m geoip --src-cc CN -j REJECT --reject-with icmp-net-unreachable
-A INPUT -m geoip --src-cc AW -j REJECT --reject-with icmp-net-unreachable

Each of these resulted in same error.
xt_geoip: unable to load 'US' into memory: -12
xt_geoip: unable to load 'CN' into memory: -12
xt_geoip: unable to load 'AW' into memory: -12


I do some debuging with the code. I checked the defined path for the
database location. As well I was able to locate the exact line in the
code where the error is being generated from.
xt_geoip.c line 86 inside the geoip_add_node function:

p->count   = umem.count;
p->cc      = umem.cc;
size = p->count * geoproto_size[proto];
subnet = vmalloc(size); // THIS LINE


So at the moment i'm stuck. Cause it seems like none of the country
codes from the GeoIP databases are loading. Anyone have any ideas?
