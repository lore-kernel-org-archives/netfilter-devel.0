From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match, user
Date: Thu, 3 Jul 2008 09:26:04 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807030922040.20393@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57873 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937005AbYGCH0G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:26:06 -0400
In-Reply-To: <20080703003942.GA2012@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>+static const struct option route_opts[] = {
>+	{ "route-src-exists", 0, NULL, '1' },
>+	{ "route-src-eq", 1, NULL, '2' },
>+	{ "route-src-gt", 1, NULL, '3' },
>+	{ "route-src-lt", 1, NULL, '4' },
>+	{ "route-dst-exists", 0, NULL, '5' },
>+	{ "route-dst-eq", 1, NULL, '6' },
>+	{ "route-dst-gt", 1, NULL, '7' },
>+	{ "route-dst-lt", 1, NULL, '8' },
>+	{ .name = NULL }
>+};

You are mixing non-C99 and C99 style.

>+static int route_parse(int c, char **argv, int invert, unsigned int *flags,
>+                       const void *entry, struct xt_entry_match **match)
>+{
>+	struct xt_route_info *info = (struct xt_route_info *) (*match)->data;
>+	unsigned int value;
>+
>+	check_inverse(optarg, &invert, &optind, 0);

I would not bother supporting intraplaced ! at all. Just remove that line.

>+		case '6':
>+			if (invert) 
>+				exit_error(PARAMETER_PROBLEM,
>+						"route: unexpected `!'");
>+
>+			if (string_to_number(optarg, 1, 128, &value) == -1)
>+				exit_error(PARAMETER_PROBLEM,
>+				           "route: Expected prefix between 1 and 128");
>+
>+			info->mode = XT_ROUTE_DST_EQ;
>+			info->value = value;
>+			break;

There is a lot of code to unify between route_mt_parse and route_mt6_parse.
