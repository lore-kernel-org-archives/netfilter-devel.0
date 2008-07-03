From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH,RFC] Route match, user
Date: Thu, 3 Jul 2008 09:29:46 -0700
Message-ID: <20080703162946.GB19256@linuxace.com>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030922040.20393@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:55167
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750703AbYGCQ3r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:29:47 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807030922040.20393@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 03, 2008 at 09:26:04AM +0200, Jan Engelhardt wrote:
> 
> >+static const struct option route_opts[] = {
> >+	{ "route-src-exists", 0, NULL, '1' },
> >+	{ "route-src-eq", 1, NULL, '2' },
> >+	{ "route-src-gt", 1, NULL, '3' },
> >+	{ "route-src-lt", 1, NULL, '4' },
> >+	{ "route-dst-exists", 0, NULL, '5' },
> >+	{ "route-dst-eq", 1, NULL, '6' },
> >+	{ "route-dst-gt", 1, NULL, '7' },
> >+	{ "route-dst-lt", 1, NULL, '8' },
> >+	{ .name = NULL }
> >+};
> 
> You are mixing non-C99 and C99 style.

Copy/paste from other iptables code.  Guess a new match should remain
consistent.
 
> >+static int route_parse(int c, char **argv, int invert, unsigned int *flags,
> >+                       const void *entry, struct xt_entry_match **match)
> >+{
> >+	struct xt_route_info *info = (struct xt_route_info *) (*match)->data;
> >+	unsigned int value;
> >+
> >+	check_inverse(optarg, &invert, &optind, 0);
> 
> I would not bother supporting intraplaced ! at all. Just remove that line.

Sorry..."intraplaced"?
 
> >+		case '6':
> >+			if (invert) 
> >+				exit_error(PARAMETER_PROBLEM,
> >+						"route: unexpected `!'");
> >+
> >+			if (string_to_number(optarg, 1, 128, &value) == -1)
> >+				exit_error(PARAMETER_PROBLEM,
> >+				           "route: Expected prefix between 1 and 128");
> >+
> >+			info->mode = XT_ROUTE_DST_EQ;
> >+			info->value = value;
> >+			break;
> 
> There is a lot of code to unify between route_mt_parse and route_mt6_parse.

I suppose I could pass a 32 or 128 to a common function, yes.

Phil
