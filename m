From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Xtables-addons: man/SYSRQ sample script
Date: Thu, 23 Aug 2012 15:12:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208231511560.32157@frira.zrqbmnf.qr>
References: <CAKneAXmP=_xR5UQzawtiN-9pRvTnX00fRP6num6=Q7RtCKzJxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Krcmar <honza801@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:50913 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2HWNMZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:12:25 -0400
In-Reply-To: <CAKneAXmP=_xR5UQzawtiN-9pRvTnX00fRP6num6=Q7RtCKzJxw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-08-14 11:48, Jan Krcmar wrote:
>hi,
>
>please add the information to the man page of xtables-addons section SYSRQ
>using ipv6 one must use non-shortened format, otherwise it does not work
>eg.
>2001:0db8:0000:0000:0000:ff00:0042:8329
>not
>2001:0db8::ff00:0042:8329

Thanks.
The page now looks like this.

diff --git a/extensions/libxt_SYSRQ.man b/extensions/libxt_SYSRQ.man
index ab230a8..ade9f13 100644
--- a/extensions/libxt_SYSRQ.man
+++ b/extensions/libxt_SYSRQ.man
@@ -62,7 +62,7 @@ password="password"
 seqno="$(date +%s)"
 salt="$(dd bs=12 count=1 if=/dev/urandom 2>/dev/null |
     openssl enc \-base64)"
-ipaddr=10.10.25.7
+ipaddr="2001:0db8:0000:0000:0000:ff00:0042:8329"
 req="$sysrq_key,$seqno,$salt"
 req="$req,$(echo \-n "$req,$ipaddr,$password" | sha1sum | cut \-c1\-40)"
 
@@ -75,8 +75,8 @@ sysrq key can be used at once, but bear in mind that, for example, a sync may
 not complete before a subsequent reboot or poweroff.
 .PP
 An IPv4 address should have no leading zeros, an IPv6 address should
-be in the form recommended by RFC 5952.  The debug option will log the
-correct form of the address.
+be in the full expanded form (as shown above). The debug option will cause
+output to be emitted in the same form.
 .PP
 The hashing scheme should be enough to prevent mis-use of SYSRQ in many
 environments, but it is not perfect: take reasonable precautions to
