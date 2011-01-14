From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
 packets
Date: Sat, 15 Jan 2011 00:19:53 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101150016560.22269@obet.zrqbmnf.qr>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org> <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr> <20110114222223.GA22508@canuck.infradead.org>
 <20110114231040.GA12126@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59385 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1ANXT6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:19:58 -0500
In-Reply-To: <20110114231040.GA12126@rere.qmqm.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-01-15 00:10, Micha=C5=82 Miros=C5=82aw wrote:

>On Fri, Jan 14, 2011 at 05:22:23PM -0500, Thomas Graf wrote:
>> On Fri, Jan 14, 2011 at 06:29:22PM +0100, Jan Engelhardt wrote:
>> > On Friday 2011-01-14 17:59, Thomas Graf wrote:
>> > >+static int audit_tg_check(const struct xt_tgchk_param *par)
>> > >+{
>> > >+	const struct xt_AUDIT_info *info =3D par->targinfo;
>> > >+
>> > >+	if (info->type > XT_AUDIT_TYPE_MAX) {
>> > >+		pr_info("Audit type out of range (valid range: 0..%u)\n",
>> > >+			XT_AUDIT_TYPE_MAX);
>> > >+		return -ERANGE;
>> > >+	}
>> > >+
>> > >+	return 0;
>> > >+}
>> > Math nitpick: EDOM, not ERANGE.
>> ERANGE is the common error code to use in this situation.
>
>Actually, EINVAL is the correct one here since this is not a math func=
tion
>and the error does not refer to result of mathematical coputation.

Yeah, but I guess I don't need to mention that EINVAL being reported
is almost always useless currently, because it stands for so many
things. (At least most Xtables modules emit a console message in
addition to it, but other subsystems don't do that so they have
double a problem.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
