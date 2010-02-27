From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sat, 27 Feb 2010 14:55:12 +0100
Message-ID: <4B892440.7030002@netfilter.org>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49560 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968349Ab0B0Nza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:55:30 -0500
In-Reply-To: <1267217680-22677-2-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pierre,

Pierre Chifflier wrote:
> This input plugins creates a unix socket which can be used to log packets.
> Scripts or applications can connect to the socket (only one client allowed
> per socket) and send data in a Key-Length-Value format (including the
> payload).

I'm proposing some minor changes, they are mostly cleanups and comestic.

BTW, how does the "big picture" of this look like? I guess that your
nufw daemon is listening to packets via libnetfilter_queue and then it
sends unixsock messages that include the packet + extra authentication
information to ulogd2 to log them, right?

> Signed-off-by: Pierre Chifflier <chifflier@edenwall.com>
> ---
>  input/packet/Makefile.am             |    5 +-
>  input/packet/ulogd_inppkt_UNIXSOCK.c |  815 ++++++++++++++++++++++++++++++++++

could this be extended in the future to support flow-based information?
I mean, does this really fit into the "packet" directory of ulogd2?


>  ulogd.conf.in                        |    7 +
>  3 files changed, 826 insertions(+), 1 deletions(-)
>  create mode 100644 input/packet/ulogd_inppkt_UNIXSOCK.c
> 
> diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
> index e90e46e..566b817 100644
> --- a/input/packet/Makefile.am
> +++ b/input/packet/Makefile.am
> @@ -3,7 +3,7 @@ AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
>  AM_CFLAGS=-fPIC -Wall
>  LIBS=
>  
> -pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
> +pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
>  
>  ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
>  ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
> @@ -12,3 +12,6 @@ ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
>  ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
>  ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
>  ulogd_inppkt_ULOG_la_LIBADD = ../../libipulog/libipulog.la
> +
> +ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
> +ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
> diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
> new file mode 100644
> index 0000000..32494e4
> --- /dev/null
> +++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
> @@ -0,0 +1,815 @@
> +/*
> + ** Copyright(C) 2008-2010 INL
> + ** Written by  Pierre Chifflier <chifflier@edenwall.com>

Minor nitpick: please, add licensing terms here in a short header.

> +*/
> +
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <netinet/ether.h>
> +#include <netinet/in.h>
> +#include <netinet/ip.h>
> +#include <netinet/ip6.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <sys/un.h>
> +#include <pwd.h>
> +#include <grp.h>
> +#include <errno.h>
> +
> +#include <ulogd/ulogd.h>
> +
> +/* Default size of the receive buffer for the unix socket
> +   0 means that ulogd will use getsockopt(SO_RCVBUF) to determine it
> +   at runtime */
> +#define UNIXSOCK_BUFSIZE_DEFAULT	0
> +
> +/* Default permissions of created socket (in octal mode) */
> +#define UNIXSOCK_PERMS_DEFAULT		0600
> +
> +/* Default unix socket path */
> +#define UNIXSOCK_UNIXPATH_DEFAULT	"/var/run/ulogd/ulogd2.sock"

These extra lines below are unnecessarly, I'd say. They don't help to
make the code more readable.

> +
> +
> +/* Unique value used as a signature to ensure received data is really
> + * a packet
> + */
> +#define ULOGD_SOCKET_MARK	0x41c90fd4

Same here

> +
> +
> +struct unixsock_input {
> +	char *path;
> +	char *unixsock_buf;
> +	unsigned int unixsock_perms;
> +	unsigned int unixsock_buf_avail;
> +	unsigned int unixsock_buf_size;
> +	struct ulogd_fd unixsock_server_fd;
> +	struct ulogd_fd unixsock_instance_fd;
> +};
> +
> +enum nflog_keys {
> +	UNIXSOCK_KEY_RAW_MAC = 0,
> +	UNIXSOCK_KEY_RAW_PCKT,
> +	UNIXSOCK_KEY_RAW_PCKTLEN,
> +	UNIXSOCK_KEY_RAW_PCKTCOUNT,
> +	UNIXSOCK_KEY_OOB_PREFIX,
> +	UNIXSOCK_KEY_OOB_TIME_SEC,
> +	UNIXSOCK_KEY_OOB_TIME_USEC,
> +	UNIXSOCK_KEY_OOB_MARK,
> +	UNIXSOCK_KEY_OOB_IN,
> +	UNIXSOCK_KEY_OOB_OUT,
> +	UNIXSOCK_KEY_OOB_HOOK,
> +	UNIXSOCK_KEY_RAW_MAC_LEN,
> +	UNIXSOCK_KEY_OOB_SEQ_LOCAL,
> +	UNIXSOCK_KEY_OOB_SEQ_GLOBAL,
> +	UNIXSOCK_KEY_OOB_FAMILY,
> +	UNIXSOCK_KEY_OOB_PROTOCOL,
> +	UNIXSOCK_KEY_OOB_UID,
> +	UNIXSOCK_KEY_OOB_GID,
> +	UNIXSOCK_KEY_RAW_LABEL,
> +	UNIXSOCK_KEY_RAW_TYPE,
> +	UNIXSOCK_KEY_RAW_MAC_SADDR,
> +	UNIXSOCK_KEY_RAW_MAC_ADDRLEN,
> +	UNIXSOCK_KEY_NUFW_USER_NAME,
> +	UNIXSOCK_KEY_NUFW_USER_ID,
> +	UNIXSOCK_KEY_NUFW_OS_NAME,
> +	UNIXSOCK_KEY_NUFW_OS_REL,
> +	UNIXSOCK_KEY_NUFW_OS_VERS,
> +	UNIXSOCK_KEY_NUFW_APP_NAME,
> +};
> +
> +static struct ulogd_key output_keys[] = {
> +	[UNIXSOCK_KEY_RAW_MAC] = {
> +		.type = ULOGD_RET_RAW,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.mac",
> +	},
> +	[UNIXSOCK_KEY_RAW_MAC_SADDR] = {
> +		.type = ULOGD_RET_RAW,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.mac.saddr",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_IETF,
> +			.field_id = IPFIX_sourceMacAddress,
> +		},
> +	},
> +	[UNIXSOCK_KEY_RAW_PCKT] = {
> +		.type = ULOGD_RET_RAW,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.pkt",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_rawpacket,
> +		},
> +	},
> +	[UNIXSOCK_KEY_RAW_PCKTLEN] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.pktlen",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_rawpacket_length,
> +		},
> +	},
> +	[UNIXSOCK_KEY_RAW_PCKTCOUNT] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.pktcount",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_IETF,
> +			.field_id = IPFIX_packetDeltaCount,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_PREFIX] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.prefix",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_prefix,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_TIME_SEC] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.time.sec",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_IETF,
> +			.field_id = IPFIX_flowStartSeconds,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_TIME_USEC] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.time.usec",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_IETF,
> +			.field_id = IPFIX_flowStartMicroSeconds,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_MARK] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.mark",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_mark,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_IN] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.in",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_IETF,
> +			.field_id = IPFIX_ingressInterface,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_OUT] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.out",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_IETF,
> +			.field_id = IPFIX_egressInterface,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_HOOK] = {
> +		.type = ULOGD_RET_UINT8,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.hook",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_hook,
> +		},
> +	},
> +	[UNIXSOCK_KEY_RAW_MAC_LEN] = {
> +		.type = ULOGD_RET_UINT16,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.mac_len",
> +	},
> +	[UNIXSOCK_KEY_RAW_MAC_ADDRLEN] = {
> +		.type = ULOGD_RET_UINT16,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.mac.addrlen",
> +	},
> +
> +	[UNIXSOCK_KEY_OOB_SEQ_LOCAL] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.seq.local",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_seq_local,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_SEQ_GLOBAL] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.seq.global",
> +		.ipfix = {
> +			.vendor = IPFIX_VENDOR_NETFILTER,
> +			.field_id = IPFIX_NF_seq_global,
> +		},
> +	},
> +	[UNIXSOCK_KEY_OOB_FAMILY] = {
> +		.type = ULOGD_RET_UINT8,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.family",
> +	},
> +	[UNIXSOCK_KEY_OOB_PROTOCOL] = {
> +		.type = ULOGD_RET_UINT16,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.protocol",
> +	},
> +	[UNIXSOCK_KEY_OOB_UID] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.uid",
> +	},
> +	[UNIXSOCK_KEY_OOB_GID] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "oob.gid",
> +	},
> +	[UNIXSOCK_KEY_RAW_LABEL] = {
> +		.type = ULOGD_RET_UINT8,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.label",
> +	},
> +	[UNIXSOCK_KEY_RAW_TYPE] = {
> +		.type = ULOGD_RET_UINT16,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "raw.type",
> +	},
> +	[UNIXSOCK_KEY_NUFW_USER_NAME] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "nufw.user.name",
> +	},

Could we define some more generic instead of NUFW? I know it's your
thing but others may benefit from these fields I guess, right?

Well, this is not important anyway, I don't mind too much.

> +	[UNIXSOCK_KEY_NUFW_USER_ID] = {
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "nufw.user.id",
> +	},
> +	[UNIXSOCK_KEY_NUFW_OS_NAME] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "nufw.os.name",
> +	},
> +	[UNIXSOCK_KEY_NUFW_OS_REL] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "nufw.os.rel",
> +	},
> +	[UNIXSOCK_KEY_NUFW_OS_VERS] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "nufw.os.vers",
> +	},
> +	[UNIXSOCK_KEY_NUFW_APP_NAME] = {
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_RETF_NONE,
> +		.name = "nufw.app.name",
> +	},
> +};
> +
> +static struct config_keyset libunixsock_kset = {
> +	.num_ces = 5,
> +	.ces = {
> +		{
> +			.key 	 = "socket_path",
> +			.type 	 = CONFIG_TYPE_STRING,
> +			.options = CONFIG_OPT_NONE,
> +			.u.string = UNIXSOCK_UNIXPATH_DEFAULT,
> +		},
> +		{
> +			.key 	 = "bufsize",
> +			.type 	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +			.u.value = UNIXSOCK_BUFSIZE_DEFAULT,
> +		},
> +		{
> +			.key 	 = "perms",
> +			.type 	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +			.u.value = UNIXSOCK_PERMS_DEFAULT,
> +		},
> +		{
> +			.key 	 = "owner",
> +			.type 	 = CONFIG_TYPE_STRING,
> +			.options = CONFIG_OPT_NONE,
> +		},
> +		{
> +			.key 	 = "group",
> +			.type 	 = CONFIG_TYPE_STRING,
> +			.options = CONFIG_OPT_NONE,
> +		},
> +	},
> +};
> +
> +#define unixpath_ce(x)		((x)->ces[0])
> +#define bufsize_ce(x)		((x)->ces[1])
> +#define perms_ce(x)		((x)->ces[2])
> +#define owner_ce(x)		((x)->ces[3])
> +#define group_ce(x)		((x)->ces[4])

I know that this is xyz_ce() macros are the "standard way" in ulogd2 but
it's ugly. I would do the following:

enum {
	UNIXSOCK_OPT_UNIXPATH = 0,
	UNIXSOCK_OPT_BUFSIZE,
	UNIXSOCK_OPT_PERM,
	UNIXSOCK_OPT_OWNER,
	UNIXSOCK_OPT_GROUP,
};

Then, we can do the transition easily to several functions like:

ulogd_option_get_str(UNIXSOCK_OPT_UNIXPATH, upi->config_kset);
ulogd_option_get_u32(UNIXSOCK_OPT_PERM, upi->config_kset);

and so on... this is something that I had in my head. I'm not asking you
to do so but to tell you about my intentions. If we start defining the
enums now, we can do the transition in the near future.

> +
> +
> +enum ulogd2_option_type {
> +	ULOGD2_OPT_UNUSED = 0,
> +	ULOGD2_OPT_PREFIX,	/* log prefix (string) */
> +	ULOGD2_OPT_OOB_IN,	/* input device (string) */
> +	ULOGD2_OPT_OOB_OUT,	/* output device (string) */
> +	ULOGD2_OPT_OOB_TIME_SEC,	/* packet arrival time (u_int32_t) */
> +
> +	ULOGD2_OPT_USER=200,	/* user name (string) */
> +	ULOGD2_OPT_USERID,	/* user id (u_int32_t) */
> +	ULOGD2_OPT_OSNAME,	/* OS name (string) */
> +	ULOGD2_OPT_OSREL,	/* OS release (string) */
> +	ULOGD2_OPT_OSVERS,	/* OS version (string) */
> +	ULOGD2_OPT_APPNAME,	/* application name (string) */
> +	ULOGD2_OPT_STATE,	/* connection state: 0 (drop), 1 (open), 2 (established), 3 (close), 4 (unknown) */
> +};
> +
> +struct ulogd_unixsock_packet_t {
> +	uint32_t marker;
> +	uint16_t total_size;
> +	uint16_t payload_length;
> +	uint32_t reserved;
> +	struct iphdr payload;
> +} __attribute__((packed));

Probably you can add a version here (even if unused, I'd suggest some
bits of the reserved field), so if you have a change the header layout
you can support both versions without breaking backward compatibility.

> +
> +struct ulogd_unixsock_option_t  {
> +	uint16_t option_id;
> +	uint16_t option_length;
> +	char     option_value[0];
> +} __attribute__((packed));
> +
> +#define ALIGN_SIZE 8

Minor question: why align this to 64 bits?

Same thing, I'd remove those extra lines here below.
> +
> +
> +static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_packet_t *pkt, u_int16_t total_len)
> +{
> +	char *data;
> +	struct iphdr *ip;
> +	struct ulogd_key *ret = upi->output.keys;
> +	u_int8_t oob_family;
> +	u_int16_t payload_len;
> +	u_int16_t option_number;
> +	u_int16_t option_length;
> +	char *buf;
> +	struct ulogd_unixsock_option_t *option;
> +	int new_offset;
> +	char *options_start;
> +

unnecessary line break below?

> +	ulogd_log(ULOGD_DEBUG,
> +			"ulogd2: handling packet\n");
> +
> +	data = NULL;

initialize data variable above to NULL. Remove extra line?

> +
> +	payload_len = ntohs(pkt->payload_length);
> +
> +	ip = &pkt->payload;

unnecessary extra lines.

> +
> +	if (ip->version == 4)
> +		oob_family = AF_INET;
> +	else if (ip->version == 6)
> +		oob_family = AF_INET6;
> +	else oob_family = 0;
> +
> +	okey_set_u8(&ret[UNIXSOCK_KEY_OOB_FAMILY], oob_family);

remove extra line.

> +
> +	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], ip);
> +	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTLEN], payload_len);
> +
> +	/* options */
> +	if (total_len > payload_len + sizeof(u_int16_t)) {
> +		/* option starts at the next aligned address after the payload */
> +		new_offset = ALIGN_SIZE + ((payload_len - 1) & ~(ALIGN_SIZE - 1));

I'd define a macro like NLMSG_ALIGN(), those who are familiar with
Netlink would easily notice what you're doing :-).

> +		options_start = (char*)ip + new_offset;
> +		data = options_start;
> +		/* 8 here is offsetof(ulogd_unixsock_packet_t,payload) - offsetof(ulogd_unixsock_packet_t,total_size) */
> +		total_len -= (new_offset +  8);
> +
> +		while ( (data - options_start) < total_len) {
> +
> +			option = (void*)data;
> +
> +			option_number = ntohs(option->option_id);
> +			option_length = ntohs(option->option_length);
> +			data += 2*sizeof(u_int16_t);
> +			buf = data;

Check include/linux/netlink.h and include/net/netlink.h. I think that a
couple of macros would be nicer for this parsing.

> +
> +			/* next option is also aligned */
> +			new_offset = ALIGN_SIZE + ((option_length - 1) & ~(ALIGN_SIZE - 1));
> +
> +			data += new_offset;
> +
> +			ulogd_log(ULOGD_DEBUG,
> +					"ulogd2: option %d (len %d) `%s'\n",
> +					option_number, option_length, buf);
> +
> +			switch(option_number) {

If you put the case in the same line of the switch you save one indent
and lines are less likely to wrap around after 80 chars per column :-)

> +				case ULOGD2_OPT_PREFIX:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_PREFIX], buf);
> +					break;
> +				case ULOGD2_OPT_OOB_IN:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_IN], buf);
> +					break;
> +				case ULOGD2_OPT_OOB_OUT:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_OOB_OUT], buf);
> +					break;
> +				case ULOGD2_OPT_OOB_TIME_SEC:
> +					okey_set_u32(&ret[UNIXSOCK_KEY_OOB_TIME_SEC], *(u_int32_t*)buf);
> +					break;
> +				case ULOGD2_OPT_USER:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_USER_NAME], buf);
> +					break;
> +				case ULOGD2_OPT_USERID:
> +					okey_set_u32(&ret[UNIXSOCK_KEY_NUFW_USER_ID], *(u_int32_t*)buf);
> +					break;
> +				case ULOGD2_OPT_OSNAME:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_NAME], buf);
> +					break;
> +				case ULOGD2_OPT_OSREL:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_REL], buf);
> +					break;
> +				case ULOGD2_OPT_OSVERS:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_OS_VERS], buf);
> +					break;
> +				case ULOGD2_OPT_APPNAME:
> +					okey_set_ptr(&ret[UNIXSOCK_KEY_NUFW_APP_NAME], buf);
> +					break;
> +				case ULOGD2_OPT_STATE:
> +					okey_set_u8(&ret[UNIXSOCK_KEY_RAW_LABEL], *(u_int8_t*)buf);
> +					break;
> +				default:
> +					ulogd_log(ULOGD_NOTICE,
> +							"ulogd2: unknown option %d\n",
> +							option_number);
> +					break;
> +			};
> +		}
> +	}
> +
> +	/* number of packets */
> +	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTCOUNT], 1);
> +
> +	ulogd_propagate_results(upi);
> +
> +	return 0;
> +}
> +
> +static int _create_unix_socket(const char *unix_path)
> +{
> +	int ret = -1;
> +	struct sockaddr_un server_sock;
> +	int s;
> +
> +	s = socket(AF_UNIX, SOCK_STREAM, 0);
> +	if (s < 0)

ulogd_log(ULOGD_ERROR, ...)

> +		return -1;
> +
> +	server_sock.sun_family = AF_UNIX;
> +	strncpy(server_sock.sun_path, unix_path, sizeof(server_sock.sun_path));
> +	server_sock.sun_path[sizeof(server_sock.sun_path)-1] = '\0';
> +
> +	/* remove existing socket, if any */
> +	unlink(unix_path);

Probably it's a good idea to check if there's another socket still open.
You can avoid having two ulogd2 instances by mistake.

> +
> +	ret = bind(s, (struct sockaddr *)&server_sock, sizeof(server_sock));
> +	if (ret < 0) {
> +		ulogd_log(ULOGD_ERROR,
> +				"ulogd2: could not bind to unix socket \'%s\'\n",
> +				server_sock.sun_path);
> +		close(s);
> +		return -1;
> +	}
> +
> +	ret = listen(s, 10);
> +	if (ret < 0) {
> +		ulogd_log(ULOGD_ERROR,
> +				"ulogd2: could not bind to unix socket \'%s\'\n",
> +				server_sock.sun_path);
> +		close(s);
> +		return -1;
> +	}
> +
> +
> +	return s;
> +}
> +
> +static int _unix_socket_set_permissions(struct ulogd_pluginstance *upi)
> +{
> +	const char *socket_path;
> +	const char *owner = owner_ce(upi->config_kset).u.string;
> +	const char *group = group_ce(upi->config_kset).u.string;
> +	uid_t uid = (uid_t)-1;
> +	gid_t gid = (gid_t)-1;
> +
> +	socket_path = unixpath_ce(upi->config_kset).u.string;
> +
> +	if (chmod(socket_path, perms_ce(upi->config_kset).u.value) < 0) {
> +		ulogd_log(ULOGD_ERROR, "Could not set permissions on unix socket\n");
> +		return -1;
> +	}
> +
> +	if (owner && strlen(owner)>0) {
> +		struct passwd *p = getpwnam(owner);
> +
> +		if (p == NULL) {
> +			ulogd_log(ULOGD_ERROR, "Invalid owner specified for unix socket (%s)\n", owner);
> +			return -1;
> +		}
> +
> +		uid = p->pw_uid;
> +	}
> +
> +	if (group && strlen(group)>0) {
> +		struct group *g = getgrnam(group);
> +
> +		if (g == NULL) {
> +			ulogd_log(ULOGD_ERROR, "Invalid group specified for unix socket (%s)\n", group);
> +			return -1;
> +		}
> +
> +		gid = g->gr_gid;
> +	}
> +
> +	if (chown(socket_path, uid, gid) < 0) {
> +		ulogd_log(ULOGD_ERROR, "Could not set owner/group of unix socket\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/* warning: this code is NOT reentrant ! */
> +static void _timer_unregister_cb(struct ulogd_timer *a, void *param)
> +{
> +	struct unixsock_input *ui = param;
> +
> +	if (ui->unixsock_instance_fd.fd >= 0) {
> +		ulogd_log(ULOGD_DEBUG, "  removing client from list\n");
> +		ulogd_unregister_fd(&ui->unixsock_instance_fd);
> +		close(ui->unixsock_instance_fd.fd);
> +		ui->unixsock_instance_fd.fd = -1;
> +		ui->unixsock_buf_avail = 0;
> +	}
> +}
> +
> +static void _disconnect_client(struct unixsock_input *ui)
> +{
> +	struct ulogd_timer *t = malloc(sizeof(struct ulogd_timer));
> +
> +	/* we can't call ulogd_unregister_fd fd, it will segfault
> +	 * (unable to remove an entry while inside llist_for_each_entry)
> +	 * so we schedule removal for next loop
> +	 */
> +	ulogd_init_timer(t, ui, _timer_unregister_cb);
> +	ulogd_add_timer(t, 0);
> +}
> +
> +/* callback called from ulogd core when fd is readable */
> +static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
> +{
> +	struct ulogd_pluginstance *upi = param;
> +	struct unixsock_input *ui = (struct unixsock_input*)upi->private;
> +	int len;
> +	u_int16_t needed_len;
> +	u_int32_t packet_sig;
> +	struct ulogd_unixsock_packet_t *unixsock_packet;
> +
> +	char buf[4096];
> +
> +	if (!(what & ULOGD_FD_READ))
> +		return 0;
> +
> +	len = read(fd, buf, sizeof(buf));

Ah, looking at this, I think that it would be a good idea to ignore
SIGPIPE to avoid crashing ulogd2 if the other peer has gone.

> +	if (len < 0) {
> +		ulogd_log(ULOGD_NOTICE, "  read returned %d, errno is %d (%s)\n",
> +					len, errno, strerror(errno));
> +		exit(-1);
> +		return len;
> +	}
> +	if (len == 0) {
> +		_disconnect_client(ui);
> +		ulogd_log(ULOGD_DEBUG, "  client disconnected\n");
> +		return 0;
> +	}
> +
> +	//ulogd_log(ULOGD_DEBUG, "  read %d bytes\n", len);
> +	//ulogd_log(ULOGD_DEBUG, "  buffer [%s]\n", buf);

Remove or leave the lines above, but those double slashs looks a bit
ugly to me.

> +
> +	if (ui->unixsock_buf_avail + len > ui->unixsock_buf_size) {
> +		ulogd_log(ULOGD_NOTICE,
> +			  "We are losing events. Please consider using the clause "
> +			  "bufsize\n");
> +		return -1;
> +	}
> +
> +	memcpy(ui->unixsock_buf + ui->unixsock_buf_avail,
> +	       buf,
> +	       len);

We need that line break above, really?

> +	ui->unixsock_buf_avail += len;
> +
> +	do {
> +		unixsock_packet = (void*)ui->unixsock_buf;
> +		packet_sig = ntohl(unixsock_packet->marker);
> +		if (packet_sig != ULOGD_SOCKET_MARK) {
> +			ulogd_log(ULOGD_ERROR,
> +				"ulogd2: invalid packet marked received (read %lx, expected %lx), closing socket.\n",

This line above goes over 80 chars per column?

> +				packet_sig, ULOGD_SOCKET_MARK);
> +			_disconnect_client(ui);
> +			return -1;
> +
> +		}
> +
> +		needed_len = ntohs(unixsock_packet->total_size);
> +
> +		if (ui->unixsock_buf_avail >= needed_len + sizeof(u_int32_t)) {
> +			ulogd_log(ULOGD_DEBUG, "  We have enough data (%d bytes required), handling packet\n", needed_len);
> +
> +			if (handle_packet(upi, unixsock_packet, needed_len) != 0) {
> +				return -1;
> +			}
> +			/* consume data */
> +			ui->unixsock_buf_avail -= (sizeof(u_int32_t) + needed_len);
> +			if (ui->unixsock_buf_avail > 0) {
> +				/* we need to shift data .. */
> +				memmove(ui->unixsock_buf,
> +						ui->unixsock_buf + (sizeof(u_int32_t) + needed_len) ,
> +						ui->unixsock_buf_avail);
> +			} else {
> +				/* input buffer is empty, do not loop */
> +				return 0;
> +			}
> +
> +		} else {
> +			ulogd_log(ULOGD_DEBUG, "  We have %d bytes, but need %d. Requesting more\n",
> +					ui->unixsock_buf_avail, needed_len + sizeof(u_int32_t));
> +			return 0;
> +		}
> +
> +		/* handle_packet has shifted data in buffer */
> +	} while (1);

I'd put this while(1) above for readability so I don't need to go until
the end of the code to notice that this is an endless loop ;-).

> +
> +	return 0;
> +}
> +
> +/* callback called from ulogd core when fd is readable */
> +static int unixsock_server_read_cb(int fd, unsigned int what, void *param)
> +{
> +	struct ulogd_pluginstance *upi = param;
> +	struct unixsock_input *ui = (struct unixsock_input*)upi->private;
> +	socklen_t len;
> +	int s;
> +	struct sockaddr_storage saddr;
> +
> +	if (!(what & ULOGD_FD_READ))
> +		return 0;
> +
> +	ulogd_log(ULOGD_DEBUG, "New server connected on unixsock socket\n");
> +
> +	len = sizeof(saddr);
> +	s = accept(fd, (struct sockaddr*)&saddr, &len);
> +	if (s < 0) {
> +		ulogd_log(ULOGD_NOTICE,
> +				"  error while accepting new unixsock client, errno is %d (%s)\n",
> +				errno, strerror(errno));
> +		return len;
> +	}
> +
> +	if (ui->unixsock_instance_fd.fd >= 0) {
> +		ulogd_log(ULOGD_NOTICE, "a client is already connecting, rejecting new connection");
> +		close(s);
> +		return 0;
> +	}
> +
> +	ui->unixsock_instance_fd.fd = s;
> +	ui->unixsock_instance_fd.cb = &unixsock_instance_read_cb;
> +	ui->unixsock_instance_fd.data = upi;
> +	ui->unixsock_instance_fd.when = ULOGD_FD_READ;
> +
> +	if (ulogd_register_fd(&ui->unixsock_instance_fd) < 0) {
> +		ulogd_log(ULOGD_ERROR, "unable to register client fd to ulogd\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}

unnecessary extra lines below.

> +
> +
> +
> +
> +static int configure(struct ulogd_pluginstance *upi,
> +		     struct ulogd_pluginstance_stack *stack)
> +{
> +	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
> +		  "plugin `%s'\n", upi->id, upi->plugin->name);
> +
> +	config_parse_file(upi->id, upi->config_kset);
> +	return 0;
> +}
> +
> +static int start(struct ulogd_pluginstance *upi)
> +{
> +	struct unixsock_input *ui = (struct unixsock_input *) upi->private;
> +	int fd;
> +
> +	ulogd_log(ULOGD_DEBUG, "Starting plugin `%s'\n",
> +		  upi->plugin->name);
> +
> +	ui->path = unixpath_ce(upi->config_kset).u.string;
> +
> +	ulogd_log(ULOGD_DEBUG, "Creating Unix socket `%s'\n",
> +		  ui->path);
> +	fd = _create_unix_socket(ui->path);
> +	if (fd < 0) {
> +		ulogd_log(ULOGD_ERROR, "Unable to create unix socket on `%s'\n",
> +			  ui->path);
> +		return -1;
> +	}
> +
> +	if (_unix_socket_set_permissions(upi) < 0) {
> +		return -1;
> +	}
> +
> +	ui->unixsock_buf_avail = 0;
> +	ui->unixsock_buf_size = bufsize_ce(upi->config_kset).u.value;
> +
> +	if (ui->unixsock_buf_size == 0) {
> +		int fd_bufsize = 0;
> +		socklen_t optlen = sizeof(fd_bufsize);
> +
> +		if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF, &fd_bufsize, &optlen) < 0) {
> +			ulogd_log(ULOGD_ERROR,
> +					"Could not determine socket buffer size. You have to use the clause "
> +					"bufsize\n");
> +			return -1;
> +		}
> +		ulogd_log(ULOGD_DEBUG, "bufsize is %d\n", fd_bufsize);
> +
> +		ui->unixsock_buf_size = fd_bufsize;
> +	}
> +	ui->unixsock_buf = malloc(ui->unixsock_buf_size);
> +
> +	ui->unixsock_server_fd.fd = fd;
> +	ui->unixsock_server_fd.cb = &unixsock_server_read_cb;
> +	ui->unixsock_server_fd.data = upi;
> +	ui->unixsock_server_fd.when = ULOGD_FD_READ;
> +
> +	ui->unixsock_instance_fd.fd = -1;
> +	ui->unixsock_instance_fd.cb = &unixsock_instance_read_cb;
> +	ui->unixsock_instance_fd.data = upi;
> +	ui->unixsock_instance_fd.when = ULOGD_FD_READ;
> +
> +	if (ulogd_register_fd(&ui->unixsock_server_fd) < 0) {
> +		ulogd_log(ULOGD_ERROR, "Unable to register fd to ulogd\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int stop(struct ulogd_pluginstance *upi)
> +{
> +	struct unixsock_input *ui = (struct unixsock_input *) upi->private;
> +	char *unix_path = unixpath_ce(upi->config_kset).u.string;
> +
> +	ulogd_log(ULOGD_DEBUG, "Stopping plugin `%s'\n",
> +		  upi->plugin->name);
> +
> +	if (unix_path)
> +		unlink(unix_path);
> +
> +	free(ui->unixsock_buf);
> +
> +	return 0;
> +}
> +
> +
> +
> +
> +struct ulogd_plugin libunixsock_plugin = {
> +	.name = "UNIXSOCK",
> +	.input = {
> +		.type = ULOGD_DTYPE_SOURCE,
> +	},
> +	.output = {
> +		.type = ULOGD_DTYPE_RAW,
> +		.keys = output_keys,
> +		.num_keys = ARRAY_SIZE(output_keys),
> +	},
> +	.priv_size 	= sizeof(struct unixsock_input),
> +	.configure 	= &configure,
> +	.start 		= &start,
> +	.stop 		= &stop,
> +	.config_kset 	= &libunixsock_kset,
> +	.version	= ULOGD_VERSION,
> +};
> +
> +static void __attribute__ ((constructor)) init(void)
> +{
> +	ulogd_register_plugin(&libunixsock_plugin);
> +}
> diff --git a/ulogd.conf.in b/ulogd.conf.in
> index 4542fc4..323462b 100644
> --- a/ulogd.conf.in
> +++ b/ulogd.conf.in
> @@ -27,6 +27,7 @@ loglevel=1
>  
>  plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
>  #plugin="@libdir@/ulogd/ulogd_inppkt_ULOG.so"
> +#plugin="@libdir@/ulogd/ulogd_inppkt_UNIXSOCK.so"
>  plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
>  plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
>  plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
> @@ -75,6 +76,9 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
>  # this is a stack for logging packets to syslog after a collect via NFLOG
>  #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
>  
> +# this is a stack for logging packets to syslog after a collect via NuFW
> +#stack=nuauth1:UNIXSOCK,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
> +
>  # this is a stack for flow-based logging to MySQL
>  #stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
>  
> @@ -137,6 +141,9 @@ numeric_label=1 # you can label the log info based on the packet verdict
>  nlgroup=1
>  #numeric_label=0 # optional argument
>  
> +[nuauth1]
> +socket_path="/tmp/nuauth_ulogd2.sock"
> +
>  [emu1]
>  file="/var/log/ulogd_syslogemu.log"
>  sync=1

Interesting :-). I'm sorry that I couldn't provide you feedback until now.
