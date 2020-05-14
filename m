Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E50C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 04:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F0020575
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 04:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgENEfz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 00:35:55 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44308 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgENEfy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 00:35:54 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail106.syd.optusnet.com.au (Postfix) with SMTP id 226125AAC4D
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:35:52 +1000 (AEST)
Received: (qmail 1307 invoked by uid 501); 14 May 2020 04:35:47 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 2/3] example: nf-queue: use pkt_buff
Date:   Thu, 14 May 2020 14:35:46 +1000
Message-Id: <20200514043547.1255-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200426132356.8346-3-pablo@netfilter.org>
References: <20200426132356.8346-3-pablo@netfilter.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=3HDBlxybAAAA:8
        a=IH-ITAO_KJS8c0ikSwYA:9 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

To hopefully save you time, the email after this is a patch implementing the
suggestions below, and also using the 5-args pktb_setup() interface which we
haven't agreed on yet.

Cheers ... Duncan.

On Sun, Apr 26, 2020 at 03:23:55PM +0200, Pablo Neira Ayuso wrote:
> Update example file to use the pkt_buff structure to store the payload.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  examples/nf-queue.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> index 3da2c249da23..f0d4c2ee7276 100644
> --- a/examples/nf-queue.c
> +++ b/examples/nf-queue.c
> @@ -14,6 +14,7 @@
>  #include <linux/netfilter/nfnetlink_queue.h>
>
>  #include <libnetfilter_queue/libnetfilter_queue.h>
> +#include <libnetfilter_queue/pktbuff.h>
>
>  /* only for NFQA_CT, not needed otherwise: */
>  #include <linux/netfilter/nfnetlink_conntrack.h>
> @@ -50,9 +51,12 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct nfqnl_msg_packet_hdr *ph = NULL;
>  	struct nlattr *attr[NFQA_MAX+1] = {};
> +	struct pkt_buff *pktb = data;
>  	uint32_t id = 0, skbinfo;
>  	struct nfgenmsg *nfg;
> +	uint8_t *payload;
>  	uint16_t plen;
> +	int i;
>
>  	if (nfq_nlmsg_parse(nlh, attr) < 0) {
>  		perror("problems parsing");
> @@ -69,7 +73,8 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
>  	ph = mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
>
>  	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
> -	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
> +
> +	pktb_build_data(pktb, mnl_attr_get_payload(attr[NFQA_PAYLOAD]), plen);
>
>  	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
>
> @@ -97,6 +102,14 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
>  		printf(", checksum not ready");
>  	puts(")");
>
> +	printf("payload (len=%d) [", plen);
> +	payload = pktb_data(pktb);
> +
> +	for (i = 0; i < pktb_len(pktb); i++)

'& 0xff' not necessary for uint8_t
"%02x" gives output that is more useful (longer though)

> +		printf("%x", payload[i] & 0xff);
> +
> +	printf("]\n");
> +
>  	nfq_send_verdict(ntohs(nfg->res_id), id);
>
>  	return MNL_CB_OK;
> @@ -107,6 +120,7 @@ int main(int argc, char *argv[])
>  	char *buf;
>  	/* largest possible packet payload, plus netlink data overhead: */
>  	size_t sizeof_buf = 0xffff + (MNL_SOCKET_BUFFER_SIZE/2);
> +	struct pkt_buff *pktb;
>  	struct nlmsghdr *nlh;
>  	int ret;
>  	unsigned int portid, queue_num;
> @@ -161,6 +175,12 @@ int main(int argc, char *argv[])
>  	ret = 1;
>  	mnl_socket_setsockopt(nl, NETLINK_NO_ENOBUFS, &ret, sizeof(int));
>
> +	pktb = pktb_alloc_head();

s.b. pktb_head_alloc (did this compile?)

See following patch for simplified code

> +	if (!pktb) {
> +		perror("pktb_alloc");
> +		exit(EXIT_FAILURE);
> +	}
> +
>  	for (;;) {
>  		ret = mnl_socket_recvfrom(nl, buf, sizeof_buf);
>  		if (ret == -1) {
> @@ -168,13 +188,14 @@ int main(int argc, char *argv[])
>  			exit(EXIT_FAILURE);
>  		}
>
> -		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
> +		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, pktb);
>  		if (ret < 0){
>  			perror("mnl_cb_run");
>  			exit(EXIT_FAILURE);
>  		}
>  	}
>
> +	pktb_free(pktb);
>  	mnl_socket_close(nl);
>
>  	return 0;
> --
> 2.20.1
>

Duncan Roe (1):
  example: nf-queue: use pkt_buff (updated)

 examples/nf-queue.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

-- 
2.14.5

