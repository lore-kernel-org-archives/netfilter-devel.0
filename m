From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [iptables PATCH 1/2] [TPROXY] Add userspace component of the
 TPROXY target
Date: Wed, 8 Oct 2008 08:03:30 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810080749270.27120@fbirervta.pbzchgretzou.qr>
References: <20081008071541.9224.66180.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47080 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYJHMDd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:03:33 -0400
In-Reply-To: <20081008071541.9224.66180.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-08 03:15, KOVACS Krisztian wrote:

>+static const struct option tproxy_opts[] = {
>+	{"on-port",	true, NULL, '1'},
>+	{"on-ip",	true, NULL, '2'},
>+	{"tproxy-mark", true, NULL, '3'},
>+	{NULL},
>+};

C99 init preferred :)

>+static void tproxy_help(void)
>+{
>+	printf(
>+"TPROXY target v%s options:\n"
>+"  --on-port port		    Redirect connection to port, or the original port if 0\n"
>+"  --on-ip ip			    Optionally redirect to the given IP\n"
>+"  --tproxy-mark value/mask	    Mark packets with the given value/mask\n\n",
>+XTABLES_VERSION);
>+}

Omit XTABLES_VERSION, it is hardly helpful here, because the TPROXY
extension is unlikely to change and as such, giving it a version
number that always increases as iptables releases are done seems
kinda blunt.

You also probably want to tell the user "value[/mask]", because the
code indicates it is optional.

>+static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
>+{
>+	unsigned long tmp;
>+	char *slash;
>+
>+	slash = strchr(s, '/');
>+	info->mark_mask = (u_int32_t) -1;
>+	if (slash != NULL) {
>+		*slash = '\0';
>+		if (string_to_number_l(slash + 1, 0, ULONG_MAX, &tmp) < 0)
>+			exit_error(PARAMETER_PROBLEM,
>+				   "bad mask in --tproxy-mark \"%s\"", s);
>+		info->mark_mask = tmp;
>+	}
>+	if (string_to_number_l(s, 0, ULONG_MAX, &tmp) < 0)
>+		exit_error(PARAMETER_PROBLEM,
>+			   "bad value in --tproxy-mark \"%s\"", s);
>+	info->mark_value = tmp;
>+}

ULONG_MAX is wrong here, as it is 2^64-1 on x86_64, but mark_mask is 
only 32-bit.

static void tproxy_tg_init(...)
{
	info->mark_mask = ~0U;
}

static void parse_tproxy_mark(...)
{
	unsigned int v;
	char *end;

	if (!strtonum(optarg, &end, &v, 0, UINT_MAX))
		exit_error(problem);
	info->mark_value = v;
	if (*end == '\0')
		return;
	if (*end != '/')
		exit_error(syntax_problem)
	if (!strtonum(optarg, NULL, &v, 0, UINT_MAX))
		exit_error(problem);
	info->mark_mask = v;
}


Manpage looks good.
