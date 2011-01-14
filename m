From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
	packets
Date: Sat, 15 Jan 2011 00:10:40 +0100
Message-ID: <20110114231040.GA12126@rere.qmqm.pl>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org> <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr> <20110114222223.GA22508@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@Zen
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:39979 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1ANXKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:10:42 -0500
Content-Disposition: inline
In-Reply-To: <20110114222223.GA22508@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 14, 2011 at 05:22:23PM -0500, Thomas Graf wrote:
> On Fri, Jan 14, 2011 at 06:29:22PM +0100, Jan Engelhardt wrote:
> > On Friday 2011-01-14 17:59, Thomas Graf wrote:
> > >+static int audit_tg_check(const struct xt_tgchk_param *par)
> > >+{
> > >+	const struct xt_AUDIT_info *info =3D par->targinfo;
> > >+
> > >+	if (info->type > XT_AUDIT_TYPE_MAX) {
> > >+		pr_info("Audit type out of range (valid range: 0..%u)\n",
> > >+			XT_AUDIT_TYPE_MAX);
> > >+		return -ERANGE;
> > >+	}
> > >+
> > >+	return 0;
> > >+}
> > Math nitpick: EDOM, not ERANGE.
> ERANGE is the common error code to use in this situation.

Actually, EINVAL is the correct one here since this is not a math funct=
ion
and the error does not refer to result of mathematical coputation.

Best Regards,
Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
