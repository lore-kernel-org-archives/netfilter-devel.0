Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92712DE71A
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 18:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762800463; cv=none; b=tJqlMTsAKM4HOzEoB0v2KuRfuban/Icjn9QXeL9KUovseUrr5B+ma5d1mIgGzzqZBH0d9ggvXvn5vy75+Wz1u2bjEKs2Q4Das6cUmZPV0qnMgYOmxFDczZxvkDX60pfHFyKmP5yHbnJhFnh1yNT4/fHFgFwBzHo3oTnfGRiaDWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762800463; c=relaxed/simple;
	bh=eZwCu060A5fWTCiWzsNLtPSrhSkzPyaZ4C02RgTaKzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXoBOMMzRYhhfujxt0SZodb6efy87HRT7B+qqeWTkJoLpQndDihF2Qa6RdKiYbM/sI7pzvb9x2pgNhCCytE5+ru0Dp7uq6xJpxzThh3dLuEKz4k7aoiKxUsAzrTIp8QIanAc2lP1XMnC50XmQQSCj9ytsQddGRODjlXvZ6pkupA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B0203604EE; Mon, 10 Nov 2025 19:42:03 +0100 (CET)
Date: Mon, 10 Nov 2025 19:41:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Serhii Ivanov <icegood1980@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Added netfilter output plugin with ability to write into
 pcap nflog packets
Message-ID: <aRIx9qRHpZGQqi6T@strlen.de>
References: <20251109092304.1279619-2-icegood1980@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109092304.1279619-2-icegood1980@gmail.com>

Serhii Ivanov <icegood1980@gmail.com> wrote:
> Extend inpit nflog plugin
> to get more information
> 
> Chenged conmfiguration files for
> proper dependencies to ntlog/ct/ctacc

This is way too many different changes in one patch,
sorry.

> diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
> index 29082df..b0d2236 100644
> --- a/include/ulogd/ulogd.h
> +++ b/include/ulogd/ulogd.h
> @@ -19,7 +19,7 @@
>  #include <inttypes.h>
>  #include <netinet/in.h>
>  #include <string.h>
> -#include <config.h>
> +#include <config.h> // all config stuff there

Please drop this hunk.

> diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
> index 20c51ec..f63cc6e 100644
> --- a/input/packet/Makefile.am
> +++ b/input/packet/Makefile.am
> @@ -1,17 +1,21 @@
>  include $(top_srcdir)/Make_global.am
>  
> -AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS}
> -
>  pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
>  
>  ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
>  ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
>  
>  if BUILD_NFLOG
> -pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
> +    AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
> +
> +    pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
>  
> -ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
> -ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
> -ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS) \
> -				$(LIBNETFILTER_CONNTRACK_LIBS)
> +    ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
> +    ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
> +    ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS)
> +
> +if BUILD_NFCT
> +    AM_CPPFLAGS += $(LIBMNL_CFLAGS) ${LIBNETFILTER_CONNTRACK_CFLAGS}
> +    ulogd_inppkt_NFLOG_la_LIBADD += $(LIBMNL_LIBS) $(LIBNETFILTER_CONNTRACK_LIBS)
> +endif
>  endif

This looks like it includes additional, unrelated move of lines,
please do not do this, it makes it harder to review.

> +struct connttrack {
> +    struct nf_conntrack *ct;
> +    uint32_t info;
> +};

Typo,  but please please follow what kernel is doing instead,
see below.

>  #ifndef NFLOG_GROUP_DEFAULT
>  #define NFLOG_GROUP_DEFAULT	0
> @@ -154,6 +159,8 @@ enum nflog_keys {
>  	NFLOG_KEY_OOB_SEQ_LOCAL,
>  	NFLOG_KEY_OOB_SEQ_GLOBAL,
>  	NFLOG_KEY_OOB_FAMILY,
> +    NFLOG_KEY_OOB_VERSION,
> +    NFLOG_KEY_OOB_RES_ID,

Indendation is off, this should be one tab and not 4 spaces.

> -struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg)
> +void build_ct(struct nfgenmsg *nfmsg, struct connttrack *res)

Please use:
struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg, uint32_t *info)

Alternatively, if you plan further changes that warrant a
result-structure please make one preparation patch and explain
that this is going to be needed to return N new attributes
to the caller.

> +	res->ct = NULL;
> +	res->info = (uint32_t)-1;

I think this should be set to 0, i.e.
	*info = 0;

>  	mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
> -		if (mnl_attr_get_type(attr) == NFULA_CT) {
> -			ctattr = attr;
> +		switch (mnl_attr_get_type(attr)) {
> +			case NFULA_CT:
> +			{
> +				ctattr = attr;
> +				found |= 1;
> +				break;
> +			}
> +			case NFULA_CT_INFO: {
> +				res->info = ntohl(mnl_attr_get_u32(attr));
> +				found |= 2;
> +				break;
> +			}
> +        }
> +		if (found == 3) {
>  			break;

I don't think this new 'found' variable is needed.

> @@ -396,8 +442,9 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
>  	uint32_t uid;
>  	uint32_t gid;
>  
> -	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], 
> -		    pf_family);
> +	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], header->nfgen_family);

Why is this change here in the first place?

I think the part that adds the version and res_id fields should
be extra patch + explanation/changelog why its added.

>  	if ((strlen(target_netns_path) > 0) &&
>  	    (join_netns_path(target_netns_path, &source_netns_fd) != ULOGD_IRET_OK)
>  	   ) {
> -		ulogd_log(ULOGD_FATAL, "error joining target network "
> -		                       "namespace\n");
> +		ulogd_log(ULOGD_FATAL, "error joining target network namespace\n");
>  		goto out_ns;
>  	}

Please leave this as-is.

> diff --git a/output/pcap/ulogd_output_PCAP_NFLOG.c b/output/pcap/ulogd_output_PCAP_NFLOG.c
> new file mode 100644
> index 0000000..297e27e
> --- /dev/null
> +++ b/output/pcap/ulogd_output_PCAP_NFLOG.c
> @@ -0,0 +1,573 @@
> +/*
> + * ulogd_output_PCAP_CT.c - ULOGD plugin to merge packet and flow data
> + *
> + * Enriches NFLOG packets with connection tracking flow information
> + * by querying the NFCT table on each packet.
> + *
> + * Stack configuration:
> + * stack=log42:NFLOG,pcapct42:PCAP_NFLOG
> + */
> +
> +#include <errno.h>
> +#include <endian.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <time.h>
> +#include <sys/time.h>
> +#include <sys/socket.h>
> +#include <netinet/in.h>
> +#include <arpa/inet.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nfnetlink_log.h>
> +#include <libnetfilter_log/libnetfilter_log.h>
> +#include <ulogd/ulogd.h>
> +#include <ulogd/conffile.h>
> +#include <sys/stat.h>
> +
> +#ifdef BUILD_NFCT
> +    #include <linux/netfilter/nfnetlink_conntrack.h>
> +    #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
> +    #include <linux/netfilter/nf_conntrack_common.h>
> +#endif
> +
> +#include <pcap/pcap.h>  // for pcap_file_header, PCAP_VERSION_MAJOR/MINOR
> +
> +#define NFLOG_TLV_FLOW_INFO    19  /* Enriched flow metadata */
> +
> +#define LINKTYPE_NFLOG  0xEF
> +#define TCPDUMP_MAGIC   0xa1b2c3d4
> +
> +static struct config_keyset pcap_nflog_kset = {
> +    .num_ces = 2,
> +    .ces = {
> +        [0] = { .key = "file", .type = CONFIG_TYPE_STRING, .options = CONFIG_OPT_NONE, .u.string = "/tmp/ulogd_enriched.pcap" },
> +        [1] = { .key = "sync", .type = CONFIG_TYPE_INT,    .options = CONFIG_OPT_NONE, .u.value  = 1 }
> +    }
> +};
> +
> +struct pcap_nflog_data {
> +    FILE *output_file;
> +};
> +
> +enum pcap_nflog_input_keys_id {
> +    NFLOG_KEY_RAW_MAC = 0,
> +    NFLOG_KEY_RAW_PCKT,
> +    NFLOG_KEY_RAW_PCKTLEN,
> +    NFLOG_KEY_RAW_PCKTCOUNT,
> +    NFLOG_KEY_OOB_PREFIX,
> +    NFLOG_KEY_OOB_TIME_SEC,
> +    NFLOG_KEY_OOB_TIME_USEC,
> +    NFLOG_KEY_OOB_MARK,
> +    NFLOG_KEY_OOB_IFINDEX_IN,
> +    NFLOG_KEY_OOB_IFINDEX_OUT,
> +    NFLOG_KEY_OOB_HOOK,
> +    NFLOG_KEY_RAW_MAC_LEN,
> +    NFLOG_KEY_OOB_SEQ_LOCAL,
> +    NFLOG_KEY_OOB_SEQ_GLOBAL,
> +    NFLOG_KEY_OOB_FAMILY,
> +    NFLOG_KEY_OOB_VERSION,
> +    NFLOG_KEY_OOB_RES_ID,
> +    NFLOG_KEY_OOB_PROTOCOL,
> +    NFLOG_KEY_OOB_UID,
> +    NFLOG_KEY_OOB_GID,
> +    NFLOG_KEY_RAW_LABEL,
> +    NFLOG_KEY_RAW_TYPE,
> +    NFLOG_KEY_RAW_MAC_SADDR,
> +    NFLOG_KEY_RAW_MAC_ADDRLEN,
> +    NFLOG_KEY_RAW,
> +    NFLOG_KEY_RAW_CT,
> +    NFLOG_KEY_CT_INFO,
> +    __PCAP_NFLOG_INPUT_KEY_MAX
> +};
> +
> +static struct ulogd_key pcap_nflog_input_keys[] = {
> +    [NFLOG_KEY_RAW_MAC]        = { .type = ULOGD_RET_RAW,    .name = "raw.mac" },
> +    [NFLOG_KEY_RAW_PCKT]       = { .type = ULOGD_RET_RAW,    .name = "raw.pkt" },
> +    [NFLOG_KEY_RAW_PCKTLEN]    = { .type = ULOGD_RET_UINT32, .name = "raw.pktlen" },
> +    [NFLOG_KEY_RAW_PCKTCOUNT]  = { .type = ULOGD_RET_UINT32, .name = "raw.pktcount" },
> +    [NFLOG_KEY_OOB_PREFIX]     = { .type = ULOGD_RET_STRING, .name = "oob.prefix" },
> +    [NFLOG_KEY_OOB_TIME_SEC]   = { .type = ULOGD_RET_UINT32, .name = "oob.time.sec" },
> +    [NFLOG_KEY_OOB_TIME_USEC]  = { .type = ULOGD_RET_UINT32, .name = "oob.time.usec" },
> +    [NFLOG_KEY_OOB_MARK]       = { .type = ULOGD_RET_UINT32, .name = "oob.mark" },
> +    [NFLOG_KEY_OOB_IFINDEX_IN] = { .type = ULOGD_RET_UINT32, .name = "oob.ifindex_in" },
> +    [NFLOG_KEY_OOB_IFINDEX_OUT]= { .type = ULOGD_RET_UINT32, .name = "oob.ifindex_out" },
> +    [NFLOG_KEY_OOB_HOOK]       = { .type = ULOGD_RET_UINT8,  .name = "oob.hook" },
> +    [NFLOG_KEY_RAW_MAC_LEN]    = { .type = ULOGD_RET_UINT16, .name = "raw.mac_len" },
> +    [NFLOG_KEY_OOB_SEQ_LOCAL]  = { .type = ULOGD_RET_UINT32, .name = "oob.seq.local" },
> +    [NFLOG_KEY_OOB_SEQ_GLOBAL] = { .type = ULOGD_RET_UINT32, .name = "oob.seq.global" },
> +    [NFLOG_KEY_OOB_FAMILY]     = { .type = ULOGD_RET_UINT8,  .name = "oob.family" },
> +    [NFLOG_KEY_OOB_VERSION]     = { .type = ULOGD_RET_UINT8,  .name = "oob.version" },
> +    [NFLOG_KEY_OOB_RES_ID]     = { .type = ULOGD_RET_UINT16,  .name = "oob.resid" },
> +    [NFLOG_KEY_OOB_PROTOCOL]   = { .type = ULOGD_RET_UINT16, .name = "oob.protocol" },
> +    [NFLOG_KEY_OOB_UID]        = { .type = ULOGD_RET_UINT32, .name = "oob.uid" },
> +    [NFLOG_KEY_OOB_GID]        = { .type = ULOGD_RET_UINT32, .name = "oob.gid" },
> +    [NFLOG_KEY_RAW_LABEL]      = { .type = ULOGD_RET_UINT8,  .name = "raw.label" },
> +    [NFLOG_KEY_RAW_TYPE]       = { .type = ULOGD_RET_UINT16, .name = "raw.type" },
> +    [NFLOG_KEY_RAW_MAC_SADDR]  = { .type = ULOGD_RET_RAW,    .name = "raw.mac.saddr" },
> +    [NFLOG_KEY_RAW_MAC_ADDRLEN]= { .type = ULOGD_RET_UINT16, .name = "raw.mac.addrlen" },
> +    [NFLOG_KEY_RAW]            = { .type = ULOGD_RET_RAW,    .name = "raw" },
> +    [NFLOG_KEY_RAW_CT]         = { .type = ULOGD_RET_RAW,    .name = "ct" },
> +    [NFLOG_KEY_CT_INFO]        = { .type = ULOGD_RET_UINT32, .name = "ct_info" },
> +};
> +
> +#define get(proc,key) (pp_is_valid(pi->input.keys, key) ? ikey_get_ ## proc (&pi->input.keys[key]) : 0)
> +
> +#define write_section_proc(section, type, getter) \
> +{ \
> +    uint##type##_t temp = getter; \
> +    if (write_nflog_tlv(&buf_ptr, buf_end, section, &temp, sizeof(temp)) < 0) { \
> +        return -1; \
> +    } \
> +}
> +
> +#define write_section(section, key, type) write_section_proc(section, type, get(u##type, key))
> +
> +#define write_u32_section(section, key) write_section(section, key, 32)
> +#define write_u16_section(section, key) write_section(section, key, 16)
> +
> +static int write_pcap_header(FILE *f)
> +{
> +    struct pcap_file_header pcfh;
> +    pcfh.magic = TCPDUMP_MAGIC;
> +    pcfh.version_major = PCAP_VERSION_MAJOR;
> +    pcfh.version_minor = PCAP_VERSION_MINOR;
> +    pcfh.thiszone = 0;
> +    pcfh.sigfigs = 0;
> +    pcfh.snaplen = 4096;
> +    pcfh.linktype = LINKTYPE_NFLOG;
> +
> +    return fwrite(&pcfh, sizeof(pcfh), 1, f) == 1 ? 0 : -1;
> +}
> +
> +static int write_nflog_tlv(char **buf, const char *buf_end, uint16_t type,
> +                           const void *data, uint16_t data_len)
> +{
> +    uint16_t tlv_len = data_len + 4;
> +    uint16_t padded_len = (tlv_len + 3) & ~3;
> +
> +    int delta = *buf + padded_len - buf_end;
> +    if (0 <= delta) {
> +        ulogd_log(ULOGD_NOTICE, "Cannot write %u. No space left in buffer (above = %d)\n", type, delta);
> +        return -1;
> +    }
> +
> +    *(uint16_t*)*buf = tlv_len;
> +    *(uint16_t*)(*buf + 2) = type;
> +    memcpy(*buf + 4, data, data_len);
> +
> +    if (padded_len > tlv_len)
> +        memset(*buf + tlv_len, 0, padded_len - tlv_len);
> +
> +    *buf += padded_len;
> +    return padded_len;
> +}
> +
> +static uint64_t u32_to_be64(uint32_t x) {
> +    uint64_t v = (uint64_t)x;
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +    v = __builtin_bswap64(v);
> +#endif
> +    return v;
> +}
> +
> +#define nfct_get_attr_(ct, attr_id) (const char*)nfct_get_attr(ct, attr_id)
> +
> +#define print_ct(fmt, ...) \
> +{ \
> +    int res = snprintf(flow_info + pos, sizeof(flow_info) - pos, fmt "\n", __VA_ARGS__); \
> +    if (res < 0) { \
> +        ulogd_log(ULOGD_NOTICE, "CT: cannot write to buffer: %m\n"); \
> +        goto print_ct_section; \
> +    } \
> +    pos += res; \
> +}
> +
> +#define print_ct_attribute(attr_id, format, type) \
> +{ \
> +    if (nfct_attr_is_set(ct, attr_id)) { \
> +        print_ct(format, nfct_get_attr_##type(ct, attr_id)); \
> +    } \
> +    if (pos >= sizeof(flow_info)) { \
> +        goto print_ct_section; \
> +    } \
> +}
> +
> +#define print_ct_attribute_pair(attr1, attr2, format, type) \
> +{ \
> +    if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
> +        print_ct(format, nfct_get_attr_##type(ct, attr1), nfct_get_attr_##type(ct, attr2)); \
> +    } \
> +    if (pos >= sizeof(flow_info)) { \
> +        goto print_ct_section; \
> +    } \
> +}
> +
> +#define print_ct_ip4_pair(attr1, attr2, format) \
> +{ \
> +    if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
> +        uint32_t ip1_be = nfct_get_attr_u32(ct, attr1); \
> +        uint32_t ip2_be = nfct_get_attr_u32(ct, attr2); \
> +        \
> +        struct in_addr attr1_ip = { .s_addr = ip1_be }; \
> +        struct in_addr attr2_ip = { .s_addr = ip2_be }; \
> +        \
> +        print_ct(format, inet_ntoa(attr1_ip), inet_ntoa(attr2_ip)); \
> +    } \
> +    \
> +    if (pos >= sizeof(flow_info)) { \
> +        goto print_ct_section; \
> +    } \
> +}
> +
> +#define print_ct_ip6_pair(attr1, attr2, format) \
> +{ \
> +    if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
> +        const void * ip1_raw = nfct_get_attr(ct, attr1); \
> +        const void * ip2_raw = nfct_get_attr(ct, attr2); \
> +        \
> +        char ip1_str[INET6_ADDRSTRLEN]; \
> +        char ip2_str[INET6_ADDRSTRLEN]; \
> +        \
> +        inet_ntop(AF_INET6, ip1_raw, ip1_str, INET6_ADDRSTRLEN); \
> +        inet_ntop(AF_INET6, ip2_raw, ip2_str, INET6_ADDRSTRLEN); \
> +        \
> +        print_ct(format, ip1_str, ip2_str); \
> +    } \
> +    \
> +    if (pos >= sizeof(flow_info)) { \
> +        goto print_ct_section; \
> +    } \
> +}
> +
> +static int write_pcap_nflog_packet(struct ulogd_pluginstance *pi, FILE *of)
> +{
> +    char buffer[4096];
> +    char *buf_ptr = buffer;
> +    const char *buf_end = buffer + sizeof(buffer);
> +#ifdef BUILD_NFCT
> +    struct nf_conntrack *ct = get(ptr, NFLOG_KEY_RAW_CT);
> +#endif
> +    struct nflog_data *nflog = get(ptr, NFLOG_KEY_RAW);
> +
> +    struct nfgenmsg pkt_hdr = {
> +        .nfgen_family=get(u8, NFLOG_KEY_OOB_FAMILY),
> +        .version=get(u8, NFLOG_KEY_OOB_VERSION),
> +        .res_id=htons(get(u16, NFLOG_KEY_OOB_RES_ID))};
> +    memcpy(buf_ptr, &pkt_hdr, sizeof(pkt_hdr));
> +    buf_ptr += sizeof(pkt_hdr);
> +
> +    // ---  NFULA_PACKET_HDR  ---
> +    {    struct nfulnl_msg_packet_hdr pkt_hdr_tlv = {
> +            .hw_protocol = htons(get(u16, NFLOG_KEY_OOB_PROTOCOL)),
> +            .hook = get(u8, NFLOG_KEY_OOB_HOOK),
> +            ._pad = 0
> +        };
> +        if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PACKET_HDR,
> +                &pkt_hdr_tlv, sizeof(pkt_hdr_tlv)) < 0) {
> +            return -1;
> +        }
> +    }
> +
> +    // --- NFULA_MARK --- 
> +    write_u32_section(NFULA_MARK, NFLOG_KEY_OOB_MARK);
> +
> +    // --- NFULA_TIMESTAMP --- 
> +    {
> +        struct nfulnl_msg_packet_timestamp ts = {
> +            .sec = u32_to_be64(get(u32, NFLOG_KEY_OOB_TIME_SEC)),
> +            .usec = u32_to_be64(get(u32, NFLOG_KEY_OOB_TIME_USEC))
> +        };
> +        
> +        if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_TIMESTAMP, &ts, sizeof(ts)) < 0) {
> +            return -1;
> +        }
> +    }
> +
> +    // --- NFULA_IFINDEX_INDEV --- 
> +    write_u32_section(NFULA_IFINDEX_INDEV, NFLOG_KEY_OOB_IFINDEX_IN);
> +
> +    // --- NFULA_IFINDEX_OUTDEV --- 
> +    write_u32_section(NFULA_IFINDEX_OUTDEV, NFLOG_KEY_OOB_IFINDEX_OUT);
> +
> +    // --- NFULA_IFINDEX_PHYSINDEV --- 
> +    write_section_proc(NFULA_IFINDEX_PHYSINDEV, 32, nflog_get_physindev(nflog));
> +
> +    // --- NFULA_IFINDEX_PHYSOUTDEV --- 
> +    write_section_proc(NFULA_IFINDEX_PHYSOUTDEV, 32, nflog_get_physoutdev(nflog));
> +
> +    // ---  NFULA_HWADDR  ---
> +    {
> +        uint16_t len = get(u16, NFLOG_KEY_RAW_MAC_ADDRLEN);
> +
> +        if (len > 0) {
> +            struct nfulnl_msg_packet_hw temp = {
> +                .hw_addrlen = htons(len),
> +                .hw_addr = {0},
> +            };
> +            if (pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_MAC_SADDR)) {
> +                void* value = ikey_get_ptr(&pi->input.keys[NFLOG_KEY_RAW_MAC_SADDR]);
> +                if (value) {
> +                    memcpy(&temp.hw_addr, value, len);
> +                }
> +            }
> +            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_HWADDR, &temp, sizeof(temp)) < 0) {
> +                return -1;
> +            }
> +        }
> +    }
> +
> +    // ---  NFULA_PAYLOAD  ---
> +    {
> +        void *pkt_data = get(ptr, NFLOG_KEY_RAW_PCKT);
> +        uint32_t pkt_len = get(u32, NFLOG_KEY_RAW_PCKTLEN);
> +
> +        if (pkt_data) {
> +            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PAYLOAD, pkt_data, pkt_len) < 0) {
> +                return -1;
> +            }
> +        }
> +    }
> +
> +    // ---  NFULA_PREFIX  ---
> +    {    char *prefix = (char *)get(ptr, NFLOG_KEY_OOB_PREFIX);
> +
> +        if (prefix) {
> +            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PREFIX, prefix, strlen(prefix)) < 0) {
> +                return -1;
> +            }
> +        }
> +    }
> +
> +    // --- NFULA_UID ---
> +    write_u32_section(NFULA_UID, NFLOG_KEY_OOB_UID);
> +
> +    // --- NFULA_SEQ ---
> +    write_u32_section(NFULA_SEQ, NFLOG_KEY_OOB_SEQ_LOCAL);
> +
> +    // --- NFULA_SEQ_GLOBAL ---
> +    write_u32_section(NFULA_SEQ_GLOBAL, NFLOG_KEY_OOB_SEQ_GLOBAL);
> +
> +    // --- NFULA_GID ---
> +    write_u32_section(NFULA_GID, NFLOG_KEY_OOB_GID);
> +
> +    // --- NFULA_HWTYPE ---
> +    write_u16_section(NFULA_HWTYPE, NFLOG_KEY_RAW_TYPE);
> +    // --- NFULA_HWLEN ---
> +    write_u16_section(NFULA_HWLEN, NFLOG_KEY_RAW_MAC_LEN);
> +    // --- NFULA_HWHEADER ---
> +    {
> +        char *data = get(ptr, NFLOG_KEY_RAW_MAC);
> +        size_t len = get(u16, NFLOG_KEY_RAW_MAC_LEN);
> +
> +        if ((len > 0) && (data != NULL)) {
> +            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_HWHEADER, data, len) < 0) {
> +                return -1;
> +            }
> +        }
> +    }
> +#ifdef BUILD_NFCT
> +    if (ct != NULL) {
> +        char flow_info[2048];
> +        size_t pos = 0;
> +
> +        // --- NFULA_CT_INFO ---
> +        write_u32_section(NFULA_CT_INFO, NFLOG_KEY_CT_INFO);
> +
> +        // --- NFULA_CT ---
> +        print_ct_attribute(ATTR_ID, "id=%u", u32);
> +        print_ct_attribute(ATTR_USE, "use=%u", u32);
> +        print_ct_attribute(ATTR_STATUS, "status=0x%08x", u32);
> +        print_ct_attribute(ATTR_TIMEOUT, "timeout=%u", u32);
> +        print_ct_attribute(ATTR_MARK, "mark=%u", u32);
> +        print_ct_attribute(ATTR_SECMARK, "security mark=%u", u32);
> +        
> +        print_ct_attribute_pair(ATTR_ORIG_COUNTER_PACKETS, ATTR_ORIG_COUNTER_BYTES, "orig packets/bytes=%lu/%lu", u64);
> +        print_ct_attribute_pair(ATTR_REPL_COUNTER_PACKETS, ATTR_REPL_COUNTER_BYTES, "repl packets/bytes=%lu/%lu", u64);
> +        
> +        print_ct_ip4_pair(ATTR_ORIG_IPV4_SRC, ATTR_ORIG_IPV4_DST, "orig ip4 src/dest=%s/%s");
> +        print_ct_ip6_pair(ATTR_ORIG_IPV6_SRC, ATTR_ORIG_IPV6_DST, "orig ip6 src/dest=%s/%s");
> +        print_ct_attribute_pair(ATTR_ORIG_PORT_SRC, ATTR_ORIG_PORT_DST, "orig port src/dest=%u/%u", u16);
> +
> +
> +        print_ct_ip4_pair(ATTR_REPL_IPV4_SRC, ATTR_REPL_IPV4_DST, "repl ip4 src/dest=%s/%s");
> +        print_ct_ip6_pair(ATTR_REPL_IPV6_SRC, ATTR_REPL_IPV6_DST, "repl ip6 src/dest=%s/%s");
> +        print_ct_attribute_pair(ATTR_REPL_PORT_SRC, ATTR_REPL_PORT_DST, "repl port src/dest=%u/%u", u16);
> +        
> +        print_ct_attribute_pair(ATTR_ORIG_L3PROTO, ATTR_REPL_L3PROTO, "l3proto orig/repl=%u/%u", u8);
> +        print_ct_attribute_pair(ATTR_ORIG_L4PROTO, ATTR_REPL_L4PROTO, "l4proto orig/repl=%u/%u", u8);
> +
> +        print_ct_ip4_pair(ATTR_MASTER_IPV4_SRC, ATTR_MASTER_IPV4_DST, "master ip4 src/dest=%s/%s");
> +        print_ct_ip6_pair(ATTR_MASTER_IPV6_SRC, ATTR_MASTER_IPV6_DST, "master ip6 src/dest=%s/%s");
> +        print_ct_attribute_pair(ATTR_MASTER_PORT_SRC, ATTR_MASTER_PORT_DST, "master port src/dest=%u/%u", u16);
> +        print_ct_attribute_pair(ATTR_MASTER_L3PROTO, ATTR_MASTER_L4PROTO, "master proto l3/l4=%u/%u", u8);
> +
> +        print_ct_attribute(ATTR_ZONE, "zone=%u", u16);
> +        print_ct_attribute_pair(ATTR_ORIG_ZONE, ATTR_REPL_ZONE, "zone orig/repl=%u/%u", u16);
> +        // tcp
> +        print_ct_attribute(ATTR_TCP_STATE, "tcp_state=%u", u8);
> +        print_ct_attribute_pair(ATTR_TCP_FLAGS_ORIG, ATTR_TCP_FLAGS_REPL, "tcp_flags orig/repl=%u/%u", u8);
> +        print_ct_attribute_pair(ATTR_TCP_MASK_ORIG, ATTR_TCP_MASK_REPL, "tcp_mask orig/repl=%u/%u", u8);
> +        // icmp
> +        print_ct_attribute(ATTR_ICMP_TYPE, "icmp_type=%u", u8);
> +        print_ct_attribute(ATTR_ICMP_CODE, "icmp_code=%u", u8);
> +        print_ct_attribute(ATTR_ICMP_ID, "icmp_id=%u", u16);
> +        // SCTP
> +        print_ct_attribute(ATTR_SCTP_STATE, "sctp_state=%u", u8);
> +        print_ct_attribute_pair(ATTR_SCTP_VTAG_ORIG, ATTR_SCTP_VTAG_REPL, "sctp vtag orig/repl=%u/%u", u8);
> +        // DCCP
> +        print_ct_attribute(ATTR_DCCP_STATE, "dccp_state=%u", u8);
> +        print_ct_attribute(ATTR_DCCP_ROLE, "dccp_role=%u", u8);
> +        print_ct_attribute(ATTR_DCCP_HANDSHAKE_SEQ, "dccp_handshake_seq=%lu", u64);
> +
> +        print_ct_attribute(ATTR_HELPER_NAME, "helper=%s", );
> +        print_ct_attribute(ATTR_HELPER_INFO, "helper info=%s", );
> +        print_ct_attribute(ATTR_SECCTX, "sec context=%s", );
> +
> +        // NAT
> +        print_ct_ip4_pair(ATTR_SNAT_IPV4, ATTR_DNAT_IPV4, "NAT ip4 src/dest=%s/%s");
> +        print_ct_ip6_pair(ATTR_SNAT_IPV6, ATTR_DNAT_IPV6, "NAT ip6 src/dest=%s/%s");
> +        print_ct_attribute_pair(ATTR_SNAT_PORT, ATTR_DNAT_PORT, "NAT port src/dest=%u/%u", u16);
> +
> +        print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_CORRECTION_POS, ATTR_REPL_NAT_SEQ_CORRECTION_POS, "NAT SEQ Corr Pos orig/repl=%u/%u", u32);
> +        print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE, ATTR_REPL_NAT_SEQ_OFFSET_BEFORE, "NAT SEQ Offset Bef orig/repl=%u/%u", u32);
> +        print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ATTR_REPL_NAT_SEQ_OFFSET_AFTER, "NAT SEQ Offset After orig/repl=%u/%u", u32);
> +
> +print_ct_section:
> +        if (pos > 0)
> +            flow_info[pos - 1] = '\0';
> +
> +        if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_CT, flow_info, pos) < 0) {
> +            return -1;
> +        }
> +    }
> +#endif
> +    size_t total_len = buf_ptr - buffer;
> +    // ---  PCAP record header  ---
> +    struct {
> +        uint32_t ts_sec;
> +        uint32_t ts_usec;
> +        uint32_t caplen;
> +        uint32_t len;
> +    } ph;
> +
> +    ph.ts_sec = get(u32, NFLOG_KEY_OOB_TIME_SEC);
> +    ph.ts_usec = get(u32, NFLOG_KEY_OOB_TIME_USEC);
> +    ph.caplen = total_len;   // length of data written
> +    ph.len    = total_len;   // original length on wire
> +
> +    /* Write PCAP record */
> +    if ((fwrite(&ph, sizeof(ph), 1, of) != 1) || (fwrite(buffer, total_len, 1, of) != 1)) {
> +        ulogd_log(ULOGD_NOTICE, "Cannot write pcap record\n");
> +        return -1;
> +    }
> +
> +    if (pi->config_kset->ces[1].u.value)
> +        fflush(of);
> +
> +    return 0;
> +}
> +
> +static int pcap_nflog_output(struct ulogd_pluginstance *pi)
> +{
> +    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
> +
> +    if (!pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_PCKT) || !pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_PCKTLEN)) {
> +        ulogd_log(ULOGD_NOTICE, "Cannot get payload. Skipping packet\n");
> +        return -1;
> +    }
> +
> +        if (!get(ptr, NFLOG_KEY_RAW)) {
> +        ulogd_log(ULOGD_NOTICE, "No nflog pointer present\n");
> +        return -1;
> +    }
> +
> +    return write_pcap_nflog_packet(pi, data->output_file);
> +}
> +
> +static int reopen_file(struct ulogd_pluginstance *pi)
> +{
> +    const char *filename = pi->config_kset->ces[0].u.string;
> +    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
> +
> +    if (data->output_file)
> +        fclose(data->output_file);
> +    data->output_file = NULL;
> +    
> +    FILE *of = fopen(filename, "a");
> +    if (!of) {
> +        ulogd_log(ULOGD_ERROR, "Cannot create output file %s: %m\n", filename);
> +        return -EPERM;
> +    }
> +    data->output_file = of;
> +
> +    int empty = 1;
> +    struct stat st;
> +
> +    if (stat(filename, &st) == 0) {
> +        empty = st.st_size == 0;
> +    }
> +
> +    if (!empty) {
> +        return 0;
> +    } else {
> +        ulogd_log(ULOGD_NOTICE, "Output '%s' is empty. To write header\n", filename);
> +    }
> +    
> +    if (write_pcap_header(data->output_file) < 0) {
> +        ulogd_log(ULOGD_ERROR, "Cannot write header to file '%s'\n", filename);
> +        fclose(data->output_file);
> +        data->output_file = NULL;
> +        return -ENOSPC;
> +    }
> +    return 0;
> +}
> +
> +static int pcap_nflog_init(struct ulogd_pluginstance *pi)
> +{
> +    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
> +    memset(data, 0, sizeof(*data));
> +
> +    return reopen_file(pi);
> +}
> +
> +static int pcap_nflog_destroy(struct ulogd_pluginstance *pi)
> +{
> +    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
> +
> +    if (data->output_file) {
> +        fclose(data->output_file);
> +        data->output_file = NULL;
> +    }
> +    return 0;
> +}
> +
> +static void pcap_nflog_signal(struct ulogd_pluginstance *upi, int signal)
> +{
> +    ulogd_log(ULOGD_INFO, "pcap_nflog_signal: Delivered %d \n", signal);
> +    if (signal == SIGHUP) {
> +        ulogd_log(ULOGD_NOTICE, "reopening capture file\n");
> +        reopen_file(upi);
> +    }
> +}
> +
> +static struct ulogd_plugin pcap_nflog_plugin = {
> +    .name = "PCAP_NFLOG",
> +    .input = { .keys = pcap_nflog_input_keys, .num_keys = ARRAY_SIZE(pcap_nflog_input_keys),
> +               .type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_RAW },
> +    .output = { .type = ULOGD_DTYPE_SINK },
> +    .config_kset = &pcap_nflog_kset,
> +    .priv_size = sizeof(struct pcap_nflog_data),
> +    .start = pcap_nflog_init,
> +    .stop = pcap_nflog_destroy,
> +    .signal = &pcap_nflog_signal,
> +    .interp = pcap_nflog_output,
> +    .version = VERSION,
> +};
> +
> +void __attribute__ ((constructor)) init(void)
> +{
> +    ulogd_register_plugin(&pcap_nflog_plugin);
> +}
> \ No newline at end of file
> diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c

Looks like this file should not be touched at all.

> +++ b/src/ulogd.c

likewise.


So to recap I think there are several changes in this patch
that should not be mixed, if possible:

1. refactoring of configure.ac/makefile.am
2. extensions to the nflog input plugin
3. new output plugin
4. unwanted changes that provide no value (== reformatting).

I don't know if 1) is needed, but having 2 and 3 separate
would help with review.

It also provides opportunity to provide a rationale
for the change(s) in the patch description.
