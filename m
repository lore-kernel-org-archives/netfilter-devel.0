Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A26FC10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 13:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC50C21773
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 13:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbfDXNjQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:39:16 -0400
Received: from fnsib-smtp07.srv.cat ([46.16.61.66]:51322 "EHLO
        fnsib-smtp07.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730425AbfDXNjP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 09:39:15 -0400
Received: from [192.168.4.135] (242.red-83-48-67.staticip.rima-tde.net [83.48.67.242])
        by fnsib-smtp07.srv.cat (Postfix) with ESMTPSA id E69928008;
        Wed, 24 Apr 2019 15:39:02 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
Subject: Re: [PATCH] IPFIX output plugin
References: <523542b5-d629-54d9-2a90-468a9cb3aba7@juaristi.eus>
 <20190408223030.g42guehdptu5lfxo@salvia>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Message-ID: <ff9181aa-3027-f0a2-75a4-052a7792fc7c@juaristi.eus>
Date:   Wed, 24 Apr 2019 15:39:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190408223030.g42guehdptu5lfxo@salvia>
Content-Type: multipart/mixed;
 boundary="------------B953909ADB0D2D618A75AE15"
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------B953909ADB0D2D618A75AE15
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I'm following up on this. I'd say this is complete and I don't plan to 
introduce further significant changes. Maybe just small fixes. I attach 
two patches, tell me if you'd rather have them as a single patch.

The first patch applies the cosmetic changes suggested by Pablo.

The second patch generates and sends template records, introducing a new 
'send_template' config parameter, and fixes the data record's layout, as 
it was previously broken. It also puts my author name in the source 
files together with Holger's.

The 'send_template' parameter tells whether a template record should be 
sent. It can have the following string values: "once" (default), 
"always" and "never".

With "once", a template is sent with the first record set. Subsequent 
sets will only contain data records as the collector is assumed to 
already by aware of the template (this is ok). The values "always" and 
"never" do what you probably already expect.


I am currently testing this with the NFCT input and Wireshark.

Place the following in ulogd.conf:

      # this will print all flows on screen
      loglevel=1

      # load NFCT and IPFIX plugins
      plugin="/lib/ulogd/ulogd_inpflow_NFCT.so"
      plugin="/lib/ulogd/ulogd_output_IPFIX.so"

      stack=ct1:NFCT,ipfix1:IPFIX

      [ct1]
      netlink_socket_buffer_size=217088
      netlink_socket_buffer_maxsize=1085440
      accept_proto_filter=tcp,sctp

      [ipfix1]
      oid=1
      host="127.0.0.1"
      #port=4739
      #send_template="once"

I am currently testing it by launching a plain NetCat listener on port 
4739 (the default for IPFIX) and then running Wireshark and see that it 
dissects the IPFIX/NetFlow traffic correctly (obviously this relies on 
the Wireshark NetFlow dissector being correct).

First:

      nc -vvvv -l 127.0.0.1 4739

Then:

      sudo ulogd -vc ulogd.conf

At this point IPFIX/NetFlow traffic should be sent to NetCat (which will 
print garbage as it's a binary protocol). It may take some time until 
traffic is actually sent, as captured flows are buffered until the 
buffer is filled. The buffer's length can be changed with the 'mtu' 
config parameter in ulogd.conf (it's 512 by default).

Currently Wireshark correctly dissects all the traffic.

IPFIX collector software is unfortunately not as widespread as for other 
protocols.

I am looking for free/open-source IPFIX collectors out there to better 
test this. I've found one at [0], but if someone has a better idea just 
let me know. I'll try it and test it against it in the following days 
and will send further patches fixing bugs should problems arise.

[0] https://github.com/CESNET/ipfixcol2

On 9/4/19 0:30, Pablo Neira Ayuso wrote:
> Hi Ander,
> 
> On Tue, Apr 02, 2019 at 09:27:32AM +0200, Ander Juaristi wrote:
>> Hi,
>>
>> The attached patch provides an IPFIX output plugin for ulogd2.
>>
>> This patch is functionally equivalent to that sent by Holger Eitzenberger
>> (Astaro) some time ago. I've reworked it to make it compile under the
>> current plugin framework, which has suffered some changes since then.
>>
>> The current patch (being functionally equivalent) does not send IPFIX
>> template records.
> 
> Yes, this is missing.
> 
>> This is not necessary if the collector knows the template in
>> advance. However I plan to add such a feature in the following days
>> (sending template records in the IPFIX sets), unless you tell me
>> it's not necessary. I have already started working on it and another
>> patch will follow soon.
> 
> Great, if you could send the build and send template too, that would
> be good.
> 
>> I would also like to take this opportunity to introduce myself as a
>> prospective GSoC student for Netfilter (on pending approval for gsoc13
>> mailing list). I approached Pablo off-list on January asking for some
>> pointers to undone work on Netfilter. I am interested in idea 1 and all of
>> its subtasks, which, I suppose, would all form part of the same project. My
>> intention is to start writing the GSoC proposal now, submit it before April
>> 9 and then submit the second (definitive) patch for IPFIX some time later,
>> before end of April, so that you could assess my coding skills based on this
>> patch. Please let me know if you'd like me to proceed another way.
> 
> More comments below on this patch.
> 
>>  From e4a2367ced2062ee6b00f33d890c830e702650e4 Mon Sep 17 00:00:00 2001
>> From: Holger Eitzenberger <heitzenberger@astaro.com>
>> Date: Fri, 30 Oct 2009 11:25:52 +0100
> 
> I'd suggest you use the existing date, also place yourself as the
> patch author of this. Just say that "this is based on original work
> from Holger Eitzenberger" in the patch description.
> 
>> Subject: [PATCH] IPFIX: Add IPFIX output plugin
> 
> Please add a description to this patch, including an example on how to
> use this.
> 
> Please, tell us how you are testing this patch, we would like to see a
> working version of the ipfix plugin in the tree.
> 
> IIRC,the existing plugin is incomplete, so it would be good to say
> that you just decided to remove the incomplete one and provide one
> that is working, if you can prove it, of course ;-)
> 
>> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
>> Signed-off-by: Ander Juaristi <a@juaristi.eus>
>> ---
>>   configure.ac                      |  11 +-
>>   include/ulogd/ulogd.h             |   3 +
>>   input/flow/ulogd_inpflow_IPFIX.c  |   2 -
>>   output/Makefile.am                |   2 +-
>>   output/ipfix/Makefile.am          |  12 +
>>   output/ipfix/ipfix.c              | 153 +++++++++
>>   output/ipfix/ipfix.h              |  89 +++++
>>   output/ipfix/ulogd_output_IPFIX.c | 526 ++++++++++++++++++++++++++++
>>   output/ulogd_output_IPFIX.c       | 546 ------------------------------
>>   9 files changed, 794 insertions(+), 550 deletions(-)
>>   delete mode 100644 input/flow/ulogd_inpflow_IPFIX.c
>>   create mode 100644 output/ipfix/Makefile.am
>>   create mode 100644 output/ipfix/ipfix.c
>>   create mode 100644 output/ipfix/ipfix.h
>>   create mode 100644 output/ipfix/ulogd_output_IPFIX.c
>>   delete mode 100644 output/ulogd_output_IPFIX.c
>>
>> diff --git a/configure.ac b/configure.ac
>> index 3aa0624..cd9ac7e 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -150,6 +150,14 @@ else
>>   	enable_jansson="no"
>>   fi
>>   
>> +AC_ARG_WITH([ipfix], AS_HELP_STRING([--without-ipfix], [Build without IPFIX output plugin [default=test]]))
>> +AM_CONDITIONAL([HAVE_IPFIX], [test "x$with_ipfix" != "xno"])
>> +if test "x$with_ipfix" != "xno"; then
>> +	enable_ipfix="yes"
>> +else
>> +	enable_ipfix="no"
>> +fi
> 
> I think we don't need this knob. We don't have any external library
> dependency, right? If not, please remove this.
> 
>> +
>>   AC_ARG_WITH([ulogd2libdir],
>>   	AS_HELP_STRING([--with-ulogd2libdir=PATH],
>>           [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]]),
>> @@ -179,7 +187,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
>>   	  input/sum/Makefile \
>>   	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
>>   	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
>> -	  output/dbi/Makefile \
>> +	  output/dbi/Makefile output/ipfix/Makefile \
>>   	  src/Makefile Makefile Rules.make)
>>   AC_OUTPUT
>>   
>> @@ -214,5 +222,6 @@ Ulogd configuration:
>>       SQLITE3 plugin:			${enable_sqlite3}
>>       DBI plugin:				${enable_dbi}
>>       JSON plugin:			${enable_jansson}
>> +    IPFIX plugin:                       ${enable_ipfix}
>>   "
>>   echo "You can now run 'make' and 'make install'"
>> diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
>> index 2e38195..c017085 100644
>> --- a/include/ulogd/ulogd.h
>> +++ b/include/ulogd/ulogd.h
>> @@ -28,6 +28,9 @@
>>   
>>   /* types without length */
>>   #define ULOGD_RET_NONE		0x0000
> 
> Missing line break here.
> 
>> +#define __packed		__attribute__((packed))
>> +#define __noreturn		__attribute__((noreturn))
>> +#define __cold			__attribute__((cold))
> 
> __noreturn and __cold are not used. Remove them.
> 
>>   #define ULOGD_RET_INT8		0x0001
>>   #define ULOGD_RET_INT16		0x0002
>> diff --git a/input/flow/ulogd_inpflow_IPFIX.c b/input/flow/ulogd_inpflow_IPFIX.c
>> deleted file mode 100644
>> index 27ce5b2..0000000
>> --- a/input/flow/ulogd_inpflow_IPFIX.c
>> +++ /dev/null
>> @@ -1,2 +0,0 @@
>> -/* */
>> -
>> diff --git a/output/Makefile.am b/output/Makefile.am
>> index ff851ad..7ba8217 100644
>> --- a/output/Makefile.am
>> +++ b/output/Makefile.am
>> @@ -2,7 +2,7 @@ AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
>>                 ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
>>   AM_CFLAGS = ${regular_CFLAGS}
>>   
>> -SUBDIRS= pcap mysql pgsql sqlite3 dbi
>> +SUBDIRS= pcap mysql pgsql sqlite3 dbi ipfix
>>   
>>   pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
>>   			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
>> diff --git a/output/ipfix/Makefile.am b/output/ipfix/Makefile.am
>> new file mode 100644
>> index 0000000..315f3b8
>> --- /dev/null
>> +++ b/output/ipfix/Makefile.am
>> @@ -0,0 +1,11 @@
>> +AM_CPPFLAGS = -I$(top_srcdir)/include
>> +AM_CFLAGS = $(regular_CFLAGS)
>> +
>> +if HAVE_IPFIX
>> +
>> +pkglib_LTLIBRARIES = ulogd_output_IPFIX.la
>> +
>> +ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c ipfix.c
>> +ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
>> +
>> +endif
>> diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
>> new file mode 100644
>> index 0000000..d7006ca
>> --- /dev/null
>> +++ b/output/ipfix/ipfix.c
>> @@ -0,0 +1,153 @@
>> +/*
>> + * ipfix.c
>> + *
>> + * Holger Eitzenberger, 2009.
>> + */
>> +
>> +/* These forward declarations are needed since ulogd.h doesn't like to be the first */
>> +#include <ulogd/linuxlist.h>
>> +
>> +#define __packed		__attribute__((packed))
>> +#define __noreturn		__attribute__((noreturn))
>> +#define __cold			__attribute__((cold))
> 
> This is redefined in ulogd.h
> 
>> +
>> +#include "ipfix.h"
>> +
>> +#include <ulogd/ulogd.h>
>> +#include <ulogd/common.h>
>> +
>> +struct ipfix_msg *
>> +ipfix_msg_alloc(size_t len, uint32_t oid)
>> +{
>> +	struct ipfix_msg *msg;
>> +	struct ipfix_hdr *hdr;
>> +
>> +	if (len < IPFIX_HDRLEN + IPFIX_SET_HDRLEN)
>> +		return NULL;
>> +
>> +	msg = malloc(sizeof(struct ipfix_msg) + len);
>> +	memset(msg, 0, sizeof(struct ipfix_msg));
>> +	msg->tail = msg->data + IPFIX_HDRLEN;
>> +	msg->end = msg->data + len;
>> +
>> +	hdr = ipfix_msg_hdr(msg);
>> +	memset(hdr, 0, IPFIX_HDRLEN);
>> +	hdr->version = htons(IPFIX_VERSION);
>> +	hdr->oid = htonl(oid);
>> +
>> +	return msg;
>> +}
>> +
>> +void
>> +ipfix_msg_free(struct ipfix_msg *msg)
>> +{
>> +	if (!msg)
>> +		return;
>> +
>> +	if (msg->nrecs > 0)
>> +		ulogd_log(ULOGD_DEBUG, "%s: %d flows have been lost\n", __func__,
>> +			msg->nrecs);
>> +
>> +	free(msg);
>> +}
>> +
>> +struct ipfix_hdr *
>> +ipfix_msg_hdr(const struct ipfix_msg *msg)
> 
> No need for line break, this should be fine:
> 
> struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *msg)
> 
>> +{
>> +	return (struct ipfix_hdr *)msg->data;
>> +}
>> +
>> +void *
>> +ipfix_msg_data(struct ipfix_msg *msg)
> 
> same here and so on.
> 
>> +{
>> +	return msg->data;
>> +}
>> +
>> +size_t
>> +ipfix_msg_len(const struct ipfix_msg *msg)
>> +{
>> +	return msg->tail - msg->data;
>> +}
>> +
>> +struct ipfix_set_hdr *
>> +ipfix_msg_add_set(struct ipfix_msg *msg, uint16_t sid)
>> +{
>> +	struct ipfix_set_hdr *shdr;
>> +
>> +	if (msg->end - msg->tail < (int) IPFIX_SET_HDRLEN)
>> +		return NULL;
>> +
>> +	shdr = (struct ipfix_set_hdr *)msg->tail;
>> +	shdr->id = sid;
>> +	shdr->len = IPFIX_SET_HDRLEN;
>> +	msg->tail += IPFIX_SET_HDRLEN;
>> +	msg->last_set = shdr;
>> +	return shdr;
>> +}
>> +
>> +struct ipfix_set_hdr *
>> +ipfix_msg_get_set(const struct ipfix_msg *msg)
>> +{
>> +	return msg->last_set;
>> +}
>> +
>> +/**
>> + * Add data record to an IPFIX message.  The data is accounted properly.
>> + *
>> + * @return pointer to data or %NULL if not that much space left.
>> + */
>> +void *
>> +ipfix_msg_add_data(struct ipfix_msg *msg, size_t len)
>> +{
>> +	void *data;
>> +
>> +	if (!msg->last_set) {
>> +		ulogd_log(ULOGD_FATAL, "msg->last_set is NULL\n");
>> +		return NULL;
>> +	}
>> +
>> +	if ((ssize_t) len > msg->end - msg->tail)
>> +		return NULL;
>> +
>> +	data = msg->tail;
>> +	msg->tail += len;
>> +	msg->nrecs++;
>> +	msg->last_set->len += len;
>> +
>> +	return data;
>> +}
>> +
>> +/* check and dump message */
>> +int
>> +ipfix_dump_msg(const struct ipfix_msg *msg)
>> +{
>> +	const struct ipfix_hdr *hdr = ipfix_msg_hdr(msg);
>> +	const struct ipfix_set_hdr *shdr = (struct ipfix_set_hdr *) hdr->data;
>> +
>> +	if (ntohs(hdr->len) < IPFIX_HDRLEN) {
>> +		ulogd_log(ULOGD_FATAL, "Invalid IPFIX message header length\n");
>> +		return -1;
>> +	}
>> +	if (ipfix_msg_len(msg) != IPFIX_HDRLEN + ntohs(shdr->len)) {
>> +		ulogd_log(ULOGD_FATAL, "Invalid IPFIX message length\n");
>> +		return -1;
>> +	}
>> +
>> +	ulogd_log(ULOGD_DEBUG, "msg: ver=%#x len=%#x t=%#x seq=%#x oid=%d\n",
>> +			  ntohs(hdr->version), ntohs(hdr->len), htonl(hdr->time),
>> +			  ntohl(hdr->seqno), ntohl(hdr->oid));
>> +
>> +	return 0;
>> +}
>> +
>> +/* template management */
>> +size_t
>> +ipfix_rec_len(uint16_t sid)
>> +{
>> +	if (sid != htons(VY_IPFIX_SID)) {
>> +		ulogd_log(ULOGD_FATAL, "Invalid SID\n");
>> +		return 0;
>> +	}
>> +
>> +	return sizeof(struct vy_ipfix_data);
>> +}
>> diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
>> new file mode 100644
>> index 0000000..cdb5a6f
>> --- /dev/null
>> +++ b/output/ipfix/ipfix.h
>> @@ -0,0 +1,89 @@
>> +/*
>> + * ipfix.h
>> + *
>> + * Holger Eitzenberger <holger@eitzenberger.org>, 2009.
>> + */
>> +#ifndef IPFIX_H
>> +#define IPFIX_H
>> +
>> +#include <stdint.h>
>> +#include <netinet/in.h>
>> +
>> +
>> +struct ipfix_hdr {
>> +#define IPFIX_VERSION			0xa
>> +	uint16_t version;
>> +	uint16_t len;
>> +	uint32_t time;
>> +	uint32_t seqno;
>> +	uint32_t oid;				/* Observation Domain ID */
>> +	uint8_t data[];
>> +} __packed;
>> +
>> +#define IPFIX_HDRLEN	sizeof(struct ipfix_hdr)
>> +
>> +/*
>> + * IDs 0-255 are reserved for Template Sets.  IDs of Data Sets are > 255.
>> + */
>> +struct ipfix_templ_hdr {
>> +	uint16_t id;
>> +	uint16_t cnt;
>> +	uint8_t data[];
>> +} __packed;
>> +
>> +struct ipfix_set_hdr {
>> +#define IPFIX_SET_TEMPL			2
>> +#define IPFIX_SET_OPT_TEMPL		3
>> +	uint16_t id;
>> +	uint16_t len;
>> +	uint8_t data[];
>> +} __packed;
>> +
>> +#define IPFIX_SET_HDRLEN		sizeof(struct ipfix_set_hdr)
>> +
>> +struct ipfix_msg {
>> +	struct llist_head link;
>> +	uint8_t *tail;
>> +	uint8_t *end;
>> +	unsigned nrecs;
>> +	struct ipfix_set_hdr *last_set;
>> +	uint8_t data[];
>> +};
>> +
>> +struct vy_ipfix_data {
>> +	struct in_addr saddr;
>> +	struct in_addr daddr;
>> +	uint16_t ifi_in;
>> +	uint16_t ifi_out;
>> +	uint32_t packets;
>> +	uint32_t bytes;
>> +	uint32_t start;				/* Unix time */
>> +	uint32_t end;				/* Unix time */
>> +	uint16_t sport;
>> +	uint16_t dport;
>> +	uint32_t aid;				/* Application ID */
>> +	uint8_t l4_proto;
>> +	uint8_t dscp;
>> +	uint16_t __padding;
>> +} __packed;
>> +
>> +#define VY_IPFIX_SID		256
>> +
>> +#define VY_IPFIX_FLOWS		36
>> +#define VY_IPFIX_PKT_LEN	(IPFIX_HDRLEN + IPFIX_SET_HDRLEN \
>> +							 + VY_IPFIX_FLOWS * sizeof(struct vy_ipfix_data))
>> +
>> +/* template management */
>> +size_t ipfix_rec_len(uint16_t);
>> +
>> +/* message handling */
>> +struct ipfix_msg *ipfix_msg_alloc(size_t, uint32_t);
>> +void ipfix_msg_free(struct ipfix_msg *);
>> +struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *);
>> +size_t ipfix_msg_len(const struct ipfix_msg *);
>> +void *ipfix_msg_data(struct ipfix_msg *);
>> +struct ipfix_set_hdr *ipfix_msg_add_set(struct ipfix_msg *, uint16_t);
>> +void *ipfix_msg_add_data(struct ipfix_msg *, size_t);
>> +int ipfix_dump_msg(const struct ipfix_msg *);
>> +
>> +#endif /* IPFIX_H */
>> diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
>> new file mode 100644
>> index 0000000..02bc21f
>> --- /dev/null
>> +++ b/output/ipfix/ulogd_output_IPFIX.c
>> @@ -0,0 +1,526 @@
>> +/*
>> + * ulogd_output_IPFIX.c
>> + *
>> + * ulogd IPFIX Exporter plugin.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG 2009
>> + */
>> +#include <unistd.h>
>> +#include <time.h>
>> +#include <sys/types.h>
>> +#include <sys/socket.h>
>> +#include <arpa/inet.h>
>> +#include <netdb.h>
>> +#include <ulogd/ulogd.h>
>> +#include <ulogd/common.h>
>> +
>> +#include "ipfix.h"
>> +
>> +#define DEFAULT_MTU		512 /* RFC 5101, 10.3.3 */
>> +#define DEFAULT_PORT		4739 /* RFC 5101, 10.3.4 */
>> +#define DEFAULT_SPORT		4740
>> +
>> +enum {
>> +	OID_CE = 0,
>> +	HOST_CE,
>> +	PORT_CE,
>> +	PROTO_CE,
>> +	MTU_CE,
>> +};
>> +
>> +#define oid_ce(x)	(x->ces[OID_CE])
>> +#define host_ce(x)	(x->ces[HOST_CE])
>> +#define port_ce(x)	(x->ces[PORT_CE])
>> +#define proto_ce(x)	(x->ces[PROTO_CE])
>> +#define mtu_ce(x)	(x->ces[MTU_CE])
>> +
>> +static const struct config_keyset ipfix_kset = {
>> +	.num_ces = 5,
>> +	.ces = {
>> +		{
>> +			.key = "oid",
>> +			.type = CONFIG_TYPE_INT,
>> +			.u.value = 0
>> +		},
>> +		{
>> +			.key = "host",
>> +			.type = CONFIG_TYPE_STRING,
>> +			.u.string = ""
>> +		},
>> +		{
>> +			.key = "port",
>> +			.type = CONFIG_TYPE_INT,
>> +			.u.value = DEFAULT_PORT
>> +		},
>> +		{
>> +			.key = "proto",
>> +			.type = CONFIG_TYPE_STRING,
>> +			.u.string = "tcp"
>> +		},
>> +		{
>> +			.key = "mtu",
>> +			.type = CONFIG_TYPE_INT,
>> +			.u.value = DEFAULT_MTU
>> +		}
>> +	}
>> +};
>> +
>> +struct ipfix_templ {
>> +	struct ipfix_templ *next;
>> +};
>> +
>> +struct ipfix_priv {
>> +	struct ulogd_fd ufd;
>> +	uint32_t seqno;
>> +	struct ipfix_msg *msg;		/* current message */
>> +	struct llist_head list;
>> +	struct ipfix_templ *templates;
>> +	int proto;
>> +	struct ulogd_timer timer;
>> +	struct sockaddr_in sa;
>> +};
>> +
>> +enum {
>> +	InIpSaddr = 0,
>> +	InIpDaddr,
>> +	InRawInPktCount,
>> +	InRawInPktLen,
>> +	InRawOutPktCount,
>> +	InRawOutPktLen,
>> +	InFlowStartSec,
>> +	InFlowStartUsec,
>> +	InFlowEndSec,
>> +	InFlowEndUsec,
>> +	InL4SPort,
>> +	InL4DPort,
>> +	InIpProto,
>> +	InCtMark
>> +};
>> +
>> +static struct ulogd_key ipfix_in_keys[] = {
>> +		[InIpSaddr] = {
>> +			.type = ULOGD_RET_IPADDR,
>> +			.name = "orig.ip.saddr"
>> +		},
>> +		[InIpDaddr] = {
>> +			.type = ULOGD_RET_IPADDR,
>> +			.name = "orig.ip.daddr"
>> +		},
>> +		[InRawInPktCount] = {
>> +			.type = ULOGD_RET_UINT64,
>> +			.name = "orig.raw.pktcount"
>> +		},
>> +		[InRawInPktLen] = {
>> +			.type = ULOGD_RET_UINT64,
>> +			.name = "orig.raw.pktlen"
>> +		},
>> +		[InRawOutPktCount] = {
>> +			.type = ULOGD_RET_UINT64,
>> +			.name = "reply.raw.pktcount"
>> +		},
>> +		[InRawOutPktLen] = {
>> +			.type = ULOGD_RET_UINT64,
>> +			.name = "reply.raw.pktlen"
>> +		},
>> +		[InFlowStartSec] = {
>> +			.type = ULOGD_RET_UINT32,
>> +			.name = "flow.start.sec"
>> +		},
>> +		[InFlowStartUsec] = {
>> +			.type = ULOGD_RET_UINT32,
>> +			.name = "flow.start.usec"
>> +		},
>> +		[InFlowEndSec] = {
>> +			.type = ULOGD_RET_UINT32,
>> +			.name = "flow.end.sec"
>> +		},
>> +		[InFlowEndUsec] = {
>> +			.type = ULOGD_RET_UINT32,
>> +			.name = "flow.end.usec"
>> +		},
>> +		[InL4SPort] = {
>> +			.type = ULOGD_RET_UINT16,
>> +			.name = "orig.l4.sport"
>> +		},
>> +		[InL4DPort] = {
>> +			.type = ULOGD_RET_UINT16,
>> +			.name = "orig.l4.dport"
>> +		},
>> +		[InIpProto] = {
>> +			.type = ULOGD_RET_UINT8,
>> +			.name = "orig.ip.protocol"
>> +		},
>> +		[InCtMark] = {
>> +			.type = ULOGD_RET_UINT32,
>> +			.name = "ct.mark"
>> +		}
>> +};
>> +
>> +/* do some polishing and enqueue it */
>> +static void
>> +enqueue_msg(struct ipfix_priv *priv, struct ipfix_msg *msg)
>> +{
>> +	struct ipfix_hdr *hdr = ipfix_msg_data(msg);
>> +
>> +	if (!msg)
>> +		return;
>> +
>> +	hdr->time = htonl(time(NULL));
>> +	hdr->seqno = htonl(priv->seqno += msg->nrecs);
>> +	if (msg->last_set) {
>> +		msg->last_set->id = htons(msg->last_set->id);
>> +		msg->last_set->len = htons(msg->last_set->len);
>> +		msg->last_set = NULL;
>> +	}
>> +	hdr->len = htons(ipfix_msg_len(msg));
>> +
>> +	llist_add(&msg->link, &priv->list);
>> +}
>> +
>> +/**
>> + * @return %ULOGD_IRET_OK or error value
>> + */
>> +static int
>> +send_msgs(struct ulogd_pluginstance *pi)
>> +{
>> +	struct ipfix_msg *msg;
>> +	struct llist_head *curr, *tmp;
>> +	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
> 
> Please, reverse xmas tree in variable definition for new code is preferred, ie.
> 
> 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
> 	struct llist_head *curr, *tmp;
> 	struct ipfix_msg *msg;
> 
> ie. From larger line to shorter line.
> 
>> +	int ret = ULOGD_IRET_OK;
>> +
>> +	llist_for_each_prev(curr, &priv->list) {
>> +		int ret;
> 
> This is shadowing the previous 'int ret' definition.
> 
>> +		msg = llist_entry(curr, struct ipfix_msg, link);
>> +
>> +		ret = send(priv->ufd.fd, ipfix_msg_data(msg), ipfix_msg_len(msg), 0);
>> +		if (ret < 0) {
>> +			ulogd_log(ULOGD_ERROR, "send: %m\n");
>> +
>> +			if (errno == EAGAIN || errno == EINTR)
> 
> Socket is in blocking mode, I see not fcntl to make it enter
> non-blocking mode, so I guess this is not needed.
> 
>> +				goto done;
>> +			else
>> +				ret = ULOGD_IRET_ERR;
>> +
>> +			goto done;
>> +		}
>> +
>> +		/* TODO handle short send() for other protocols */
>> +		if ((size_t) ret < ipfix_msg_len(msg))
>> +			ulogd_log(ULOGD_ERROR, "short send: %d < %d\n",
>> +					ret, ipfix_msg_len(msg));
>> +	}
>> +
>> +	llist_for_each_safe(curr, tmp, &priv->list) {
>> +		msg = llist_entry(curr, struct ipfix_msg, link);
>> +		llist_del(curr);
>> +		msg->nrecs = 0;
>> +		ipfix_msg_free(msg);
>> +	}
>> +
>> +done:
>> +	return ret;
>> +}
>> +
>> +static int
>> +ipfix_ufd_cb(int fd, unsigned what, void *arg)
>> +{
>> +	struct ulogd_pluginstance *pi = arg;
>> +	struct ipfix_priv *priv = (struct ipfix_priv *) pi->private;
>> +	char buf[16];
>> +	ssize_t nread;
>> +
>> +	if (what & ULOGD_FD_READ) {
>> +		nread = recv(priv->ufd.fd, buf, sizeof(buf), MSG_DONTWAIT);
>> +		if (nread < 0) {
>> +			ulogd_log(ULOGD_ERROR, "recv: %m\n");
>> +			if (errno == EWOULDBLOCK || errno == EINTR)
> 
> Same comment here as above.
> 
>> +				goto done;
>> +		} else if (!nread) {
>> +			ulogd_log(ULOGD_INFO, "connection reset by peer\n");
>> +			ulogd_unregister_fd(&priv->ufd);
>> +		} else
>> +			ulogd_log(ULOGD_INFO, "unexpected data (%d bytes)\n", nread);
>> +	}
>> +
>> +done:
>> +	return 0;
>> +}
>> +
>> +static void
>> +ipfix_timer_cb(struct ulogd_timer *t, void *data)
>> +{
>> +	struct ulogd_pluginstance *pi = data;
>> +	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
>> +
>> +	if (priv->msg && priv->msg->nrecs > 0) {
>> +		enqueue_msg(priv, priv->msg);
>> +		priv->msg = NULL;
>> +
> 
> No need for empty line here above.
> 
>> +		send_msgs(pi);
>> +	}
>> +}
>> +
>> +static int
>> +ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pluginstance_stack *stack)
>> +{
>> +	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
>> +	char addr[16];
>> +	int oid, port, mtu, ret;
>> +	char *host = NULL, *proto = NULL;
> 
> Reverse xmas tree here again.
> 
> No need to initialize proto and host to NULL.
> 
>> +
>> +	ret = config_parse_file(pi->id, pi->config_kset);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	oid = oid_ce(pi->config_kset).u.value;
>> +	host = host_ce(pi->config_kset).u.string;
>> +	port = port_ce(pi->config_kset).u.value;
>> +	proto = proto_ce(pi->config_kset).u.string;
>> +	mtu = mtu_ce(pi->config_kset).u.value;
>> +
>> +	if (!oid) {
>> +		ulogd_log(ULOGD_FATAL, "invalid Observation ID\n");
>> +		return ULOGD_IRET_ERR;
>> +	}
>> +	if (!host || !strcmp(host, "")) {
>> +		ulogd_log(ULOGD_FATAL, "no destination host specified\n");
>> +		return ULOGD_IRET_ERR;
>> +	}
>> +
>> +	if (!strcmp(proto, "udp")) {
>> +		priv->proto = IPPROTO_UDP;
>> +	} else if (!strcmp(proto, "tcp")) {
>> +		priv->proto = IPPROTO_TCP;
>> +	} else {
>> +		ulogd_log(ULOGD_FATAL, "unsupported protocol '%s'\n", proto);
>> +		return ULOGD_IRET_ERR;
>> +	}
>> +
>> +	memset(&priv->sa, 0, sizeof(priv->sa));
>> +	priv->sa.sin_family = AF_INET;
>> +	priv->sa.sin_port = htons(port);
>> +	ret = inet_pton(AF_INET, host, &priv->sa.sin_addr);
>> +	if (ret < 0) {
>> +		ulogd_log(ULOGD_FATAL, "inet_pton: %m\n");
>> +		return ULOGD_IRET_ERR;
>> +	} else if (!ret) {
>> +		ulogd_log(ULOGD_FATAL, "host: invalid address '%s'\n", host);
>> +		return ULOGD_IRET_ERR;
>> +	}
> 
> You can just probably simplify this to:
> 
> 	ret = inet_pton(AF_INET, host, &priv->sa.sin_addr);
> 	if (ret <= 0) {
>                  ...
> 
> to check for errors.
> 
>> +
>> +	INIT_LLIST_HEAD(&priv->list);
>> +
>> +	ulogd_init_timer(&priv->timer, pi, ipfix_timer_cb);
>> +
>> +	ulogd_log(ULOGD_INFO, "using IPFIX Collector at %s:%d (MTU %d)\n",
>> +			inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
>> +			port, mtu);
> 
> Better align function parameters to parens, ie.
> 
> 	ulogd_log(ULOGD_INFO, "using IPFIX Collector at %s:%d (MTU %d)\n",
>                    inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
>                    port, mtu);
> 
> Please, send a version 2.
> 
> Thanks.
> 


--------------B953909ADB0D2D618A75AE15
Content-Type: text/x-diff;
 name="0001-IPFIX-Add-IPFIX-output-plugin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-IPFIX-Add-IPFIX-output-plugin.patch"

From a7ef95c7f3507270f726bf3c543f0148acc77807 Mon Sep 17 00:00:00 2001
From: Ander Juaristi <a@juaristi.eus>
Date: Wed, 17 Apr 2019 13:43:09 +0200
Subject: [PATCH 1/2] IPFIX: Add IPFIX output plugin

Based on original work by Holger Eitzenberger <holger@eitzenberger.org>.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 configure.ac                      |   2 +-
 include/ulogd/ulogd.h             |   5 +
 input/flow/ulogd_inpflow_IPFIX.c  |   2 -
 output/Makefile.am                |   2 +-
 output/ipfix/Makefile.am          |   7 +
 output/ipfix/ipfix.c              | 141 ++++++++
 output/ipfix/ipfix.h              |  89 +++++
 output/ipfix/ulogd_output_IPFIX.c | 503 +++++++++++++++++++++++++++
 output/ulogd_output_IPFIX.c       | 546 ------------------------------
 9 files changed, 747 insertions(+), 550 deletions(-)
 delete mode 100644 input/flow/ulogd_inpflow_IPFIX.c
 create mode 100644 output/ipfix/Makefile.am
 create mode 100644 output/ipfix/ipfix.c
 create mode 100644 output/ipfix/ipfix.h
 create mode 100644 output/ipfix/ulogd_output_IPFIX.c
 delete mode 100644 output/ulogd_output_IPFIX.c

diff --git a/configure.ac b/configure.ac
index 3aa0624..48b4995 100644
--- a/configure.ac
+++ b/configure.ac
@@ -179,7 +179,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
 	  input/sum/Makefile \
 	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
 	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
-	  output/dbi/Makefile \
+	  output/dbi/Makefile output/ipfix/Makefile \
 	  src/Makefile Makefile Rules.make)
 AC_OUTPUT
 
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 2e38195..1636a8c 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -28,6 +28,11 @@
 
 /* types without length */
 #define ULOGD_RET_NONE		0x0000
+#define __packed		__attribute__((packed))
+#define __noreturn		__attribute__((noreturn))
+#define __cold			__attribute__((cold))
+
+#define __packed		__attribute__((packed))
 
 #define ULOGD_RET_INT8		0x0001
 #define ULOGD_RET_INT16		0x0002
diff --git a/input/flow/ulogd_inpflow_IPFIX.c b/input/flow/ulogd_inpflow_IPFIX.c
deleted file mode 100644
index 27ce5b2..0000000
--- a/input/flow/ulogd_inpflow_IPFIX.c
+++ /dev/null
@@ -1,2 +0,0 @@
-/* */
-
diff --git a/output/Makefile.am b/output/Makefile.am
index ff851ad..7ba8217 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -2,7 +2,7 @@ AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
               ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
 
-SUBDIRS= pcap mysql pgsql sqlite3 dbi
+SUBDIRS= pcap mysql pgsql sqlite3 dbi ipfix
 
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
diff --git a/output/ipfix/Makefile.am b/output/ipfix/Makefile.am
new file mode 100644
index 0000000..cacda26
--- /dev/null
+++ b/output/ipfix/Makefile.am
@@ -0,0 +1,7 @@
+AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = $(regular_CFLAGS)
+
+pkglib_LTLIBRARIES = ulogd_output_IPFIX.la
+
+ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c ipfix.c
+ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
new file mode 100644
index 0000000..60a4c7f
--- /dev/null
+++ b/output/ipfix/ipfix.c
@@ -0,0 +1,141 @@
+/*
+ * ipfix.c
+ *
+ * Holger Eitzenberger, 2009.
+ */
+
+/* These forward declarations are needed since ulogd.h doesn't like to be the first */
+#include <ulogd/linuxlist.h>
+
+#define __packed		__attribute__((packed))
+
+#include "ipfix.h"
+
+#include <ulogd/ulogd.h>
+#include <ulogd/common.h>
+
+struct ipfix_msg *ipfix_msg_alloc(size_t len, uint32_t oid)
+{
+	struct ipfix_msg *msg;
+	struct ipfix_hdr *hdr;
+
+	if (len < IPFIX_HDRLEN + IPFIX_SET_HDRLEN)
+		return NULL;
+
+	msg = malloc(sizeof(struct ipfix_msg) + len);
+	memset(msg, 0, sizeof(struct ipfix_msg));
+	msg->tail = msg->data + IPFIX_HDRLEN;
+	msg->end = msg->data + len;
+
+	hdr = ipfix_msg_hdr(msg);
+	memset(hdr, 0, IPFIX_HDRLEN);
+	hdr->version = htons(IPFIX_VERSION);
+	hdr->oid = htonl(oid);
+
+	return msg;
+}
+
+void ipfix_msg_free(struct ipfix_msg *msg)
+{
+	if (!msg)
+		return;
+
+	if (msg->nrecs > 0)
+		ulogd_log(ULOGD_DEBUG, "%s: %d flows have been lost\n", __func__,
+			msg->nrecs);
+
+	free(msg);
+}
+
+struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *msg)
+{
+	return (struct ipfix_hdr *)msg->data;
+}
+
+void *ipfix_msg_data(struct ipfix_msg *msg)
+{
+	return msg->data;
+}
+
+size_t ipfix_msg_len(const struct ipfix_msg *msg)
+{
+	return msg->tail - msg->data;
+}
+
+struct ipfix_set_hdr *ipfix_msg_add_set(struct ipfix_msg *msg, uint16_t sid)
+{
+	struct ipfix_set_hdr *shdr;
+
+	if (msg->end - msg->tail < (int) IPFIX_SET_HDRLEN)
+		return NULL;
+
+	shdr = (struct ipfix_set_hdr *)msg->tail;
+	shdr->id = sid;
+	shdr->len = IPFIX_SET_HDRLEN;
+	msg->tail += IPFIX_SET_HDRLEN;
+	msg->last_set = shdr;
+	return shdr;
+}
+
+struct ipfix_set_hdr *ipfix_msg_get_set(const struct ipfix_msg *msg)
+{
+	return msg->last_set;
+}
+
+/**
+ * Add data record to an IPFIX message.  The data is accounted properly.
+ *
+ * @return pointer to data or %NULL if not that much space left.
+ */
+void *ipfix_msg_add_data(struct ipfix_msg *msg, size_t len)
+{
+	void *data;
+
+	if (!msg->last_set) {
+		ulogd_log(ULOGD_FATAL, "msg->last_set is NULL\n");
+		return NULL;
+	}
+
+	if ((ssize_t) len > msg->end - msg->tail)
+		return NULL;
+
+	data = msg->tail;
+	msg->tail += len;
+	msg->nrecs++;
+	msg->last_set->len += len;
+
+	return data;
+}
+
+/* check and dump message */
+int ipfix_dump_msg(const struct ipfix_msg *msg)
+{
+	const struct ipfix_hdr *hdr = ipfix_msg_hdr(msg);
+	const struct ipfix_set_hdr *shdr = (struct ipfix_set_hdr *) hdr->data;
+
+	if (ntohs(hdr->len) < IPFIX_HDRLEN) {
+		ulogd_log(ULOGD_FATAL, "Invalid IPFIX message header length\n");
+		return -1;
+	}
+	if (ipfix_msg_len(msg) != IPFIX_HDRLEN + ntohs(shdr->len)) {
+		ulogd_log(ULOGD_FATAL, "Invalid IPFIX message length\n");
+		return -1;
+	}
+
+	ulogd_log(ULOGD_DEBUG, "msg: ver=%#x len=%#x t=%#x seq=%#x oid=%d\n",
+			  ntohs(hdr->version), ntohs(hdr->len), htonl(hdr->time),
+			  ntohl(hdr->seqno), ntohl(hdr->oid));
+
+	return 0;
+}
+
+/* template management */
+size_t ipfix_rec_len(uint16_t sid)
+{
+	if (sid != htons(VY_IPFIX_SID)) {
+		ulogd_log(ULOGD_FATAL, "Invalid SID\n");
+		return 0;
+	}
+
+	return sizeof(struct vy_ipfix_data);
+}
diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
new file mode 100644
index 0000000..cdb5a6f
--- /dev/null
+++ b/output/ipfix/ipfix.h
@@ -0,0 +1,89 @@
+/*
+ * ipfix.h
+ *
+ * Holger Eitzenberger <holger@eitzenberger.org>, 2009.
+ */
+#ifndef IPFIX_H
+#define IPFIX_H
+
+#include <stdint.h>
+#include <netinet/in.h>
+
+
+struct ipfix_hdr {
+#define IPFIX_VERSION			0xa
+	uint16_t version;
+	uint16_t len;
+	uint32_t time;
+	uint32_t seqno;
+	uint32_t oid;				/* Observation Domain ID */
+	uint8_t data[];
+} __packed;
+
+#define IPFIX_HDRLEN	sizeof(struct ipfix_hdr)
+
+/*
+ * IDs 0-255 are reserved for Template Sets.  IDs of Data Sets are > 255.
+ */
+struct ipfix_templ_hdr {
+	uint16_t id;
+	uint16_t cnt;
+	uint8_t data[];
+} __packed;
+
+struct ipfix_set_hdr {
+#define IPFIX_SET_TEMPL			2
+#define IPFIX_SET_OPT_TEMPL		3
+	uint16_t id;
+	uint16_t len;
+	uint8_t data[];
+} __packed;
+
+#define IPFIX_SET_HDRLEN		sizeof(struct ipfix_set_hdr)
+
+struct ipfix_msg {
+	struct llist_head link;
+	uint8_t *tail;
+	uint8_t *end;
+	unsigned nrecs;
+	struct ipfix_set_hdr *last_set;
+	uint8_t data[];
+};
+
+struct vy_ipfix_data {
+	struct in_addr saddr;
+	struct in_addr daddr;
+	uint16_t ifi_in;
+	uint16_t ifi_out;
+	uint32_t packets;
+	uint32_t bytes;
+	uint32_t start;				/* Unix time */
+	uint32_t end;				/* Unix time */
+	uint16_t sport;
+	uint16_t dport;
+	uint32_t aid;				/* Application ID */
+	uint8_t l4_proto;
+	uint8_t dscp;
+	uint16_t __padding;
+} __packed;
+
+#define VY_IPFIX_SID		256
+
+#define VY_IPFIX_FLOWS		36
+#define VY_IPFIX_PKT_LEN	(IPFIX_HDRLEN + IPFIX_SET_HDRLEN \
+							 + VY_IPFIX_FLOWS * sizeof(struct vy_ipfix_data))
+
+/* template management */
+size_t ipfix_rec_len(uint16_t);
+
+/* message handling */
+struct ipfix_msg *ipfix_msg_alloc(size_t, uint32_t);
+void ipfix_msg_free(struct ipfix_msg *);
+struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *);
+size_t ipfix_msg_len(const struct ipfix_msg *);
+void *ipfix_msg_data(struct ipfix_msg *);
+struct ipfix_set_hdr *ipfix_msg_add_set(struct ipfix_msg *, uint16_t);
+void *ipfix_msg_add_data(struct ipfix_msg *, size_t);
+int ipfix_dump_msg(const struct ipfix_msg *);
+
+#endif /* IPFIX_H */
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
new file mode 100644
index 0000000..ec143b1
--- /dev/null
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -0,0 +1,503 @@
+/*
+ * ulogd_output_IPFIX.c
+ *
+ * ulogd IPFIX Exporter plugin.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG 2009
+ */
+#include <unistd.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+#include <netdb.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/common.h>
+
+#include "ipfix.h"
+
+#define DEFAULT_MTU		512 /* RFC 5101, 10.3.3 */
+#define DEFAULT_PORT		4739 /* RFC 5101, 10.3.4 */
+#define DEFAULT_SPORT		4740
+
+enum {
+	OID_CE = 0,
+	HOST_CE,
+	PORT_CE,
+	PROTO_CE,
+	MTU_CE,
+};
+
+#define oid_ce(x)	(x->ces[OID_CE])
+#define host_ce(x)	(x->ces[HOST_CE])
+#define port_ce(x)	(x->ces[PORT_CE])
+#define proto_ce(x)	(x->ces[PROTO_CE])
+#define mtu_ce(x)	(x->ces[MTU_CE])
+
+static const struct config_keyset ipfix_kset = {
+	.num_ces = 5,
+	.ces = {
+		{
+			.key = "oid",
+			.type = CONFIG_TYPE_INT,
+			.u.value = 0
+		},
+		{
+			.key = "host",
+			.type = CONFIG_TYPE_STRING,
+			.u.string = ""
+		},
+		{
+			.key = "port",
+			.type = CONFIG_TYPE_INT,
+			.u.value = DEFAULT_PORT
+		},
+		{
+			.key = "proto",
+			.type = CONFIG_TYPE_STRING,
+			.u.string = "tcp"
+		},
+		{
+			.key = "mtu",
+			.type = CONFIG_TYPE_INT,
+			.u.value = DEFAULT_MTU
+		}
+	}
+};
+
+struct ipfix_templ {
+	struct ipfix_templ *next;
+};
+
+struct ipfix_priv {
+	struct ulogd_fd ufd;
+	uint32_t seqno;
+	struct ipfix_msg *msg;		/* current message */
+	struct llist_head list;
+	struct ipfix_templ *templates;
+	int proto;
+	struct ulogd_timer timer;
+	struct sockaddr_in sa;
+};
+
+enum {
+	InIpSaddr = 0,
+	InIpDaddr,
+	InRawInPktCount,
+	InRawInPktLen,
+	InRawOutPktCount,
+	InRawOutPktLen,
+	InFlowStartSec,
+	InFlowStartUsec,
+	InFlowEndSec,
+	InFlowEndUsec,
+	InL4SPort,
+	InL4DPort,
+	InIpProto,
+	InCtMark
+};
+
+static struct ulogd_key ipfix_in_keys[] = {
+		[InIpSaddr] = {
+			.type = ULOGD_RET_IPADDR,
+			.name = "orig.ip.saddr"
+		},
+		[InIpDaddr] = {
+			.type = ULOGD_RET_IPADDR,
+			.name = "orig.ip.daddr"
+		},
+		[InRawInPktCount] = {
+			.type = ULOGD_RET_UINT64,
+			.name = "orig.raw.pktcount"
+		},
+		[InRawInPktLen] = {
+			.type = ULOGD_RET_UINT64,
+			.name = "orig.raw.pktlen"
+		},
+		[InRawOutPktCount] = {
+			.type = ULOGD_RET_UINT64,
+			.name = "reply.raw.pktcount"
+		},
+		[InRawOutPktLen] = {
+			.type = ULOGD_RET_UINT64,
+			.name = "reply.raw.pktlen"
+		},
+		[InFlowStartSec] = {
+			.type = ULOGD_RET_UINT32,
+			.name = "flow.start.sec"
+		},
+		[InFlowStartUsec] = {
+			.type = ULOGD_RET_UINT32,
+			.name = "flow.start.usec"
+		},
+		[InFlowEndSec] = {
+			.type = ULOGD_RET_UINT32,
+			.name = "flow.end.sec"
+		},
+		[InFlowEndUsec] = {
+			.type = ULOGD_RET_UINT32,
+			.name = "flow.end.usec"
+		},
+		[InL4SPort] = {
+			.type = ULOGD_RET_UINT16,
+			.name = "orig.l4.sport"
+		},
+		[InL4DPort] = {
+			.type = ULOGD_RET_UINT16,
+			.name = "orig.l4.dport"
+		},
+		[InIpProto] = {
+			.type = ULOGD_RET_UINT8,
+			.name = "orig.ip.protocol"
+		},
+		[InCtMark] = {
+			.type = ULOGD_RET_UINT32,
+			.name = "ct.mark"
+		}
+};
+
+/* do some polishing and enqueue it */
+static void enqueue_msg(struct ipfix_priv *priv, struct ipfix_msg *msg)
+{
+	struct ipfix_hdr *hdr = ipfix_msg_data(msg);
+
+	if (!msg)
+		return;
+
+	hdr->time = htonl(time(NULL));
+	hdr->seqno = htonl(priv->seqno += msg->nrecs);
+	if (msg->last_set) {
+		msg->last_set->id = htons(msg->last_set->id);
+		msg->last_set->len = htons(msg->last_set->len);
+		msg->last_set = NULL;
+	}
+	hdr->len = htons(ipfix_msg_len(msg));
+
+	llist_add(&msg->link, &priv->list);
+}
+
+/**
+ * @return %ULOGD_IRET_OK or error value
+ */
+static int send_msgs(struct ulogd_pluginstance *pi)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	struct llist_head *curr, *tmp;
+	struct ipfix_msg *msg;
+	int ret = ULOGD_IRET_OK, sent;
+
+	llist_for_each_prev(curr, &priv->list) {
+		msg = llist_entry(curr, struct ipfix_msg, link);
+
+		sent = send(priv->ufd.fd, ipfix_msg_data(msg), ipfix_msg_len(msg), 0);
+		if (sent < 0) {
+			ulogd_log(ULOGD_ERROR, "send: %m\n");
+			ret = ULOGD_IRET_ERR;
+			goto done;
+		}
+
+		/* TODO handle short send() for other protocols */
+		if ((size_t) sent < ipfix_msg_len(msg))
+			ulogd_log(ULOGD_ERROR, "short send: %d < %d\n",
+					sent, ipfix_msg_len(msg));
+	}
+
+	llist_for_each_safe(curr, tmp, &priv->list) {
+		msg = llist_entry(curr, struct ipfix_msg, link);
+		llist_del(curr);
+		msg->nrecs = 0;
+		ipfix_msg_free(msg);
+	}
+
+done:
+	return ret;
+}
+
+static int ipfix_ufd_cb(int fd, unsigned what, void *arg)
+{
+	struct ulogd_pluginstance *pi = arg;
+	struct ipfix_priv *priv = (struct ipfix_priv *) pi->private;
+	ssize_t nread;
+	char buf[16];
+
+	if (what & ULOGD_FD_READ) {
+		nread = recv(priv->ufd.fd, buf, sizeof(buf), MSG_DONTWAIT);
+		if (nread < 0) {
+			ulogd_log(ULOGD_ERROR, "recv: %m\n");
+		} else if (!nread) {
+			ulogd_log(ULOGD_INFO, "connection reset by peer\n");
+			ulogd_unregister_fd(&priv->ufd);
+		} else
+			ulogd_log(ULOGD_INFO, "unexpected data (%d bytes)\n", nread);
+	}
+
+	return 0;
+}
+
+static void ipfix_timer_cb(struct ulogd_timer *t, void *data)
+{
+	struct ulogd_pluginstance *pi = data;
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+
+	if (priv->msg && priv->msg->nrecs > 0) {
+		enqueue_msg(priv, priv->msg);
+		priv->msg = NULL;
+		send_msgs(pi);
+	}
+}
+
+static int ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pluginstance_stack *stack)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	int oid, port, mtu, ret;
+	char *host, *proto;
+	char addr[16];
+
+	ret = config_parse_file(pi->id, pi->config_kset);
+	if (ret < 0)
+		return ret;
+
+	oid = oid_ce(pi->config_kset).u.value;
+	host = host_ce(pi->config_kset).u.string;
+	port = port_ce(pi->config_kset).u.value;
+	proto = proto_ce(pi->config_kset).u.string;
+	mtu = mtu_ce(pi->config_kset).u.value;
+
+	if (!oid) {
+		ulogd_log(ULOGD_FATAL, "invalid Observation ID\n");
+		return ULOGD_IRET_ERR;
+	}
+	if (!host || !strcmp(host, "")) {
+		ulogd_log(ULOGD_FATAL, "no destination host specified\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	if (!strcmp(proto, "udp")) {
+		priv->proto = IPPROTO_UDP;
+	} else if (!strcmp(proto, "tcp")) {
+		priv->proto = IPPROTO_TCP;
+	} else {
+		ulogd_log(ULOGD_FATAL, "unsupported protocol '%s'\n", proto);
+		return ULOGD_IRET_ERR;
+	}
+
+	memset(&priv->sa, 0, sizeof(priv->sa));
+	priv->sa.sin_family = AF_INET;
+	priv->sa.sin_port = htons(port);
+	ret = inet_pton(AF_INET, host, &priv->sa.sin_addr);
+	if (ret <= 0) {
+		ulogd_log(ULOGD_FATAL, "inet_pton: %m\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	INIT_LLIST_HEAD(&priv->list);
+
+	ulogd_init_timer(&priv->timer, pi, ipfix_timer_cb);
+
+	ulogd_log(ULOGD_INFO, "using IPFIX Collector at %s:%d (MTU %d)\n",
+		  inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
+		  port, mtu);
+
+	return ULOGD_IRET_OK;
+}
+
+static int tcp_connect(struct ulogd_pluginstance *pi)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	int ret = ULOGD_IRET_ERR;
+
+	if ((priv->ufd.fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
+		ulogd_log(ULOGD_FATAL, "socket: %m\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	if (connect(priv->ufd.fd, (struct sockaddr *) &priv->sa, sizeof(priv->sa)) < 0) {
+		ulogd_log(ULOGD_ERROR, "connect: %m\n");
+		ret = ULOGD_IRET_ERR;
+		goto err_close;
+	}
+
+	return ULOGD_IRET_OK;
+
+err_close:
+	close(priv->ufd.fd);
+	return ret;
+}
+
+static int udp_connect(struct ulogd_pluginstance *pi)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+
+	if ((priv->ufd.fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
+		ulogd_log(ULOGD_FATAL, "socket: %m\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	if (connect(priv->ufd.fd, (struct sockaddr *) &priv->sa, sizeof(priv->sa)) < 0) {
+		ulogd_log(ULOGD_ERROR, "connect: %m\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	return 0;
+}
+
+static int ipfix_start(struct ulogd_pluginstance *pi)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	char addr[16];
+	int port, ret;
+
+	switch (priv->proto) {
+	case IPPROTO_UDP:
+		if ((ret = udp_connect(pi)) < 0)
+			return ret;
+		break;
+	case IPPROTO_TCP:
+		if ((ret = tcp_connect(pi)) < 0)
+			return ret;
+		break;
+
+	default:
+		break;
+	}
+
+	priv->seqno = 0;
+
+	port = port_ce(pi->config_kset).u.value;
+	ulogd_log(ULOGD_INFO, "connected to %s:%d\n",
+			inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
+			port);
+
+	/* Register the socket FD */
+	priv->ufd.when = ULOGD_FD_READ;
+	priv->ufd.cb = ipfix_ufd_cb;
+	priv->ufd.data = pi;
+
+	if (ulogd_register_fd(&priv->ufd) < 0)
+		return ULOGD_IRET_ERR;
+
+	/* Add a 1 second timer */
+	ulogd_add_timer(&priv->timer, 1);
+
+	return ULOGD_IRET_OK;
+}
+
+static int ipfix_stop(struct ulogd_pluginstance *pi)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+
+	ulogd_unregister_fd(&priv->ufd);
+	close(priv->ufd.fd);
+	priv->ufd.fd = -1;
+
+	ulogd_del_timer(&priv->timer);
+
+	ipfix_msg_free(priv->msg);
+	priv->msg = NULL;
+
+	return 0;
+}
+
+static int ipfix_interp(struct ulogd_pluginstance *pi)
+{
+	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	struct vy_ipfix_data *data;
+	int oid, mtu, ret;
+	char addr[16];
+
+	if (!(GET_FLAGS(pi->input.keys, InIpSaddr) & ULOGD_RETF_VALID))
+		return ULOGD_IRET_OK;
+
+	oid = oid_ce(pi->config_kset).u.value;
+	mtu = mtu_ce(pi->config_kset).u.value;
+
+again:
+	if (!priv->msg) {
+		priv->msg = ipfix_msg_alloc(mtu, oid);
+		if (!priv->msg) {
+			/* just drop this flow */
+			ulogd_log(ULOGD_ERROR, "out of memory, dropping flow\n");
+			return ULOGD_IRET_OK;
+		}
+		ipfix_msg_add_set(priv->msg, VY_IPFIX_SID);
+	}
+
+	data = ipfix_msg_add_data(priv->msg, sizeof(struct vy_ipfix_data));
+	if (!data) {
+		enqueue_msg(priv, priv->msg);
+		priv->msg = NULL;
+		/* can't loop because the next will definitely succeed */
+		goto again;
+	}
+
+	data->ifi_in = data->ifi_out = 0;
+
+	data->saddr.s_addr = ikey_get_u32(&pi->input.keys[InIpSaddr]);
+	data->daddr.s_addr = ikey_get_u32(&pi->input.keys[InIpDaddr]);
+
+	data->packets = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktCount])
+						+ ikey_get_u64(&pi->input.keys[InRawOutPktCount])));
+	data->bytes = htonl((uint32_t) (ikey_get_u64(&pi->input.keys[InRawInPktLen])
+						+ ikey_get_u64(&pi->input.keys[InRawOutPktLen])));
+
+	data->start = htonl(ikey_get_u32(&pi->input.keys[InFlowStartSec]));
+	data->end = htonl(ikey_get_u32(&pi->input.keys[InFlowEndSec]));
+
+	if (GET_FLAGS(pi->input.keys, InL4SPort) & ULOGD_RETF_VALID) {
+		data->sport = htons(ikey_get_u16(&pi->input.keys[InL4SPort]));
+		data->dport = htons(ikey_get_u16(&pi->input.keys[InL4DPort]));
+	}
+
+	data->aid = 0;
+	if (GET_FLAGS(pi->input.keys, InCtMark) & ULOGD_RETF_VALID)
+		data->aid = htonl(ikey_get_u32(&pi->input.keys[InCtMark]));
+
+	data->l4_proto = ikey_get_u8(&pi->input.keys[InIpProto]);
+	data->__padding = 0;
+
+	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u, %u), saddr = %s, daddr = %s, sport = %u, dport = %u)\n",
+			ntohl(data->packets), ntohl(data->bytes), ntohl(data->start), ntohl(data->end),
+			inet_ntop(AF_INET, &data->saddr.s_addr, addr, sizeof(addr)),
+			inet_ntop(AF_INET, &data->daddr.s_addr, addr, sizeof(addr)),
+			ntohs(data->sport), ntohs(data->dport));
+
+	if ((ret = send_msgs(pi)) < 0)
+		return ret;
+
+	return ULOGD_IRET_OK;
+}
+
+static struct ulogd_plugin ipfix_plugin = {
+	.name = "IPFIX",
+	.input = {
+		.keys = ipfix_in_keys,
+		.num_keys = ARRAY_SIZE(ipfix_in_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK
+	},
+	.config_kset = (struct config_keyset *) &ipfix_kset,
+	.priv_size = sizeof(struct ipfix_priv),
+	.configure = ipfix_configure,
+	.start = ipfix_start,
+	.stop = ipfix_stop,
+	.interp = ipfix_interp,
+	.version = VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&ipfix_plugin);
+}
diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
deleted file mode 100644
index 62f1d60..0000000
--- a/output/ulogd_output_IPFIX.c
+++ /dev/null
@@ -1,546 +0,0 @@
-/* ulogd_output_IPFIX.c
- *
- * ulogd output plugin for IPFIX
- *
- * This target produces a file which looks the same like the syslog-entries
- * of the LOG target.
- *
- * (C) 2005 by Harald Welte <laforge@gnumonks.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
- *  as published by the Free Software Foundation
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * TODO:
- * - where to get a useable <sctp.h> for linux ?
- * - implement PR-SCTP (no api definition in draft sockets api)
- *
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <string.h>
-#include <errno.h>
-
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netdb.h>
-
-#include <ulogd/linuxlist.h>
-
-#ifdef IPPROTO_SCTP
-/* temporarily disable sctp until we know which headers to use */
-#undef IPPROTO_SCTP
-#endif
-
-#ifdef IPPROTO_SCTP
-typedef uint32_t sctp_assoc_t;
-
-/* glibc doesn't yet have this, as defined by
- * draft-ietf-tsvwg-sctpsocket-11.txt */
-struct sctp_sndrcvinfo {
-	uint16_t	sinfo_stream;
-	uint16_t	sinfo_ssn;
-	uint16_t	sinfo_flags;
-	uint32_t	sinfo_ppid;
-	uint32_t	sinfo_context;
-	uint32_t	sinfo_timetolive;
-	uint32_t	sinfo_tsn;
-	uint32_t	sinfo_cumtsn;
-	sctp_assoc_t	sinfo_assoc_id;
-};
-#endif
-
-#include <ulogd/ulogd.h>
-#include <ulogd/conffile.h>
-#include <ulogd/linuxlist.h>
-#include <ulogd/ipfix_protocol.h>
-
-#define IPFIX_DEFAULT_TCPUDP_PORT	4739
-
-/* bitmask stuff */
-struct bitmask {
-	int size_bits;
-	char *buf;
-};
-
-#define SIZE_OCTETS(x)	((x/8)+1)
-
-void bitmask_clear(struct bitmask *bm)
-{
-	memset(bm->buf, 0, SIZE_OCTETS(bm->size_bits));
-}
-
-struct bitmask *bitmask_alloc(unsigned int num_bits)
-{
-	struct bitmask *bm;
-	unsigned int size_octets = SIZE_OCTETS(num_bits);
-
-	bm = malloc(sizeof(*bm) + size_octets);
-	if (!bm)
-		return NULL;
-
-	bm->size_bits = num_bits;
-	bm->buf = (void *)bm + sizeof(*bm);
-
-	bitmask_clear(bm);
-
-	return bm;
-}
-
-void bitmask_free(struct bitmask *bm)
-{
-	free(bm);
-}
-
-int bitmask_set_bit_to(struct bitmask *bm, unsigned int bits, int to)
-{
-	unsigned int byte = bits / 8;
-	unsigned int bit = bits % 8;
-	unsigned char *ptr;
-
-	if (byte > SIZE_OCTETS(bm->size_bits))
-		return -EINVAL;
-
-	if (to == 0)
-		bm->buf[byte] &= ~(1 << bit);
-	else
-		bm->buf[byte] |= (1 << bit);
-
-	return 0;
-}
-
-#define bitmask_clear_bit(bm, bit) \
-	bitmask_set_bit_to(bm, bit, 0)
-
-#define bitmask_set_bit(bm, bit) \
-	bitmask_set_bit_to(bm, bit, 1)
-
-int bitmasks_equal(const struct bitmask *bm1, const struct bitmask *bm2)
-{
-	if (bm1->size_bits != bm2->size_bits)
-		return -1;
-
-	if (!memcmp(bm1->buf, bm2->buf, SIZE_OCTETS(bm1->size_bits)))
-		return 1;
-	else
-		return 0;
-}
-
-struct bitmask *bitmask_dup(const struct bitmask *bm_orig)
-{
-	struct bitmask *bm_new;
-	int size = sizeof(*bm_new) + SIZE_OCTETS(bm_orig->size_bits);
-
-	bm_new = malloc(size);
-	if (!bm_new)
-		return NULL;
-
-	memcpy(bm_new, bm_orig, size);
-
-	return bm_new;
-}
-
-static struct config_keyset ipfix_kset = {
-	.num_ces = 3,
-	.ces = {
-		{
-			.key 	 = "host",
-			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
-		},
-		{
-			.key	 = "port",
-			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
-			.u	 = { .string = "4739" },
-		},
-		{
-			.key	 = "protocol",
-			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
-			.u	= { .string = "udp" },
-		},
-	},
-};
-
-#define host_ce(x)	(x->ces[0])
-#define port_ce(x)	(x->ces[1])
-#define proto_ce(x)	(x->ces[2])
-
-struct ipfix_template {
-	struct ipfix_templ_rec_hdr hdr;
-	char buf[0];
-};
-
-struct ulogd_ipfix_template {
-	struct llist_head list;
-	struct bitmask *bitmask;
-	unsigned int total_length;	/* length of the DATA */
-	char *tmpl_cur;		/* cursor into current template position */
-	struct ipfix_template tmpl;
-};
-
-struct ipfix_instance {
-	int fd;		/* socket that we use for sending IPFIX data */
-	int sock_type;	/* type (SOCK_*) */
-	int sock_proto;	/* protocol (IPPROTO_*) */
-
-	struct llist_head template_list;
-
-	struct ipfix_template *tmpl;
-	unsigned int tmpl_len;
-
-	struct bitmask *valid_bitmask;	/* bitmask of valid keys */
-
-	unsigned int total_length;	/* total size of all data elements */
-};
-
-#define ULOGD_IPFIX_TEMPL_BASE 1024
-static uint16_t next_template_id = ULOGD_IPFIX_TEMPL_BASE;
-
-/* Build the IPFIX template from the input keys */
-struct ulogd_ipfix_template *
-build_template_for_bitmask(struct ulogd_pluginstance *upi,
-			   struct bitmask *bm)
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-	struct ipfix_templ_rec_hdr *rhdr;
-	struct ulogd_ipfix_template *tmpl;
-	unsigned int i, j;
-	int size = sizeof(struct ulogd_ipfix_template)
-		   + (upi->input.num_keys * sizeof(struct ipfix_vendor_field));
-
-	tmpl = malloc(size);
-	if (!tmpl)
-		return NULL;
-	memset(tmpl, 0, size);
-
-	tmpl->bitmask = bitmask_dup(bm);
-	if (!tmpl->bitmask) {
-		free(tmpl);
-		return NULL;
-	}
-
-	/* initialize template header */
-	tmpl->tmpl.hdr.templ_id = htons(next_template_id++);
-
-	tmpl->tmpl_cur = tmpl->tmpl.buf;
-
-	tmpl->total_length = 0;
-
-	for (i = 0, j = 0; i < upi->input.num_keys; i++) {
-		struct ulogd_key *key = &upi->input.keys[i];
-		int length = ulogd_key_size(key);
-
-		if (!(key->u.source->flags & ULOGD_RETF_VALID))
-			continue;
-
-		if (length < 0 || length > 0xfffe) {
-			ulogd_log(ULOGD_INFO, "ignoring key `%s' because "
-				  "it has an ipfix incompatible length\n",
-				  key->name);
-			continue;
-		}
-
-		if (key->ipfix.field_id == 0) {
-			ulogd_log(ULOGD_INFO, "ignoring key `%s' because "
-				  "it has no field_id\n", key->name);
-			continue;
-		}
-
-		if (key->ipfix.vendor == IPFIX_VENDOR_IETF) {
-			struct ipfix_ietf_field *field = 
-				(struct ipfix_ietf_field *) tmpl->tmpl_cur;
-
-			field->type = htons(key->ipfix.field_id | 0x8000000);
-			field->length = htons(length);
-			tmpl->tmpl_cur += sizeof(*field);
-		} else {
-			struct ipfix_vendor_field *field =
-				(struct ipfix_vendor_field *) tmpl->tmpl_cur;
-
-			field->enterprise_num = htonl(key->ipfix.vendor);
-			field->type = htons(key->ipfix.field_id);
-			field->length = htons(length);
-			tmpl->tmpl_cur += sizeof(*field);
-		}
-		tmpl->total_length += length;
-		j++;
-	}
-
-	tmpl->tmpl.hdr.field_count = htons(j);
-
-	return tmpl;
-}
-
-
-
-static struct ulogd_ipfix_template *
-find_template_for_bitmask(struct ulogd_pluginstance *upi,
-			  struct bitmask *bm)
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-	struct ulogd_ipfix_template *tmpl;
-	
-	/* FIXME: this can be done more efficient! */
-	llist_for_each_entry(tmpl, &ii->template_list, list) {
-		if (bitmasks_equal(bm, tmpl->bitmask))
-			return tmpl;
-	}
-	return NULL;
-}
-
-static int output_ipfix(struct ulogd_pluginstance *upi)
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-	struct ulogd_ipfix_template *template;
-	unsigned int total_size;
-	int i;
-
-	/* FIXME: it would be more cache efficient if the IS_VALID
-	 * flags would be a separate bitmask outside of the array.
-	 * ulogd core could very easily flush it after every packet,
-	 * too. */
-
-	bitmask_clear(ii->valid_bitmask);
-
-	for (i = 0; i < upi->input.num_keys; i++) {
-		struct ulogd_key *key = upi->input.keys[i].u.source;
-
-		if (key->flags & ULOGD_RETF_VALID)
-			bitmask_set_bit(ii->valid_bitmask, i);
-	}
-	
-	/* lookup template ID for this bitmask */
-	template = find_template_for_bitmask(upi, ii->valid_bitmask);
-	if (!template) {
-		ulogd_log(ULOGD_INFO, "building new template\n");
-		template = build_template_for_bitmask(upi, ii->valid_bitmask);
-		if (!template) {
-			ulogd_log(ULOGD_ERROR, "can't build new template!\n");
-			return ULOGD_IRET_ERR;
-		}
-		llist_add(&template->list, &ii->template_list);
-	}
-	
-	total_size = template->total_length;
-
-	/* decide if it's time to retransmit our template and (optionally)
-	 * prepend it into the to-be-sent IPFIX message */
-	if (0 /* FIXME */) {
-		/* add size of template */
-		//total_size += (template->tmpl_cur - (void *)&template->tmpl);
-		total_size += sizeof(template->tmpl);
-	}
-
-	return ULOGD_IRET_OK;
-}
-
-static int open_connect_socket(struct ulogd_pluginstance *pi)
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &pi->private;
-	struct addrinfo hint, *res, *resave;
-	int ret;
-
-	memset(&hint, 0, sizeof(hint));
-	hint.ai_socktype = ii->sock_type;
-	hint.ai_protocol = ii->sock_proto;
-	hint.ai_flags = AI_ADDRCONFIG;
-
-	ret = getaddrinfo(host_ce(pi->config_kset).u.string,
-			  port_ce(pi->config_kset).u.string,
-			  &hint, &res);
-	if (ret != 0) {
-		ulogd_log(ULOGD_ERROR, "can't resolve host/service: %s\n",
-			  gai_strerror(ret));
-		return -1;
-	}
-
-	resave = res;
-
-	for (; res; res = res->ai_next) {
-		ii->fd = socket(res->ai_family, res->ai_socktype,
-				res->ai_protocol);
-		if (ii->fd < 0) {
-			switch (errno) {
-			case EACCES:
-			case EAFNOSUPPORT:
-			case EINVAL:
-			case EPROTONOSUPPORT:
-				/* try next result */
-				continue;
-			default:
-				ulogd_log(ULOGD_ERROR, "error: %s\n",
-					  strerror(errno));
-				break;
-			}
-		}
-
-#ifdef IPPROTO_SCTP
-		/* Set the number of SCTP output streams */
-		if (res->ai_protocol == IPPROTO_SCTP) {
-			struct sctp_initmsg initmsg;
-			int ret; 
-			memset(&initmsg, 0, sizeof(initmsg));
-			initmsg.sinit_num_ostreams = 2;
-			ret = setsockopt(ii->fd, IPPROTO_SCTP, SCTP_INITMSG,
-					 &initmsg, sizeof(initmsg));
-			if (ret < 0) {
-				ulogd_log(ULOGD_ERROR, "cannot set number of"
-					  "sctp streams: %s\n",
-					  strerror(errno));
-				close(ii->fd);
-				freeaddrinfo(resave);
-				return ret;
-			}
-		}
-#endif
-
-		if (connect(ii->fd, res->ai_addr, res->ai_addrlen) != 0) {
-			close(ii->fd);
-			/* try next result */
-			continue;
-		}
-
-		/* if we reach this, we have a working connection */
-		ulogd_log(ULOGD_NOTICE, "connection established\n");
-		freeaddrinfo(resave);
-		return 0;
-	}
-
-	freeaddrinfo(resave);
-	return -1;
-}
-
-static int start_ipfix(struct ulogd_pluginstance *pi)
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &pi->private;
-	int ret;
-
-	ulogd_log(ULOGD_DEBUG, "starting ipfix\n");
-
-	ii->valid_bitmask = bitmask_alloc(pi->input.num_keys);
-	if (!ii->valid_bitmask)
-		return -ENOMEM;
-
-	INIT_LLIST_HEAD(&ii->template_list);
-
-	ret = open_connect_socket(pi);
-	if (ret < 0)
-		goto out_bm_free;
-
-	return 0;
-
-out_bm_free:
-	bitmask_free(ii->valid_bitmask);
-	ii->valid_bitmask = NULL;
-
-	return ret;
-}
-
-static int stop_ipfix(struct ulogd_pluginstance *pi) 
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &pi->private;
-
-	close(ii->fd);
-
-	bitmask_free(ii->valid_bitmask);
-	ii->valid_bitmask = NULL;
-
-	return 0;
-}
-
-static void signal_handler_ipfix(struct ulogd_pluginstance *pi, int signal)
-{
-	struct ipfix_instance *li = (struct ipfix_instance *) &pi->private;
-
-	switch (signal) {
-	case SIGHUP:
-		ulogd_log(ULOGD_NOTICE, "ipfix: reopening connection\n");
-		stop_ipfix(pi);
-		start_ipfix(pi);
-		break;
-	default:
-		break;
-	}
-}
-	
-static int configure_ipfix(struct ulogd_pluginstance *pi,
-			    struct ulogd_pluginstance_stack *stack)
-{
-	struct ipfix_instance *ii = (struct ipfix_instance *) &pi->private;
-	char *proto_str = proto_ce(pi->config_kset).u.string;
-	int ret;
-
-	/* FIXME: error handling */
-	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
-	ret = config_parse_file(pi->id, pi->config_kset);
-	if (ret < 0)
-		return ret;
-
-	/* determine underlying protocol */
-	if (!strcasecmp(proto_str, "udp")) {
-		ii->sock_type = SOCK_DGRAM;
-		ii->sock_proto = IPPROTO_UDP;
-	} else if (!strcasecmp(proto_str, "tcp")) {
-		ii->sock_type = SOCK_STREAM;
-		ii->sock_proto = IPPROTO_TCP;
-#ifdef IPPROTO_SCTP
-	} else if (!strcasecmp(proto_str, "sctp")) {
-		ii->sock_type = SOCK_SEQPACKET;
-		ii->sock_proto = IPPROTO_SCTP;
-#endif
-#ifdef _HAVE_DCCP
-	} else if (!strcasecmp(proto_str, "dccp")) {
-		ii->sock_type = SOCK_SEQPACKET;
-		ii->sock_proto = IPPROTO_DCCP;
-#endif
-	} else {
-		ulogd_log(ULOGD_ERROR, "unknown protocol `%s'\n",
-			  proto_ce(pi->config_kset));
-		return -EINVAL;
-	}
-
-	/* postpone address lookup to ->start() time, since we want to 
-	 * re-lookup an address on SIGHUP */
-
-	return ulogd_wildcard_inputkeys(pi);
-}
-
-static struct ulogd_plugin ipfix_plugin = { 
-	.name = "IPFIX",
-	.input = {
-		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW, 
-	},
-	.output = {
-		.type = ULOGD_DTYPE_SINK,
-	},
-	.config_kset 	= &ipfix_kset,
-	.priv_size 	= sizeof(struct ipfix_instance),
-
-	.configure	= &configure_ipfix,
-	.start	 	= &start_ipfix,
-	.stop	 	= &stop_ipfix,
-
-	.interp 	= &output_ipfix, 
-	.signal 	= &signal_handler_ipfix,
-	.version	= VERSION,
-};
-
-void __attribute__ ((constructor)) init(void);
-
-void init(void)
-{
-	ulogd_register_plugin(&ipfix_plugin);
-}
-- 
2.17.1


--------------B953909ADB0D2D618A75AE15
Content-Type: text/x-diff;
 name="0002-IPFIX-Introduce-template-record-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-IPFIX-Introduce-template-record-support.patch"

From 592c7a55f52a8c73c51c5929fdef97bb7ef42c93 Mon Sep 17 00:00:00 2001
From: Ander Juaristi <a@juaristi.eus>
Date: Wed, 17 Apr 2019 13:35:37 +0200
Subject: [PATCH 2/2] IPFIX: Introduce template record support

This commit adds the ability to send template records
to the remote collector.

In addition, it also introduces a new
configuration parameter 'send_template', which tells when template
records should be sent. It accepts the following string values:

 - "once": Send the template record only the first time (might be coalesced
    with data records).
 - "always": Send the template record always, with every data record that is sent
    to the collector (multiple data records might be sent together).
 - "never": Assume the collector knows the schema already. Do not send template records.

If omitted, the default value for 'send_template' is "once".

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/ulogd/ipfix_protocol.h    |  1 +
 output/ipfix/ipfix.c              | 97 ++++++++++++++++++++++++++++++-
 output/ipfix/ipfix.h              | 22 +++----
 output/ipfix/ulogd_output_IPFIX.c | 56 ++++++++++--------
 4 files changed, 139 insertions(+), 37 deletions(-)

diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
index aef47f0..01dd96a 100644
--- a/include/ulogd/ipfix_protocol.h
+++ b/include/ulogd/ipfix_protocol.h
@@ -129,6 +129,7 @@ enum {
 	/* reserved */
 	IPFIX_fragmentOffsetIPv4	= 88,
 	/* reserved */
+	IPFIX_applicationId		= 95,
 	IPFIX_bgpNextAdjacentAsNumber	= 128,
 	IPFIX_bgpPrevAdjacentAsNumber	= 129,
 	IPFIX_exporterIPv4Address	= 130,
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index 60a4c7f..4bb432a 100644
--- a/output/ipfix/ipfix.c
+++ b/output/ipfix/ipfix.c
@@ -2,6 +2,7 @@
  * ipfix.c
  *
  * Holger Eitzenberger, 2009.
+ * Ander Juaristi, 2019
  */
 
 /* These forward declarations are needed since ulogd.h doesn't like to be the first */
@@ -13,25 +14,107 @@
 
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
+#include <ulogd/ipfix_protocol.h>
+
+struct ipfix_templ_elem {
+	uint16_t id;
+	uint16_t len;
+};
+
+struct ipfix_templ {
+	unsigned int num_templ_elements;
+	struct ipfix_templ_elem templ_elements[];
+};
+
+/* Template fields modeled after vy_ipfix_data */
+static const struct ipfix_templ template = {
+	.num_templ_elements = 10,
+	.templ_elements = {
+		{
+			.id = IPFIX_sourceIPv4Address,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_destinationIPv4Address,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_packetTotalCount,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_octetTotalCount,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_flowStartSeconds,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_flowEndSeconds,
+			.len = sizeof(uint32_t)
+		},
+		{
+			.id = IPFIX_sourceTransportPort,
+			.len = sizeof(uint16_t)
+		},
+		{
+			.id = IPFIX_destinationTransportPort,
+			.len = sizeof(uint16_t)
+		},
+		{
+			.id = IPFIX_protocolIdentifier,
+			.len = sizeof(uint8_t)
+		},
+		{
+			.id = IPFIX_applicationId,
+			.len = sizeof(uint32_t)
+		}
+	}
+};
 
-struct ipfix_msg *ipfix_msg_alloc(size_t len, uint32_t oid)
+struct ipfix_msg *ipfix_msg_alloc(size_t len, uint32_t oid, int tid)
 {
 	struct ipfix_msg *msg;
 	struct ipfix_hdr *hdr;
+	struct ipfix_templ_hdr *templ_hdr;
+	struct ipfix_templ_elem *elem;
+	unsigned int i = 0;
 
-	if (len < IPFIX_HDRLEN + IPFIX_SET_HDRLEN)
+	if ((tid > 0 && len < IPFIX_HDRLEN + IPFIX_TEMPL_HDRLEN(template.num_templ_elements) + IPFIX_SET_HDRLEN) ||
+	    (len < IPFIX_HDRLEN + IPFIX_SET_HDRLEN))
 		return NULL;
 
 	msg = malloc(sizeof(struct ipfix_msg) + len);
 	memset(msg, 0, sizeof(struct ipfix_msg));
-	msg->tail = msg->data + IPFIX_HDRLEN;
+	msg->tid = tid;
 	msg->end = msg->data + len;
+	msg->tail = msg->data + IPFIX_HDRLEN;
+	if (tid > 0)
+		msg->tail += IPFIX_TEMPL_HDRLEN(template.num_templ_elements);
 
+	/* Initialize message header */
 	hdr = ipfix_msg_hdr(msg);
 	memset(hdr, 0, IPFIX_HDRLEN);
 	hdr->version = htons(IPFIX_VERSION);
 	hdr->oid = htonl(oid);
 
+	if (tid > 0) {
+		/* Initialize template record header */
+		templ_hdr = ipfix_msg_templ_hdr(msg);
+		templ_hdr->sid = htons(2);
+		templ_hdr->tid = htons(tid);
+		templ_hdr->len = htons(IPFIX_TEMPL_HDRLEN(template.num_templ_elements));
+		templ_hdr->cnt = htons(template.num_templ_elements);
+
+		while (i < template.num_templ_elements) {
+			elem = (struct ipfix_templ_elem *) &templ_hdr->data[i * 4];
+			elem->id = htons(template.templ_elements[i].id);
+			elem->len = htons(template.templ_elements[i].len);
+			i++;
+		}
+	}
+
 	return msg;
 }
 
@@ -47,6 +130,14 @@ void ipfix_msg_free(struct ipfix_msg *msg)
 	free(msg);
 }
 
+struct ipfix_templ_hdr *ipfix_msg_templ_hdr(const struct ipfix_msg *msg)
+{
+	if (msg->tid > 0)
+		return (struct ipfix_templ_hdr *) (msg->data + IPFIX_HDRLEN);
+
+	return NULL;
+}
+
 struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *msg)
 {
 	return (struct ipfix_hdr *)msg->data;
diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
index cdb5a6f..93945fb 100644
--- a/output/ipfix/ipfix.h
+++ b/output/ipfix/ipfix.h
@@ -2,6 +2,7 @@
  * ipfix.h
  *
  * Holger Eitzenberger <holger@eitzenberger.org>, 2009.
+ * Ander Juaristi <a@juaristi.eus>, 2019
  */
 #ifndef IPFIX_H
 #define IPFIX_H
@@ -20,17 +21,21 @@ struct ipfix_hdr {
 	uint8_t data[];
 } __packed;
 
-#define IPFIX_HDRLEN	sizeof(struct ipfix_hdr)
+#define IPFIX_HDRLEN		sizeof(struct ipfix_hdr)
 
 /*
  * IDs 0-255 are reserved for Template Sets.  IDs of Data Sets are > 255.
  */
 struct ipfix_templ_hdr {
-	uint16_t id;
+	uint16_t sid;
+	uint16_t len;
+	uint16_t tid;
 	uint16_t cnt;
 	uint8_t data[];
 } __packed;
 
+#define IPFIX_TEMPL_HDRLEN(nfields)	sizeof(struct ipfix_templ_hdr) + (sizeof(uint16_t) * 2 * nfields)
+
 struct ipfix_set_hdr {
 #define IPFIX_SET_TEMPL			2
 #define IPFIX_SET_OPT_TEMPL		3
@@ -46,6 +51,7 @@ struct ipfix_msg {
 	uint8_t *tail;
 	uint8_t *end;
 	unsigned nrecs;
+	int tid;
 	struct ipfix_set_hdr *last_set;
 	uint8_t data[];
 };
@@ -53,18 +59,14 @@ struct ipfix_msg {
 struct vy_ipfix_data {
 	struct in_addr saddr;
 	struct in_addr daddr;
-	uint16_t ifi_in;
-	uint16_t ifi_out;
 	uint32_t packets;
 	uint32_t bytes;
 	uint32_t start;				/* Unix time */
 	uint32_t end;				/* Unix time */
 	uint16_t sport;
 	uint16_t dport;
-	uint32_t aid;				/* Application ID */
 	uint8_t l4_proto;
-	uint8_t dscp;
-	uint16_t __padding;
+	uint32_t aid;				/* Application ID */
 } __packed;
 
 #define VY_IPFIX_SID		256
@@ -73,13 +75,11 @@ struct vy_ipfix_data {
 #define VY_IPFIX_PKT_LEN	(IPFIX_HDRLEN + IPFIX_SET_HDRLEN \
 							 + VY_IPFIX_FLOWS * sizeof(struct vy_ipfix_data))
 
-/* template management */
-size_t ipfix_rec_len(uint16_t);
-
 /* message handling */
-struct ipfix_msg *ipfix_msg_alloc(size_t, uint32_t);
+struct ipfix_msg *ipfix_msg_alloc(size_t, uint32_t, int);
 void ipfix_msg_free(struct ipfix_msg *);
 struct ipfix_hdr *ipfix_msg_hdr(const struct ipfix_msg *);
+struct ipfix_templ_hdr *ipfix_msg_templ_hdr(const struct ipfix_msg *);
 size_t ipfix_msg_len(const struct ipfix_msg *);
 void *ipfix_msg_data(struct ipfix_msg *);
 struct ipfix_set_hdr *ipfix_msg_add_set(struct ipfix_msg *, uint16_t);
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index ec143b1..5b59003 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -3,6 +3,9 @@
  *
  * ulogd IPFIX Exporter plugin.
  *
+ * (C) 2009 by Holger Eitzenberger <holger@eitzenberger.org>, Astaro AG
+ * (C) 2019 by Ander Juaristi <a@juaristi.eus>
+ *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@@ -11,8 +14,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG 2009
  */
 #include <unistd.h>
 #include <time.h>
@@ -28,6 +29,7 @@
 #define DEFAULT_MTU		512 /* RFC 5101, 10.3.3 */
 #define DEFAULT_PORT		4739 /* RFC 5101, 10.3.4 */
 #define DEFAULT_SPORT		4740
+#define DEFAULT_SEND_TEMPLATE	"once"
 
 enum {
 	OID_CE = 0,
@@ -35,16 +37,18 @@ enum {
 	PORT_CE,
 	PROTO_CE,
 	MTU_CE,
+	SEND_TEMPLATE_CE
 };
 
-#define oid_ce(x)	(x->ces[OID_CE])
-#define host_ce(x)	(x->ces[HOST_CE])
-#define port_ce(x)	(x->ces[PORT_CE])
-#define proto_ce(x)	(x->ces[PROTO_CE])
-#define mtu_ce(x)	(x->ces[MTU_CE])
+#define oid_ce(x)		(x->ces[OID_CE])
+#define host_ce(x)		(x->ces[HOST_CE])
+#define port_ce(x)		(x->ces[PORT_CE])
+#define proto_ce(x)		(x->ces[PROTO_CE])
+#define mtu_ce(x)		(x->ces[MTU_CE])
+#define send_template_ce(x)	(x->ces[SEND_TEMPLATE_CE])
 
 static const struct config_keyset ipfix_kset = {
-	.num_ces = 5,
+	.num_ces = 6,
 	.ces = {
 		{
 			.key = "oid",
@@ -70,20 +74,21 @@ static const struct config_keyset ipfix_kset = {
 			.key = "mtu",
 			.type = CONFIG_TYPE_INT,
 			.u.value = DEFAULT_MTU
+		},
+		{
+			.key = "send_template",
+			.type = CONFIG_TYPE_STRING,
+			.u.string = DEFAULT_SEND_TEMPLATE
 		}
 	}
 };
 
-struct ipfix_templ {
-	struct ipfix_templ *next;
-};
-
 struct ipfix_priv {
 	struct ulogd_fd ufd;
 	uint32_t seqno;
 	struct ipfix_msg *msg;		/* current message */
 	struct llist_head list;
-	struct ipfix_templ *templates;
+	int tid;
 	int proto;
 	struct ulogd_timer timer;
 	struct sockaddr_in sa;
@@ -258,8 +263,8 @@ static void ipfix_timer_cb(struct ulogd_timer *t, void *data)
 static int ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pluginstance_stack *stack)
 {
 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	char *host, *proto, *send_template;
 	int oid, port, mtu, ret;
-	char *host, *proto;
 	char addr[16];
 
 	ret = config_parse_file(pi->id, pi->config_kset);
@@ -271,6 +276,7 @@ static int ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pluginsta
 	port = port_ce(pi->config_kset).u.value;
 	proto = proto_ce(pi->config_kset).u.string;
 	mtu = mtu_ce(pi->config_kset).u.value;
+	send_template = send_template_ce(pi->config_kset).u.string;
 
 	if (!oid) {
 		ulogd_log(ULOGD_FATAL, "invalid Observation ID\n");
@@ -303,6 +309,8 @@ static int ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pluginsta
 
 	ulogd_init_timer(&priv->timer, pi, ipfix_timer_cb);
 
+	priv->tid = (strcmp(send_template, "never") ? VY_IPFIX_SID : -1);
+
 	ulogd_log(ULOGD_INFO, "using IPFIX Collector at %s:%d (MTU %d)\n",
 		  inet_ntop(AF_INET, &priv->sa.sin_addr, addr, sizeof(addr)),
 		  port, mtu);
@@ -410,25 +418,30 @@ static int ipfix_stop(struct ulogd_pluginstance *pi)
 static int ipfix_interp(struct ulogd_pluginstance *pi)
 {
 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
+	char saddr[16], daddr[16], *send_template;
 	struct vy_ipfix_data *data;
 	int oid, mtu, ret;
-	char addr[16];
 
 	if (!(GET_FLAGS(pi->input.keys, InIpSaddr) & ULOGD_RETF_VALID))
 		return ULOGD_IRET_OK;
 
 	oid = oid_ce(pi->config_kset).u.value;
 	mtu = mtu_ce(pi->config_kset).u.value;
+	send_template = send_template_ce(pi->config_kset).u.string;
 
 again:
 	if (!priv->msg) {
-		priv->msg = ipfix_msg_alloc(mtu, oid);
+		priv->msg = ipfix_msg_alloc(mtu, oid, priv->tid);
 		if (!priv->msg) {
 			/* just drop this flow */
 			ulogd_log(ULOGD_ERROR, "out of memory, dropping flow\n");
 			return ULOGD_IRET_OK;
 		}
 		ipfix_msg_add_set(priv->msg, VY_IPFIX_SID);
+
+		/* template sent - do not send it again the next time */
+		if (priv->tid == VY_IPFIX_SID && strcmp(send_template, "once") == 0)
+			priv->tid = -1;
 	}
 
 	data = ipfix_msg_add_data(priv->msg, sizeof(struct vy_ipfix_data));
@@ -439,8 +452,6 @@ again:
 		goto again;
 	}
 
-	data->ifi_in = data->ifi_out = 0;
-
 	data->saddr.s_addr = ikey_get_u32(&pi->input.keys[InIpSaddr]);
 	data->daddr.s_addr = ikey_get_u32(&pi->input.keys[InIpDaddr]);
 
@@ -462,13 +473,12 @@ again:
 		data->aid = htonl(ikey_get_u32(&pi->input.keys[InCtMark]));
 
 	data->l4_proto = ikey_get_u8(&pi->input.keys[InIpProto]);
-	data->__padding = 0;
 
 	ulogd_log(ULOGD_DEBUG, "Got new packet (packets = %u, bytes = %u, flow = (%u, %u), saddr = %s, daddr = %s, sport = %u, dport = %u)\n",
-			ntohl(data->packets), ntohl(data->bytes), ntohl(data->start), ntohl(data->end),
-			inet_ntop(AF_INET, &data->saddr.s_addr, addr, sizeof(addr)),
-			inet_ntop(AF_INET, &data->daddr.s_addr, addr, sizeof(addr)),
-			ntohs(data->sport), ntohs(data->dport));
+		  ntohl(data->packets), ntohl(data->bytes), ntohl(data->start), ntohl(data->end),
+		  inet_ntop(AF_INET, &data->saddr.s_addr, saddr, sizeof(saddr)),
+		  inet_ntop(AF_INET, &data->daddr.s_addr, daddr, sizeof(daddr)),
+		  ntohs(data->sport), ntohs(data->dport));
 
 	if ((ret = send_msgs(pi)) < 0)
 		return ret;
-- 
2.17.1


--------------B953909ADB0D2D618A75AE15--
