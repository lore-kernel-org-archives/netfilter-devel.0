From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 v2] libnftnl: Implement new buffer of TLV objects.
Date: Tue, 8 Mar 2016 11:10:20 +0100
Message-ID: <20160308101020.GA3390@salvia>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
 <20160302183207.GA1351@salvia>
 <56DEA21E.4000603@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818AbcCHKKa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 05:10:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C073F61E80
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:10:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADB13DA380
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:10:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5D182DA396
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:10:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56DEA21E.4000603@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 10:57:50AM +0100, Carlos Falgueras Garc=EDa wro=
te:
> On 02/03/16 19:32, Pablo Neira Ayuso wrote:
> >On Mon, Feb 29, 2016 at 05:25:38PM +0100, Carlos Falgueras Garc=EDa =
wrote:
> >>diff --git a/include/attr.h b/include/attr.h
> >>new file mode 100644
> >>index 0000000..2a29fa0
> >>--- /dev/null
> >>+++ b/include/attr.h
> >>@@ -0,0 +1,40 @@
> >>+#ifndef _LIBNFTNL_ATTR_INTERNAL_H_
> >>+#define _LIBNFTNL_ATTR_INTERNAL_H_
> >>+
> >>+#include <stdint.h>
> >>+#include <stddef.h>
> >>+
> >>+/*
> >>+ * TLV structures:
> >>+ * nftnl_attr
> >>+ *  <-------- HEADER --------> <------ PAYLOAD ------>
> >>+ * +------------+-------------+- - - - - - - - - - - -+
> >>+ * |    type    |     len     |         value         |
> >>+ * |  (1 byte)  |   (1 byte)  |                       |
> >>+ * +--------------------------+- - - - - - - - - - - -+
> >>+ *  <-- sizeof(nftnl_attr) --> <-- nftnl_attr->len -->
> >>+ */
> >>+struct __attribute__((__packed__)) nftnl_attr {
> >>+	uint8_t type;
> >>+	uint8_t len;
> >>+	unsigned char value[];
> >>+};
> >
> >struct nftnl_attr {
> >       ...
> >} __attribute__((__packed__));
> >
>=20
> I forgot these, sorry. I'll send a new versi=F3n now.

Thanks Carlos.

> >>diff --git a/src/libnftnl.map b/src/libnftnl.map
> >>index 2e193b7..65bd37e 100644
> >>--- a/src/libnftnl.map
> >>+++ b/src/libnftnl.map
> >>@@ -336,6 +336,22 @@ global:
> >>    nftnl_set_snprintf;
> >>    nftnl_set_fprintf;
> >>
> >>+  nftnl_attrbuf_alloc;
> >>+  nftnl_attrbuf_free;
> >>+  nftnl_attrbuf_get_len;
> >>+  nftnl_attrbuf_get_size;
> >>+  nftnl_attrbuf_get_data;
> >>+  nftnl_attrbuf_copy_data;
> >>+  nftnl_attrbuf_get_start;
> >>+  nftnl_attrbuf_get_end;
> >>+  nftnl_attr_get_type;
> >>+  nftnl_attr_get_len;
> >>+  nftnl_attr_get_value;
> >>+  nftnl_attr_put;
> >>+  nftnl_attr_put_check;
> >>+  nftnl_attr_next;
> >>+  nftnl_attr_parse;
> >
> >Are you sure we need to export all these? Please only export those
> >functions that we really need at this stage for nft.
>=20
> The only function that is not being used now is "nftnl_udata_size". B=
ut I
> left it because "size" is an attribute of the object and I think it i=
s right
> to allow the access to it. I must remove it anyway?

OK, keep it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
