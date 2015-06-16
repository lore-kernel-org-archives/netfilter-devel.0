From: Roman Kubiak <r.kubiak@samsung.com>
Subject: [PATCH] libmnl: security context retrieval in nf-queue example
Date: Tue, 16 Jun 2015 14:25:13 +0200
Message-ID: <558015A9.8060703@samsung.com>
References: <55646731.9040803@samsung.com>
 <20150526130623.GD7817@breakpoint.cc> <5565A4D2.70701@samsung.com>
 <5565A6AA.90908@samsung.com> <20150527124957.GA19819@salvia>
 <557855B2.8030803@samsung.com> <20150610160541.GD7125@breakpoint.cc>
 <55798582.1040903@samsung.com> <20150611233757.GE7125@breakpoint.cc>
 <557AB559.1000001@samsung.com> <20150612130240.GA29551@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10372 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbFPMZR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 08:25:17 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQ100DEJEI29470@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 16 Jun 2015 13:25:14 +0100 (BST)
In-reply-to: <20150612130240.GA29551@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is an addition to "[PATCH v3] nfnetlink_queue: add security context information"
It adds and example to libmnl that illustrates how to fetch security context.
A corresponding patch was sent for libnetfilter_queue already.

-- cut here

This patch modifies the example program for nf-queue
to demonstrate how to retriece security context information
for queued packages. This can also be easily extended to
retrieve other information supported by this subsystem.

Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
---
 examples/netfilter/nf-queue.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index 957e365..adafbed 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -21,7 +21,7 @@ static int parse_attr_cb(const struct nlattr *attr, void *data)
 		return MNL_CB_OK;
 
 	switch(type) {
-	case NFQA_MARK:
+	case NFQA_SECCTX:
 	case NFQA_IFINDEX_INDEV:
 	case NFQA_IFINDEX_OUTDEV:
 	case NFQA_IFINDEX_PHYSINDEV:
@@ -56,17 +56,25 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[NFQA_MAX+1] = {};
 	struct nfqnl_msg_packet_hdr *ph = NULL;
-	uint32_t id = 0;
+	uint32_t id = 0, seclen = 0;
+	const char *secctx = NULL;
 
 	mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, tb);
 	if (tb[NFQA_PACKET_HDR]) {
 		ph = mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
 		id = ntohl(ph->packet_id);
 
-		printf("packet received (id=%u hw=0x%04x hook=%u)\n",
+		printf("packet received (id=%u hw=0x%04x hook=%u",
 		       id, ntohs(ph->hw_protocol), ph->hook);
 	}
 
+	if (tb[NFQA_SECCTX]) {
+		seclen = mnl_attr_get_payload_len(tb[NFQA_SECCTX]);
+		secctx = mnl_attr_get_str(tb[NFQA_SECCTX]);
+		printf(" secctx=%.*s", seclen, secctx);
+	}
+
+	printf(")\n");
 	return MNL_CB_OK + id;
 }
 
@@ -112,6 +120,27 @@ nfq_build_cfg_request(char *buf, uint8_t command, int queue_num)
 }
 
 static struct nlmsghdr *
+nfq_build_cfg_flags(char *buf, uint32_t mask, uint32_t flags, int queue_num)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	mask = htonl(mask);
+	flags = htonl(flags);
+
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, flags);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, mask);
+
+	return nlh;
+}
+
+static struct nlmsghdr *
 nfq_build_cfg_params(char *buf, uint8_t mode, int range, int queue_num)
 {
 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
@@ -209,6 +238,14 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	nlh = nfq_build_cfg_flags(buf, NFQA_CFG_F_SECCTX,
+					NFQA_CFG_F_SECCTX, queue_num);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	if (ret == -1) {
 		perror("mnl_socket_recvfrom");
-- 
2.0.1


On 06/12/2015 03:02 PM, Pablo Neira Ayuso wrote:
> On Fri, Jun 12, 2015 at 12:32:57PM +0200, Roman Kubiak wrote:
>> This way works and seems sensible (i tested it)
>>
>> a fixed patch below
>>
>> -- cut here
>>
>> This patch adds an additional attribute when sending
>> packet information via netlink in netfilter_queue module.
>> It will send additional security context data, so that
>> userspace applications can verify this context against
>> their own security databases.
> 
> Please, send the corresponding userspace updates for this. Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--------------
 Roman Kubiak
--------------
