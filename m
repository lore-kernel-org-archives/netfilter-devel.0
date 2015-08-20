From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [lnf-log RFC PATCH 2/2] utils: take a example from libmnl and
 use nflog_nlmsg_parse
Date: Thu, 20 Aug 2015 20:16:13 +0200
Message-ID: <20150820181613.GA4227@salvia>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
 <20150820072645.GA3916@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40533 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbHTSKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 14:10:01 -0400
Content-Disposition: inline
In-Reply-To: <20150820072645.GA3916@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2015 at 04:26:45PM +0900, Ken-ichirou MATSUZAWA wrote:
>  Thank you for the reply.
> 
> On Thu, Aug 20, 2015 at 12:04:03AM +0200, Pablo Neira Ayuso wrote:
> > I suggest you remove the nflog_data_init(), nflog_data_alloc(),
> > nflog_data_free() and nflog_nlmsg_parse().
> > 
> > Those are part of the old API, we should focus on API that we can
> > combine with libmnl.
> 
> I think I can follow your suggestion, is it correct?
> 
> Please let me ask two more things.
> With these functions, nflog attrs can be acquired by
> mnl_attr_get_payload, but can not show as XML in one shot.
>
> To do it, may I post another patch:
> 
>     struct nflog_data *nfnl_attrs2data(struct nlattr **attr)
>     {
>         struct nflog_data *nfad = calloc(1, sizeof(struct nflog_data));
>         if (nfad == NULL)
>             return NULL;
>         nfad->nfa = (struct nfattr **)&attr[1];
>         return nfad;
>     }
> 
> Is it acceptable?

I would like not to have any code that mixes both APIs. The idea is to
deprecate libnfnetlink and any client of that library at some point,
that will take quite time though since we'll have to mark those old
interfaces as deprecated.

Please, see my rough proposal patch attached so you also have access
to the XML output, it applies on top of your patchset. I made some
quick testing here, review it. Note that I have also included the
nlmsghdr as it contains useful information that we may want to display
in the feature (eg. queue number).

> It's just my curiosity, would you tell me what does nfnl_ prefix
> stand for?

Good point, we should be using nflog_ prefix instead, sorry. nfnl_ is
already used by libnfnetlink so we can't use it.

Will you send me a new round of patches? Thanks!

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="kenichirou.patch"

diff --git a/include/internal.h b/include/internal.h
new file mode 100644
index 0000000..7839fd8
--- /dev/null
+++ b/include/internal.h
@@ -0,0 +1,9 @@
+#ifndef _LIBNETFILTER_LOG_INTERNAL_H
+#define _LIBNETFILTER_LOG_INTERNAL_H
+
+struct nflog_data
+{
+	struct nfattr **nfa;
+};
+
+#endif
diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 723d812..60cabb9 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -89,4 +89,12 @@ extern int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t r
 extern int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, uint8_t cmd);
 extern int nfnl_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 
+enum nflog_output_type {
+	NFLOG_OUTPUT_XML	= 0,
+};
+
+int nflog_nlmsg_snprintf(char *buf, size_t bufsiz, const struct nlmsghdr *nlh,
+			 struct nlattr **attr, enum nflog_output_type type,
+			 uint32_t flags);
+
 #endif	/* __LIBNETFILTER_LOG_H */
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index e92576b..567049c 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -26,6 +26,7 @@
 #include <errno.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
+#include "internal.h"
 
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
@@ -78,11 +79,6 @@ struct nflog_g_handle
 	void *data;
 };
 
-struct nflog_data
-{
-	struct nfattr **nfa;
-};
-
 int nflog_errno;
 
 /***********************************************************************
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 5c133fa..86da579 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -9,6 +9,9 @@
 #include <arpa/inet.h>
 #include <linux/netfilter/nfnetlink_log.h>
 #include <libmnl/libmnl.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+#include <errno.h>
+#include "internal.h"
 
 /**
  * \defgroup nlmsg Netlink message helper functions
@@ -156,6 +159,27 @@ int nfnl_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 			      nfnl_parse_attr_cb, attr);
 }
 
+int nflog_nlmsg_snprintf(char *buf, size_t bufsiz, const struct nlmsghdr *nlh,
+			 struct nlattr **attr, enum nflog_output_type type,
+			 uint32_t flags)
+{
+	/* This is a hack to re-use the existing old API code. */
+	struct nflog_data nfad = {
+		.nfa	= (struct nfattr **)&attr[1],
+	};
+	int ret;
+
+	switch (type) {
+	case NFLOG_OUTPUT_XML:
+		ret = nflog_snprintf_xml(buf, bufsiz, &nfad, flags);
+	default:
+		ret = -1;
+		errno = EOPNOTSUPP;
+		break;
+	}
+	return ret;
+}
+
 /**
  * @}
  */
diff --git a/utils/nf-log.c b/utils/nf-log.c
index 0ff1392..dafaeb7 100644
--- a/utils/nf-log.c
+++ b/utils/nf-log.c
@@ -14,6 +14,7 @@ static int log_cb(const struct nlmsghdr *nlh, void *data)
 	struct nfulnl_msg_packet_hdr *ph = NULL;
 	const char *prefix = NULL;
 	uint32_t mark = 0;
+	char buf[4096];
 	int ret;
 
 	ret = nfnl_nlmsg_parse(nlh, attrs);
@@ -31,6 +32,10 @@ static int log_cb(const struct nlmsghdr *nlh, void *data)
 		prefix ? prefix : "", ntohs(ph->hw_protocol), ph->hook,
 		mark);
 
+	nflog_nlmsg_snprintf(buf, sizeof(buf), nlh, attrs, NFLOG_OUTPUT_XML,
+			     NFLOG_XML_ALL);
+	printf("%s (ret =%d)\n", buf, ret);
+
 	return MNL_CB_OK;
 }
 

--ikeVEW9yuYc//A+q--
