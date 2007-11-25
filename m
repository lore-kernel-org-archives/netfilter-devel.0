From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC IPTABLES 4/4]: Add xt_rateest match
Date: Sun, 25 Nov 2007 18:47:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251836490.9477@fbirervta.pbzchgretzou.qr>
References: <4749ACE0.70303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40377 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbXKYRrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:47:33 -0500
In-Reply-To: <4749ACE0.70303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Nov 25 2007 18:12, Patrick McHardy wrote:

>Date: Sun, 25 Nov 2007 18:12:00 +0100
>From: Patrick McHardy <kaber@trash.net>
>To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
>Subject: [RFC IPTABLES 4/4]: Add xt_rateest match
>
>
>

>+	printf(
>+"rateest match v%s options:\n"
>+" --rateest1 name		Rate estimator name\n"
>+" --rateest2 name		Rate estimator name\n"
>+" --rateest-delta		Compare difference(s) to given rate(s)\n"
>+" --rateest-bps1 [bps]		Compare bps\n"
>+" --rateest-pps1 [pps]		Compare pps\n"
>+" --rateest-bps2 [bps]		Compare bps\n"
>+" --rateest-pps2 [pps]		Compare pps\n"
>+" [!] --rateest-lt		Match if rate is less than given rate/estimator\n"
>+" [!] --rateest-gt		Match if rate is greater than given rate/estimator\n"
>+" [!] --rateest-eq		Match if rate is equal to given rate/estimator\n"
>+"\n",

This is bordering on the 80 column limit (esp --rateest-gt).
I have been using 2 spaces at the front and 4 spaces in the center
recently (try not to pull anything with tabs - see above), e.g.:

"rateest match v%s options:\n"
"  --rateest1 name         Rate estimator name\n"
"  --rateest2 name         Rate estimator name\n"
"  --rateest-delta         Compare difference(s) to given rate(s)\n"
"  --rateest-bps1 [bps]    Compare bps\n"
"  --rateest-pps1 [pps]    Compare pps\n"
"  --rateest-bps2 [bps]    Compare bps\n"
"  --rateest-pps2 [pps]    Compare pps\n"
"  [!] --rateest-lt        Match if rate is less than given rate/estimator\n"
"  [!] --rateest-gt        Match if rate is greater than given rate/estimator\n"
"  [!] --rateest-eq        Match if rate is equal to given rate/estimator\n"
"\n",

>+/* Copied from iproute. See http://physics.nist.gov/cuu/Units/binary.html */
>+static const struct rate_suffix {
>+	const char *name;
>+	double scale;
>+} suffixes[] = {
>+	{ "bit",	1. },

You do not need the dots on the lower ones :)

>+	{ "TBps",	8000000000000. },
>+	{ }
>+};
>+
>+static int
>+rateest_get_rate(u_int32_t *rate, const char *str)
>+{
>+	char *p;
>+	double bps = strtod(str, &p);
>+	const struct rate_suffix *s;
>+
>+	if (p == str)
>+		return -1;
>+
>+	if (*p == '\0') {
>+		*rate = bps / 8.;	/* assume bytes/sec */

LHS is already double, dot won't change it.

>+		return 0;
>+	}
>+
>+	for (s = suffixes; s->name; ++s) {
>+		if (strcasecmp(s->name, p) == 0) {
>+			*rate = (bps * s->scale) / 8.;

-()

>+			return 0;
>+		}
>+	}

-{}

>+		break;
>+	default:
>+		exit(1);

I'd use abort() if it is a can-never-happen case,
or just leave it out completely. Or there is something behind it.


Interesting module.

