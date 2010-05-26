From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] add nfq_snprintf_xml() to output a packet in XML
 format
Date: Wed, 26 May 2010 17:44:21 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005261740270.1686@obet.zrqbmnf.qr>
References: <20100526123953.6016.65536.stgit@decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36164 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0EZPoX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 11:44:23 -0400
In-Reply-To: <20100526123953.6016.65536.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-05-26 14:39, Pablo Neira Ayuso wrote:

>This patch adds a new function to output the packet in XML format.

>+int nfq_snprintf_xml(char *buf, int len, struct nfq_data *tb, int flags)
>+{
>+	struct nfqnl_msg_packet_hdr *ph;
>+	struct nfqnl_msg_packet_hw *hwph;
>+	u_int32_t mark, ifi;
>+	int size, offset = 0, ret;
>+	char *data;
>+
>+	size = snprintf(buf + offset, len, "<pkt>");
>+	SNPRINTF_FAILURE(size, len, offset);
>+
>+	ph = nfq_get_msg_packet_hdr(tb);
>+	if (ph) {
>+		size = snprintf(buf + offset, len,
>+				"<hook>%u</hook><id>%u</id>",
>+				ph->hook, ntohl(ph->packet_id));
>+		SNPRINTF_FAILURE(size, len, offset);

Couldn't libxml be used to generate the XML?

>+	ret = nfq_get_payload(tb, &data);
>+	if (ret >= 0 && (flags & NFQ_XML_PAYLOAD)) {
>+		int i;
>+
>+		size = snprintf(buf + offset, len, "<payload>");
>+		SNPRINTF_FAILURE(size, len, offset);
>+
>+		for (i=0; i<ret; i++) {
>+			size = snprintf(buf + offset, len, "x%02x",

What's the leading x for? It seems to add no value.

>+					data[i] & 0xff);
>+			SNPRINTF_FAILURE(size, len, offset);
>+		}
>+
>+		size = snprintf(buf + offset, len, "</payload>");
>+		SNPRINTF_FAILURE(size, len, offset);
>+	}
>+
>+	size = snprintf(buf + offset, len, "</pkt>");
>+	SNPRINTF_FAILURE(size, len, offset);
>+
>+	return size;
>+}
>+
