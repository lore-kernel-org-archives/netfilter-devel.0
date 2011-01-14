From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
 packets
Date: Sat, 15 Jan 2011 00:16:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101150005570.22269@obet.zrqbmnf.qr>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org> <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr>
 <20110114222223.GA22508@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59345 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1ANXQQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:16:16 -0500
In-Reply-To: <20110114222223.GA22508@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-01-14 23:22, Thomas Graf wrote:
>
>> >+static int audit_tg_check(const struct xt_tgchk_param *par)
>> >+{
>> >+	const struct xt_AUDIT_info *info = par->targinfo;
>> >+
>> >+	if (info->type > XT_AUDIT_TYPE_MAX) {
>> >+		pr_info("Audit type out of range (valid range: 0..%u)\n",
>> >+			XT_AUDIT_TYPE_MAX);
>> >+		return -ERANGE;
>> >+	}
>> >+
>> >+	return 0;
>> >+}
>> 
>> Math nitpick: EDOM, not ERANGE.
>
>ERANGE is the common error code to use in this situation.

EDOM is the common error code to use in Xtables for too large inputs,
ERANGE for too large results as a result of inputs (just like
errno(3) specifies). See the other xt modules.

