Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9183C10F14
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D011213F2
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfDHWak (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:30:40 -0400
Received: from mail.us.es ([193.147.175.20]:54810 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfDHWaj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 18:30:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A35B23066A0
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:30:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84A5CDA703
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:30:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7A550DA701; Tue,  9 Apr 2019 00:30:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98A47DA702;
        Tue,  9 Apr 2019 00:30:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 00:30:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6DC844265A31;
        Tue,  9 Apr 2019 00:30:30 +0200 (CEST)
Date:   Tue, 9 Apr 2019 00:30:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] IPFIX output plugin
Message-ID: <20190408223030.g42guehdptu5lfxo@salvia>
References: <523542b5-d629-54d9-2a90-468a9cb3aba7@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523542b5-d629-54d9-2a90-468a9cb3aba7@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ander,

On Tue, Apr 02, 2019 at 09:27:32AM +0200, Ander Juaristi wrote:
> Hi,
> 
> The attached patch provides an IPFIX output plugin for ulogd2.
> 
> This patch is functionally equivalent to that sent by Holger Eitzenberger
> (Astaro) some time ago. I've reworked it to make it compile under the
> current plugin framework, which has suffered some changes since then.
> 
> The current patch (being functionally equivalent) does not send IPFIX
> template records.

Yes, this is missing.

> This is not necessary if the collector knows the template in
> advance. However I plan to add such a feature in the following days
> (sending template records in the IPFIX sets), unless you tell me
> it's not necessary. I have already started working on it and another
> patch will follow soon.

Great, if you could send the build and send template too, that would
be good.

> I would also like to take this opportunity to introduce myself as a
> prospective GSoC student for Netfilter (on pending approval for gsoc13
> mailing list). I approached Pablo off-list on January asking for some
> pointers to undone work on Netfilter. I am interested in idea 1 and all of
> its subtasks, which, I suppose, would all form part of the same project. My
> intention is to start writing the GSoC proposal now, submit it before April
> 9 and then submit the second (definitive) patch for IPFIX some time later,
> before end of April, so that you could assess my coding skills based on this
> patch. Please let me know if you'd like me to proceed another way.

More comments below on this patch.

> From e4a2367ced2062ee6b00f33d890c830e702650e4 Mon Sep 17 00:00:00 2001
> From: Holger Eitzenberger <heitzenberger@astaro.com>
> Date: Fri, 30 Oct 2009 11:25:52 +0100

I'd suggest you use the existing date, also place yourself as the
patch author of this. Just say that "this is based on original work
from Holger Eitzenberger" in the patch description.

> Subject: [PATCH] IPFIX: Add IPFIX output plugin

Please add a description to this patch, including an example on how to
use this.

Please, tell us how you are testing this patch, we would like to see a
working version of the ipfix plugin in the tree.

IIRC,the existing plugin is incomplete, so it would be good to say
that you just decided to remove the incomplete one and provide one
that is working, if you can prove it, of course ;-)

> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> Signed-off-by: Ander Juaristi <a@juaristi.eus>
> ---
>  configure.ac                      |  11 +-
>  include/ulogd/ulogd.h             |   3 +
>  input/flow/ulogd_inpflow_IPFIX.c  |   2 -
>  output/Makefile.am                |   2 +-
>  output/ipfix/Makefile.am          |  12 +
>  output/ipfix/ipfix.c              | 153 +++++++++
>  output/ipfix/ipfix.h              |  89 +++++
>  output/ipfix/ulogd_output_IPFIX.c | 526 ++++++++++++++++++++++++++++
>  output/ulogd_output_IPFIX.c       | 546 ------------------------------
>  9 files changed, 794 insertions(+), 550 deletions(-)
>  delete mode 100644 input/flow/ulogd_inpflow_IPFIX.c
>  create mode 100644 output/ipfix/Makefile.am
>  create mode 100644 output/ipfix/ipfix.c
>  create mode 100644 output/ipfix/ipfix.h
>  create mode 100644 output/ipfix/ulogd_output_IPFIX.c
>  delete mode 100644 output/ulogd_output_IPFIX.c
> 
> diff --git a/configure.ac b/configure.ac
> index 3aa0624..cd9ac7e 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -150,6 +150,14 @@ else
>  	enable_jansson="no"
>  fi
>  
> +AC_ARG_WITH([ipfix], AS_HELP_STRING([--without-ipfix], [Build without IPFIX output plugin [default=test]]))
> +AM_CONDITIONAL([HAVE_IPFIX], [test "x$with_ipfix" != "xno"])
> +if test "x$with_ipfix" != "xno"; then
> +	enable_ipfix="yes"
> +else
> +	enable_ipfix="no"
> +fi

I think we don't need this knob. We don't have any external library
dependency, right? If not, please remove this.

> +
>  AC_ARG_WITH([ulogd2libdir],
>  	AS_HELP_STRING([--with-ulogd2libdir=PATH],
>          [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]]),
> @@ -179,7 +187,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
>  	  input/sum/Makefile \
>  	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
>  	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
> -	  output/dbi/Makefile \
> +	  output/dbi/Makefile output/ipfix/Makefile \
>  	  src/Makefile Makefile Rules.make)
>  AC_OUTPUT
>  
> @@ -214,5 +222,6 @@ Ulogd configuration:
>      SQLITE3 plugin:			${enable_sqlite3}
>      DBI plugin:				${enable_dbi}
>      JSON plugin:			${enable_jansson}
> +    IPFIX plugin:                       ${enable_ipfix}
>  "
>  echo "You can now run 'make' and 'make install'"
> diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
> index 2e38195..c017085 100644
> --- a/include/ulogd/ulogd.h
> +++ b/include/ulogd/ulogd.h
> @@ -28,6 +28,9 @@
>  
>  /* types without length */
>  #define ULOGD_RET_NONE		0x0000

Missing line break here.

> +#define __packed		__attribute__((packed))
> +#define __noreturn		__attribute__((noreturn))
> +#define __cold			__attribute__((cold))

__noreturn and __cold are not used. Remove them.

>  #define ULOGD_RET_INT8		0x0001
>  #define ULOGD_RET_INT16		0x0002
> diff --git a/input/flow/ulogd_inpflow_IPFIX.c b/input/flow/ulogd_inpflow_IPFIX.c
> deleted file mode 100644
> index 27ce5b2..0000000
> --- a/input/flow/ulogd_inpflow_IPFIX.c
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -/* */
> -
> diff --git a/output/Makefile.am b/output/Makefile.am
> index ff851ad..7ba8217 100644
> --- a/output/Makefile.am
> +++ b/output/Makefile.am
> @@ -2,7 +2,7 @@ AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
>                ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
>  AM_CFLAGS = ${regular_CFLAGS}
>  
> -SUBDIRS= pcap mysql pgsql sqlite3 dbi
> +SUBDIRS= pcap mysql pgsql sqlite3 dbi ipfix
>  
>  pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
>  			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
> diff --git a/output/ipfix/Makefile.am b/output/ipfix/Makefile.am
> new file mode 100644
> index 0000000..315f3b8
> --- /dev/null
> +++ b/output/ipfix/Makefile.am
> @@ -0,0 +1,11 @@
> +AM_CPPFLAGS = -I$(top_srcdir)/include
> +AM_CFLAGS = $(regular_CFLAGS)
> +
> +if HAVE_IPFIX
> +
> +pkglib_LTLIBRARIES = ulogd_output_IPFIX.la
> +
> +ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c ipfix.c
> +ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
> +
> +endif
> diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
> new file mode 100644
> index 0000000..d7006ca
> --- /dev/null
> +++ b/output/ipfix/ipfix.c
> @@ -0,0 +1,153 @@
> +/*
> + * ipfix.c
> + *
> + * Holger Eitzenberger, 2009.
> + */
> +
> +/* These forward declarations are needed since ulogd.h doesn't like to be the first */
> +#include <ulogd/linuxlist.h>
> +
> +#define __packed		__attribute__((packed))
> +#define __noreturn		__attribute__((noreturn))
> +#define __cold			__attribute__((cold))

This is redefined in ulogd.h

> +
> +#include "ipfix.h"
> +
> +#include <ulogd/ulogd.h>
> +#include <ulogd/common.h>
> +
> +struct ipfix_msg *
> +ipfix_msg_alloc(size_t len, uint32_t oid)
> +{
> +	struct ipfix_msg *msg;
> +	struct ipfix_hdr *hdr;
> +
> +	if (len < IPFIX_HDRLEN + IPFIX_SET_HDRLEN)
> +		return NULL;
> +
> +	msg = malloc(sizeof(struct ipfix_msg) + len);
> +	memset(msg, 0, sizeof(struct ipfix_msg));
> +	msg->tail = msg->data + IPFIX_HDRLEN;
> +	msg->end = msg->data + len;
> +
> +	hdr = ipfix_msg_hdr(msg);
> +	memset(hdr, 0, IPFIX_HDRLEN);
> +	hdr->version = htons(IPFIX_VERSION);
> +	hdr->oid = htonl(oid);
> +
> +	return msg;
> +}
> +
> +void
> +ipfix_msg_free(struct ipfix_msg *msg)
> +{
> +	if (!msg)
> +		return;
> +
> +	if (msg->nrecs > 0)
> +		ulogd_log(ULOGD_DEBUG, "%s: %d flows have been lost\n", __func__,
> +			msg->nrecs);
> +
> +	free(msg);
> +}
> +
> +struct ipfix_hdr *
> +ipfix_msg_hdr(const struct ipfix_msg *msg)

No need for line break, this should be fine:

struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *msg)

> +{
> +	return (struct ipfix_hdr *)msg->data;
> +}
> +
> +void *
> +ipfix_msg_data(struct ipfix_msg *msg)

same here and so on.

> +{
> +	return msg->data;
> +}
> +
> +size_t
> +ipfix_msg_len(const struct ipfix_msg *msg)
> +{
> +	return msg->tail - msg->data;
> +}
> +
> +struct ipfix_set_hdr *
> +ipfix_msg_add_set(struct ipfix_msg *msg, uint16_t sid)
> +{
> +	struct ipfix_set_hdr *shdr;
> +
> +	if (msg->end - msg->tail < (int) IPFIX_SET_HDRLEN)
> +		return NULL;
> +
> +	shdr = (struct ipfix_set_hdr *)msg->tail;
> +	shdr->id = sid;
> +	shdr->len = IPFIX_SET_HDRLEN;
> +	msg->tail += IPFIX_SET_HDRLEN;
> +	msg->last_set = shdr;
> +	return shdr;
> +}
> +
> +struct ipfix_set_hdr *
> +ipfix_msg_get_set(const struct ipfix_msg *msg)
> +{
> +	return msg->last_set;
> +}
> +
> +/**
> + * Add data record to an IPFIX message.  The data is accounted properly.
> + *
> + * @return pointer to data or %NULL if not that much space left.
> + */
> +void *
> +ipfix_msg_add_data(struct ipfix_msg *msg, size_t len)
> +{
> +	void *data;
> +
> +	if (!msg->last_set) {
> +		ulogd_log(ULOGD_FATAL, "msg->last_set is NULL\n");
> +		return NULL;
> +	}
> +
> +	if ((ssize_t) len > msg->end - msg->tail)
> +		return NULL;
> +
> +	data = msg->tail;
> +	msg->tail += len;
> +	msg->nrecs++;
> +	msg->last_set->len += len;
> +
> +	return data;
> +}
> +
> +/* check and dump message */
> +int
> +ipfix_dump_msg(const struct ipfix_msg *msg)
> +{
> +	const struct ipfix_hdr *hdr = ipfix_msg_hdr(msg);
> +	const struct ipfix_set_hdr *shdr = (struct ipfix_set_hdr *) hdr->data;
> +
> +	if (ntohs(hdr->len) < IPFIX_HDRLEN) {
> +		ulogd_log(ULOGD_FATAL, "Invalid IPFIX message header length\n");
> +		return -1;
> +	}
> +	if (ipfix_msg_len(msg) != IPFIX_HDRLEN + ntohs(shdr->len)) {
> +		ulogd_log(ULOGD_FATAL, "Invalid IPFIX message length\n");
> +		return -1;
> +	}
> +
> +	ulogd_log(ULOGD_DEBUG, "msg: ver=%#x len=%#x t=%#x seq=%#x oid=%d\n",
> +			  ntohs(hdr->version), ntohs(hdr->len), htonl(hdr->time),
> +			  ntohl(hdr->seqno), ntohl(hdr->oid));
> +
> +	return 0;
> +}
> +
> +/* template management */
> +size_t
> +ipfix_rec_len(uint16_t sid)
> +{
> +	if (sid != htons(VY_IPFIX_SID)) {
> +		ulogd_log(ULOGD_FATAL, "Invalid SID\n");
> +		return 0;
> +	}
> +
> +	return sizeof(struct vy_ipfix_data);
> +}
> diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
> new file mode 100644
> index 0000000..cdb5a6f
> --- /dev/null
> +++ b/output/ipfix/ipfix.h
> @@ -0,0 +1,89 @@
> +/*
> + * ipfix.h
> + *
> + * Holger Eitzenberger <holger@eitzenberger.org>, 2009.
> + */
> +#ifndef IPFIX_H
> +#define IPFIX_H
> +
> +#include <stdint.h>
> +#include <netinet/in.h>
> +
> +
> +struct ipfix_hdr {
> +#define IPFIX_VERSION			0xa
> +	uint16_t version;
> +	uint16_t len;
> +	uint32_t time;
> +	uint32_t seqno;
> +	uint32_t oid;				/* Observation Domain ID */
> +	uint8_t data[];
> +} __packed;
> +
> +#define IPFIX_HDRLEN	sizeof(struct ipfix_hdr)
> +
> +/*
> + * IDs 0-255 are reserved for Template Sets.  IDs of Data Sets are > 255.
> + */
> +struct ipfix_templ_hdr {
> +	uint16_t id;
> +	uint16_t cnt;
> +	uint8_t data[];
> +} __packed;
> +
> +struct ipfix_set_hdr {
> +#define IPFIX_SET_TEMPL			2
> +#define IPFIX_SET_OPT_TEMPL		3
> +	uint16_t id;
> +	uint16_t len;
> +	uint8_t data[];
> +} __packed;
> +
> +#define IPFIX_SET_HDRLEN		sizeof(struct ipfix_set_hdr)
> +
> +struct ipfix_msg {
> +	struct llist_head link;
> +	uint8_t *tail;
> +	uint8_t *end;
> +	unsigned nrecs;
> +	struct ipfix_set_hdr *last_set;
> +	uint8_t data[];
> +};
> +
> +struct vy_ipfix_data {
> +	struct in_addr saddr;
> +	struct in_addr daddr;
> +	uint16_t ifi_in;
> +	uint16_t ifi_out;
> +	uint32_t packets;
> +	uint32_t bytes;
> +	uint32_t start;				/* Unix time */
> +	uint32_t end;				/* Unix time */
> +	uint16_t sport;
> +	uint16_t dport;
> +	uint32_t aid;				/* Application ID */
> +	uint8_t l4_proto;
> +	uint8_t dscp;
> +	uint16_t __padding;
> +} __packed;
> +
> +#define VY_IPFIX_SID		256
> +
> +#define VY_IPFIX_FLOWS		36
> +#define VY_IPFIX_PKT_LEN	(IPFIX_HDRLEN + IPFIX_SET_HDRLEN \
> +							 + VY_IPFIX_FLOWS * sizeof(struct vy_ipfix_data))
> +
> +/* template management */
> +size_t ipfix_rec_len(uint16_t);
> +
> +/* message handling */
> +struct ipfix_msg *ipfix_msg_alloc(size_t, uint32_t);
> +void ipfix_msg_free(struct ipfix_msg *);
> +struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *);
> +size_t ipfix_msg_len(const struct ipfix_msg *);
> +void *ipfix_msg_data(struct ipfix_msg *);
> +struct ipfix_set_hdr *ipfix_msg_add_set(struct ipfix_msg *, uint16_t);
> +void *ipfix_msg_add_data(struct ipfix_msg *, size_t);
> +int ipfix_dump_msg(const struct ipfix_msg *);
> +
> +#endif /* IPFIX_H */
> diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
> new file mode 100644
> index 0000000..02bc21f
> --- /dev/null
> +++ b/output/ipfix/ulogd_output_IPFIX.c
> @@ -0,0 +1,526 @@
> +/*
> + * ulogd_output_IPFIX.c
> + *
> + * ulogd IPFIX Exporter plugin.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG 2009
> + */
> +#include <unistd.h>
> +#include <time.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <arpa/inet.h>
> +#include <netdb.h>
> +#include <ulogd/ulogd.h>
> +#include <ulogd/common.h>
> +
> +#include "ipfix.h"
> +
> +#define DEFAULT_MTU		512 /* RFC 5101, 10.3.3 */
> +#define DEFAULT_PORT		4739 /* RFC 5101, 10.3.4 */
> +#define DEFAULT_SPORT		4740
> +
> +enum {
> +	OID_CE = 0,
> +	HOST_CE,
> +	PORT_CE,
> +	PROTO_CE,
> +	MTU_CE,
> +};
> +
> +#define oid_ce(x)	(x->ces[OID_CE])
> +#define host_ce(x)	(x->ces[HOST_CE])
> +#define port_ce(x)	(x->ces[PORT_CE])
> +#define proto_ce(x)	(x->ces[PROTO_CE])
> +#define mtu_ce(x)	(x->ces[MTU_CE])
> +
> +static const struct config_keyset ipfix_kset = {
> +	.num_ces = 5,
> +	.ces = {
> +		{
> +			.key = "oid",
> +			.type = CONFIG_TYPE_INT,
> +			.u.value = 0
> +		},
> +		{
> +			.key = "host",
> +			.type = CONFIG_TYPE_STRING,
> +			.u.string = ""
> +		},
> +		{
> +			.key = "port",
> +			.type = CONFIG_TYPE_INT,
> +			.u.value = DEFAULT_PORT
> +		},
> +		{
> +			.key = "proto",
> +			.type = CONFIG_TYPE_STRING,
> +			.u.string = "tcp"
> +		},
> +		{
> +			.key = "mtu",
> +			.type = CONFIG_TYPE_INT,
> +			.u.value = DEFAULT_MTU
> +		}
> +	}
> +};
> +
> +struct ipfix_templ {
> +	struct ipfix_templ *next;
> +};
> +
> +struct ipfix_priv {
> +	struct ulogd_fd ufd;
> +	uint32_t seqno;
> +	struct ipfix_msg *msg;		/* current message */
> +	struct llist_head list;
> +	struct ipfix_templ *templates;
> +	int proto;
> +	struct ulogd_timer timer;
> +	struct sockaddr_in sa;
> +};
> +
> +enum {
> +	InIpSaddr = 0,
> +	InIpDaddr,
> +	InRawInPktCount,
> +	InRawInPktLen,
> +	InRawOutPktCount,
> +	InRawOutPktLen,
> +	InFlowStartSec,
> +	InFlowStartUsec,
> +	InFlowEndSec,
> +	InFlowEndUsec,
> +	InL4SPort,
> +	InL4DPort,
> +	InIpProto,
> +	InCtMark
> +};
> +
> +static struct ulogd_key ipfix_in_keys[] = {
> +		[InIpSaddr] = {
> +			.type = ULOGD_RET_IPADDR,
> +			.name = "orig.ip.saddr"
> +		},
> +		[InIpDaddr] = {
> +			.type = ULOGD_RET_IPADDR,
> +			.name = "orig.ip.daddr"
> +		},
> +		[InRawInPktCount] = {
> +			.type = ULOGD_RET_UINT64,
> +			.name = "orig.raw.pktcount"
> +		},
> +		[InRawInPktLen] = {
> +			.type = ULOGD_RET_UINT64,
> +			.name = "orig.raw.pktlen"
> +		},
> +		[InRawOutPktCount] = {
> +			.type = ULOGD_RET_UINT64,
> +			.name = "reply.raw.pktcount"
> +		},
> +		[InRawOutPktLen] = {
> +			.type = ULOGD_RET_UINT64,
> +			.name = "reply.raw.pktlen"
> +		},
> +		[InFlowStartSec] = {
> +			.type = ULOGD_RET_UINT32,
> +			.name = "flow.start.sec"
> +		},
> +		[InFlowStartUsec] = {
> +			.type = ULOGD_RET_UINT32,
> +			.name = "flow.start.usec"
> +		},
> +		[InFlowEndSec] = {
> +			.type = ULOGD_RET_UINT32,
> +			.name = "flow.end.sec"
> +		},
> +		[InFlowEndUsec] = {
> +			.type = ULOGD_RET_UINT32,
> +			.name = "flow.end.usec"
> +		},
> +		[InL4SPort] = {
> +			.type = ULOGD_RET_UINT16,
> +			.name = "orig.l4.sport"
> +		},
> +		[InL4DPort] = {
> +			.type = ULOGD_RET_UINT16,
> +			.name = "orig.l4.dport"
> +		},
> +		[InIpProto] = {
> +			.type = ULOGD_RET_UINT8,
> +			.name = "orig.ip.protocol"
> +		},
> +		[InCtMark] = {
> +			.type = ULOGD_RET_UINT32,
> +			.name = "ct.mark"
> +		}
> +};
> +
> +/* do some polishing and enqueue it */
> +static void
> +enqueue_msg(struct ipfix_priv *priv, struct ipfix_msg *msg)
> +{
> +	struct ipfix_hdr *hdr = ipfix_msg_data(msg);
> +
> +	if (!msg)
> +		return;
> +
> +	hdr->time = htonl(time(NULL));
> +	hdr->seqno = htonl(priv->seqno += msg->nrecs);
> +	if (msg->last_set) {
> +		msg->last_set->id = htons(msg->last_set->id);
> +		msg->last_set->len = htons(msg->last_set->len);
> +		msg->last_set = NULL;
> +	}
> +	hdr->len = htons(ipfix_msg_len(msg));
> +
> +	llist_add(&msg->link, &priv->list);
> +}
> +
> +/**
> + * @return %ULOGD_IRET_OK or error value
> + */
> +static int
> +send_msgs(struct ulogd_pluginstance *pi)
> +{
> +	struct ipfix_msg *msg;
> +	struct llist_head *curr, *tmp;
> +	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;

Please, reverse xmas tree in variable definition for new code is preferred, ie.

	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
	struct llist_head *curr, *tmp;
	struct ipfix_msg *msg;

ie. From larger line to shorter line.

> +	int ret = ULOGD_IRET_OK;
> +
> +	llist_for_each_prev(curr, &priv->list) {
> +		int ret;

This is shadowing the previous 'int ret' definition.

> +		msg = llist_entry(curr, struct ipfix_msg, link);
> +
> +		ret = send(priv->ufd.fd, ipfix_msg_data(msg), ipfix_msg_len(msg), 0);
> +		if (ret < 0) {
> +			ulogd_log(ULOGD_ERROR, "send: %m\n");
> +
> +			if (errno == EAGAIN || errno == EINTR)

Socket is in blocking mode, I see not fcntl to make it enter
non-blocking mode, so I guess this is not needed.

> +				goto done;
> +			else
> +				ret = ULOGD_IRET_ERR;
> +
> +			goto done;
> +		}
> +
> +		/* TODO handle short send() for other protocols */
> +		if ((size_t) ret < ipfix_msg_len(msg))
> +			ulogd_log(ULOGD_ERROR, "short send: %d < %d\n",
> +					ret, ipfix_msg_len(msg));
> +	}
> +
> +	llist_for_each_safe(curr, tmp, &priv->list) {
> +		msg = llist_entry(curr, struct ipfix_msg, link);
> +		llist_del(curr);
> +		msg->nrecs = 0;
> +		ipfix_msg_free(msg);
> +	}
> +
> +done:
> +	return ret;
> +}
> +
> +static int
> +ipfix_ufd_cb(int fd, unsigned what, void *arg)
> +{
> +	struct ulogd_pluginstance *pi = arg;
> +	struct ipfix_priv *priv = (struct ipfix_priv *) pi->private;
> +	char buf[16];
> +	ssize_t nread;
> +
> +	if (what & ULOGD_FD_READ) {
> +		nread = recv(priv->ufd.fd, buf, sizeof(buf), MSG_DONTWAIT);
> +		if (nread < 0) {
> +			ulogd_log(ULOGD_ERROR, "recv: %m\n");
> +			if (errno == EWOULDBLOCK || errno == EINTR)

Same comment here as above.

> +				goto done;
> +		} else if (!nread) {
> +			ulogd_log(ULOGD_INFO, "connection reset by peer\n");
> +			ulogd_unregister_fd(&priv->ufd);
> +		} else
> +			ulogd_log(ULOGD_INFO, "unexpected data (%d bytes)\n", nread);
> +	}
> +
> +done:
> +	return 0;
> +}
> +
> +static void
> +ipfix_timer_cb(struct ulogd_timer *t, void *data)
> +{
> +	struct ulogd_pluginstance *pi = data;
> +	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
> +
> +	if (priv->msg && priv->msg->nrecs > 0) {
> +		enqueue_msg(priv, priv->msg);
> +		priv->msg = NULL;
> +

No need for empty line here above.

> +		send_msgs(pi);
> +	}
> +}
> +
> +static int
> +ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pluginstance_stack *stack)
> +{
> +	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
> +	char addr[16];
> +	int oid, port, mtu, ret;
> +	char *host = NULL, *proto = NULL;

Reverse xmas tree here again.

No need to initialize proto and host to NULL.

> +
> +	ret = config_parse_file(pi->id, pi->config_kset);
> +	if (ret < 0)
> +		return ret;
> +
> +	oid = oid_ce(pi->config_kset).u.value;
> +	host = host_ce(pi->config_kset).u.string;
> +	port = port_ce(pi->config_kset).u.value;
> +	proto = proto_ce(pi->config_kset).u.string;
> +	mtu = mtu_ce(pi->config_kset).u.value;
> +
> +	if (!oid) {
> +		ulogd_log(ULOGD_FATAL, "invalid Observation ID\n");
> +		return ULOGD_IRET_ERR;
> +	}
> +	if (!host || !strcmp(host, "")) {
> +		ulogd_log(ULOGD_FATAL, "no destination host specified\n");
> +		return ULOGD_IRET_ERR;
> +	}
> +
> +	if (!strcmp(proto, "udp")) {
> +		priv->proto = IPPROTO_UDP;
> +	} else if (!strcmp(proto, "tcp")) {
> +		priv->proto = IPPROTO_TCP;
> +	} else {
> +		ulogd_log(ULOGD_FATAL, "unsupported protocol '%s'\n", proto);
> +		return ULOGD_IRET_ERR;
> +	}
> +
> +	memset(&priv->sa, 0, sizeof(priv->sa));
> +	priv->sa.sin_family = AF_INET;
> +	priv->sa.sin_port = htons(port);
> +	ret = inet_pton(AF_INET, host, &priv->sa.sin_addr);
> +	if (ret < 0) {
> +		ulogd_log(ULOGD_FATAL, "inet_pton: %m\n");
> +		return ULOGD_IRET_ERR;
> +	} else if (!ret) {
> +		ulogd_log(ULOGD_FATAL, "host: invalid address '%s'\n", host);
> +		return ULOGD_IRET_ERR;
> +	}

You can just probably simplify this to:

	ret = inet_pton(AF_INET, host, &priv->sa.sin_addr);
	if (ret <= 0) {
                ...

to check for errors.

> +
> +	INIT_LLIST_HEAD(&priv->list);
> +
> +	ulogd_init_timer(&priv->timer, pi, ipfix_timer_cb);
> +
> +	ulogd_log(ULOGD_INFO, "using IPFIX Collector at %s:%d (MTU %d)\n",
> +			inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
> +			port, mtu);

Better align function parameters to parens, ie.

	ulogd_log(ULOGD_INFO, "using IPFIX Collector at %s:%d (MTU %d)\n",
                  inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
                  port, mtu);

Please, send a version 2.

Thanks.
