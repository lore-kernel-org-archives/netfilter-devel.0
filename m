From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [ulogd PATCH 12/13] nfct: introduce new out keys for ipfix
 timestamp
Date: Mon, 2 Jun 2014 21:51:48 +0900
Message-ID: <20140602125148.GA12982@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
 <20140428115621.GM12523@gmail.com>
 <1401618512.2562.3.camel@ice-age2.regit.org>
 <20140602095237.GA15230@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55228 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaFBMvz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:51:55 -0400
Received: by mail-pb0-f42.google.com with SMTP id md12so4219170pbc.29
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 05:51:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140602095237.GA15230@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

I thought it may be better to introduce a new filter too as Eric
suggested and I need uptime for netflow v9, then I'd written it.
Appended patch can be applied after some patches which I've not
sent.

On Mon, Jun 02, 2014 at 11:52:37AM +0200, Pablo Neira Ayuso wrote:
> Perhaps you can consolidate this and provide just one single keys in
> milliseconds?

I intend to resend this patch later, or should I consolidate usec
to single u64 out key in NFCT plugin?

This filter creates IPFIX_flow(Start|End)MicroSeconds and
IPFIX_flow(Start|End)SysUpTime from "flow.(start|end).sec" and
"flow.(start|end).usec".

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 filter/Makefile.am              |   6 +-
 filter/ulogd_filter_TIMECONV.c  | 283 ++++++++++++++++++++++++++++++++++++++++
 input/flow/ulogd_inpflow_NFCT.c |   8 --
 3 files changed, 288 insertions(+), 9 deletions(-)
 create mode 100644 filter/ulogd_filter_TIMECONV.c

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 4077e98..cde943c 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -7,7 +7,8 @@ pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 			 ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
 			 ulogd_filter_HWHDR.la ulogd_filter_MARK.la \
-			 ulogd_filter_IP2HBIN.la ulogd_filter_PACKICMP.la
+			 ulogd_filter_IP2HBIN.la ulogd_filter_PACKICMP.la \
+			 ulogd_filter_TIMECONV.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module
@@ -39,3 +40,6 @@ ulogd_filter_PRINTFLOW_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_PACKICMP_la_SOURCES = ulogd_filter_PACKICMP.c
 ulogd_filter_PACKICMP_la_LDFLAGS = -avoid-version -module
+
+ulogd_filter_TIMECONV_la_SOURCES = ulogd_filter_TIMECONV.c
+ulogd_filter_TIMECONV_la_LDFLAGS = -avoid-version -module
diff --git a/filter/ulogd_filter_TIMECONV.c b/filter/ulogd_filter_TIMECONV.c
new file mode 100644
index 0000000..0d0072f
--- /dev/null
+++ b/filter/ulogd_filter_TIMECONV.c
@@ -0,0 +1,283 @@
+/* ulogd_filter_TIMECONV.c
+ *
+ * ulogd interpreter plugin for IPFIX / Netflow v9 to create
+ * IPFIX_flow(Start|End)MicroSeconds, IPFIX_flow(Start|End)SysUpTime
+ *
+ * (C) 2014 by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#define _GNU_SOURCE	/* for memmem() */
+
+#include <unistd.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <ulogd/ulogd.h>
+#include <ulogd/ipfix_protocol.h>
+
+#ifndef NSEC_PER_SEC
+#define NSEC_PER_SEC    1000000000L
+#endif
+
+#define PROC_TIMER_LIST "/proc/timer_list"
+
+struct timeconv_priv {
+	uint64_t rtoffset;		/* in ns */
+	void (*setfunc)(struct ulogd_key *, uint64_t,
+			uint32_t, uint32_t, uint32_t, uint32_t);
+};
+
+enum {
+	CONFKEY_USEC64,
+	CONFKEY_UPTIME,
+};
+
+static struct config_keyset config_keys = {
+	.num_ces = 2,
+	.ces = {
+		{
+			.key	 = "usec64",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 1,
+		},
+		{
+			.key	 = "uptime",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 1,
+		},
+	},
+};
+
+#define usec64_ce(x)	((x)->ces[CONFKEY_USEC64])
+#define uptime_ce(x)	((x)->ces[CONFKEY_UPTIME])
+
+enum {
+	IKEY_FLOW_START_SEC,
+	IKEY_FLOW_START_USEC,
+	IKEY_FLOW_END_SEC,
+	IKEY_FLOW_END_USEC,
+	IKEY_MAX = IKEY_FLOW_END_USEC,
+};
+
+static struct ulogd_key input_keys[] = {
+	[IKEY_FLOW_START_SEC] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.start.sec",
+	},
+	[IKEY_FLOW_START_USEC] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.start.usec",
+	},
+	[IKEY_FLOW_END_SEC] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.end.sec",
+	},
+	[IKEY_FLOW_END_USEC] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.end.usec",
+	},
+};
+
+enum output_key_index {
+	OKEY_FLOW_START_USEC64,
+	OKEY_FLOW_END_USEC64,
+	OKEY_FLOW_START_UPTIME,
+	OKEY_FLOW_END_UPTIME,
+	OKEY_MAX = OKEY_FLOW_END_UPTIME,
+};
+
+static struct ulogd_key output_keys[] = {
+	[OKEY_FLOW_START_USEC64] = {
+		.type	= ULOGD_RET_UINT64,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.start.useconds",
+		.ipfix	= {
+			.vendor		= IPFIX_VENDOR_IETF,
+			.field_id	= IPFIX_flowStartMicroSeconds,
+		},
+	},
+	[OKEY_FLOW_END_USEC64] = {
+		.type	= ULOGD_RET_UINT64,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.end.useconds",
+		.ipfix	= {
+			.vendor		= IPFIX_VENDOR_IETF,
+			.field_id	= IPFIX_flowEndMicroSeconds,
+		},
+	},
+	[OKEY_FLOW_START_UPTIME] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.start.uptime",
+		.ipfix	= {
+			.vendor		= IPFIX_VENDOR_IETF,
+			.field_id	= IPFIX_flowStartSysUpTime,
+		},
+	},
+	[OKEY_FLOW_END_UPTIME] = {
+		.type	= ULOGD_RET_UINT32,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "flow.end.uptime",
+		.ipfix	= {
+			.vendor		= IPFIX_VENDOR_IETF,
+			.field_id	= IPFIX_flowEndSysUpTime,
+		},
+	},
+};
+
+static inline uint64_t conv_ntp_us(uint32_t sec, uint32_t usec)
+{
+	/* RFC7011 - 6.1.10. dateTimeMicroseconds */
+	return (((uint64_t) sec << 32)
+		+ ((uint64_t) usec << 32) / (NSEC_PER_SEC / 1000))
+		& ~0x7ff;
+}
+
+void set_ntp(struct ulogd_key *okeys, uint64_t offset,
+	     uint32_t start_sec, uint32_t start_usec,
+	     uint32_t end_sec, uint32_t end_usec)
+{
+	okey_set_u64(&okeys[OKEY_FLOW_START_USEC64],
+		     conv_ntp_us(start_sec, start_usec));
+	okey_set_u64(&okeys[OKEY_FLOW_END_USEC64],
+		     conv_ntp_us(end_sec, end_usec));
+
+}
+
+static inline uint32_t conv_uptime(uint64_t offset, uint32_t sec, uint32_t usec)
+{
+	return (sec - offset / NSEC_PER_SEC) * 1000
+		+ usec / 1000 - (offset % NSEC_PER_SEC) / 1000000;
+}
+
+void set_uptime(struct ulogd_key *okeys, uint64_t offset,
+		uint32_t start_sec, uint32_t start_usec,
+		uint32_t end_sec, uint32_t end_usec)
+{
+	okey_set_u32(&okeys[OKEY_FLOW_START_UPTIME],
+		     conv_uptime(offset, start_sec, start_usec));
+	okey_set_u32(&okeys[OKEY_FLOW_END_UPTIME],
+		     conv_uptime(offset, end_sec, end_usec));
+}
+void set_ntp_uptime(struct ulogd_key *okeys, uint64_t offset,
+		    uint32_t start_sec, uint32_t start_usec,
+		    uint32_t end_sec, uint32_t end_usec)
+{
+	set_ntp(okeys, offset, start_sec, start_usec, end_sec, end_usec);
+	set_uptime(okeys, offset, start_sec, start_usec, end_sec, end_usec);
+}
+
+static int interp_timeconv(struct ulogd_pluginstance *upi)
+{
+	struct timeconv_priv *priv =
+			(struct timeconv_priv *)upi->private;
+	struct ulogd_key *inp = upi->input.keys;
+
+	if (!pp_is_valid(inp, IKEY_FLOW_START_SEC)
+	    || !pp_is_valid(inp, IKEY_FLOW_START_USEC)
+	    || !pp_is_valid(inp, IKEY_FLOW_END_SEC)
+	    || !pp_is_valid(inp, IKEY_FLOW_END_USEC))
+		return ULOGD_IRET_ERR;
+
+	priv->setfunc(upi->output.keys, priv->rtoffset,
+		      ikey_get_u32(&inp[IKEY_FLOW_START_SEC]),
+		      ikey_get_u32(&inp[IKEY_FLOW_START_USEC]),
+		      ikey_get_u32(&inp[IKEY_FLOW_END_SEC]),
+		      ikey_get_u32(&inp[IKEY_FLOW_END_USEC]));
+
+	return ULOGD_IRET_OK;
+}
+
+static int configure_timeconv(struct ulogd_pluginstance *upi,
+			      struct ulogd_pluginstance_stack *stack)
+{
+        return config_parse_file(upi->id, upi->config_kset);
+}
+
+static int start_timeconv(struct ulogd_pluginstance *upi)
+{
+	struct timeconv_priv *priv =
+			(struct timeconv_priv *)upi->private;
+	int fd;
+	ssize_t nread;
+	char buf[4096]; /* XXX: MAGIC NUMBER */
+	char *s = "ktime_get_real\n  .offset: ";
+	void *p;
+	size_t slen = strlen(s);
+
+	/* get rt offset */
+	fd = open(PROC_TIMER_LIST, O_RDONLY);
+	if (fd == -1)
+		return -1;
+	nread = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (nread == -1)
+		return -1;
+	p = memmem(buf, nread, s, slen);
+	if (p == NULL)
+		return -1;
+	if (sscanf(p + slen, " %"PRIu64, &priv->rtoffset) == EOF)
+		return -1;
+
+	/* select set function */
+	if (usec64_ce(upi->config_kset).u.value)
+		if (uptime_ce(upi->config_kset).u.value)
+			priv->setfunc = &set_ntp_uptime;
+		else
+			priv->setfunc = &set_ntp;
+	else if (uptime_ce(upi->config_kset).u.value)
+		priv->setfunc = &set_uptime;
+	else
+		return -1;
+
+	return 0;
+}
+
+static struct ulogd_plugin timeconv_plugin = {
+	.name = "TIMECONV",
+	.input = {
+		.keys = input_keys,
+		.num_keys = ARRAY_SIZE(input_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.output = {
+		.keys = output_keys,
+		.num_keys = ARRAY_SIZE(output_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.config_kset 	= &config_keys,
+	.interp		= &interp_timeconv,
+	.configure	= &configure_timeconv,
+	.start		= &start_timeconv,
+	.priv_size	= sizeof(struct timeconv_priv),
+	.version = VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&timeconv_plugin);
+}
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index fce5273..cb3bf45 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -442,10 +442,6 @@ static struct ulogd_key nfct_okeys[] = {
 		.type 	= ULOGD_RET_UINT32,
 		.flags 	= ULOGD_RETF_NONE,
 		.name	= "flow.start.usec",
-		.ipfix	= {
-			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowStartMicroSeconds,
-		},
 	},
 	{
 		.type	= ULOGD_RET_UINT32,
@@ -460,10 +456,6 @@ static struct ulogd_key nfct_okeys[] = {
 		.type	= ULOGD_RET_UINT32,
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "flow.end.usec",
-		.ipfix	= {
-			.vendor		= IPFIX_VENDOR_IETF,
-			.field_id	= IPFIX_flowEndMicroSeconds,
-		},
 	},
 	{
 		.type	= ULOGD_RET_UINT8,
-- 
1.9.1

