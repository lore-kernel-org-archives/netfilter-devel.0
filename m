From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: A small series of iptables userspace cleanups
Date: Thu, 31 Mar 2011 21:24:24 -0700
Message-ID: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1DAEY0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:24:26 -0400
Received: by wwa36 with SMTP id 36so3610423wwa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2011 21:24:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm going to follow up on this email with a small series of 17 patches
to userspace iptables code.
These patches have all received extensive testing when applied to 1.4.4=
=2E
I've ported the patches and tested that everything compiles cleanly
with current head, but they don't have nearly the same level of
thorough testing.

* The first patch simply allows targets and matches to include
underscores.  Without this the relevant man page sections don't get
included.

* The second is a trivial application of a Redhat/Fedora FD_CLOEXEC pat=
ch.

* The third fixes an ipv6 comment thinko/typo.

* The fourth is more complex: it delays match and target
initialization to later on.
=46or built-in matches/targets we run their init code regardless of wha=
t
we're doing.
Unfortunately init code can result in modules being autoloaded as a
result of version probing.
This is undesirable, by splitting registration into two fragments this
is prevented.
The code is just a teeny bit tricky because of some pointer to pointer
link muckery.

* The remaining 13 patches rename functions which are duplicated
between v4 and v6 code to suffix '4' or '6'.
After these renames are applied the following grep correctly results
in nothing being found:
  egrep --exclude-dir=3D.git -r
'(^|[^_])(init_extensions|for_each_chain|flush_entries|delete_chain|pri=
nt_rule|do_command)([^46]|$)'
=2E

This combined with the previous patch will hopefully allow building a
single multi-purpose busybox-style ipv4 and ipv6 capable ip6?tables
binary.
I have this working for iptables 1.4.4, but haven't yet ported all of
the Makefile/etc changes to the current iptables master branch.

With UPX compression a relatively full-featured static multipurpose
single-binary build of 1.4.4 uses 100KB for i386 and 120KB for x86_64.

/sbin/iptables -> /bin/argv0switch
/sbin/iptables32 -> xtables-tiny32
/sbin/iptables64 -> xtables-tiny64
/sbin/iptables-restore -> /bin/argv0switch
/sbin/iptables-restore32 -> xtables-tiny32
/sbin/iptables-restore64 -> xtables-tiny64
/sbin/iptables-save -> /bin/argv0switch
/sbin/iptables-save32 -> xtables-tiny32
/sbin/iptables-save64 -> xtables-tiny64
/sbin/xtables-tiny32 [100796 bytes]
/sbin/xtables-tiny64 [120044 bytes]

(as you can probably guess /bin/argv0switch picks argv0+"32" or
argv[0]+"64" based on machine architecture)

Cheers,
Maciej =C5=BBenczykowski
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
