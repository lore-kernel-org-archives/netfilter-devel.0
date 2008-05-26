From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Mon, 26 May 2008 10:23:45 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805261020390.19084@fbirervta.pbzchgretzou.qr>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au> <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0805220842570.8393@us.intercode.com.au> <alpine.LNX.1.10.0805221756520.9332@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0805261755340.3470@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56886 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYEZIXr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 May 2008 04:23:47 -0400
In-Reply-To: <Xine.LNX.4.64.0805261755340.3470@us.intercode.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-05-26 10:06, James Morris wrote:
>> >
>> >There are calls from SECMARK and CONNSECMARK into the SELinux API, =
which=20
>> >are the labeling targets.
>>=20
>> But you cannot deny the deletion of a rule from within SECMARK=C3=BF=
=C3=BF
>> there is not even a ->destroy function in that module.
>
>There is a destroy function, although it is only used internally by=20
>SELinux for reference counting.
>
>The xtables destroy method does not return a value and probably needs =
to=20
>unconditionally succeed in any case.
>
>Possible solutions are:
>
>- Add a new method which is designed specifically for applying access=20
>control to rule deletion.
[...]

By the time the destroy function is called, it is already decided
the rule is going away--it is much more like a "cleanup" hook
for any private data the match/target had.

In fact, there is not even really a per-rule [rule=3D{match,target}]
destroy function. A new table image is loaded and atomically
swapped with the previous one. You would rather want to call
security_*() in the ioctl phase.

But then again, the capability flag for net access could just be
split up, which is what people suggested to me about
CAP_SYS_ADMIN when twiddling with file access security hooks
last year.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
