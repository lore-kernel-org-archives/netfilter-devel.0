From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: size calculation wasted cpu time
Date: Mon, 16 Mar 2009 16:02:16 +0300
Message-ID: <152544048.20090316160216@yandex.ru>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards3.yandex.ru ([213.180.223.174]:50043 "EHLO
	forwards3.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZCPNBi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:01:38 -0400
Received: from smtp11.yandex.ru (smtp11.yandex.ru [213.180.223.93])
	by forwards3.yandex.ru (Yandex) with ESMTP id 71D0D4C5BED
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2009 16:01:32 +0300 (MSK)
Received: from gw-212.mjknet.ru ([212.45.5.114]:54794 "EHLO www1.firststeps.ru"
        smtp-auth: "kuzinandrey" TLS-CIPHER: <none> TLS-PEER-CN1: <none>)
        by mail.yandex.ru with ESMTP id S5095608AbZCPNBV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Mar 2009 16:01:21 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In /net/netfilter/nfnetlink_queue.c every call of nfqnl_build_packet_message()
make series of call nla_total_size() for 'size' calculations.
I think 'size' is constant value for kernel build and may be define static
variable for this ?

Thank you.

static struct sk_buff *
nfqnl_build_packet_message(struct nfqnl_instance *queue,
                           struct nf_queue_entry *entry)
{
        sk_buff_data_t old_tail;
        size_t size;
        size_t data_len = 0;
        struct sk_buff *skb;
        struct nfqnl_msg_packet_hdr pmsg;
        struct nlmsghdr *nlh;
        struct nfgenmsg *nfmsg;
        struct sk_buff *entskb = entry->skb;
        struct net_device *indev;
        struct net_device *outdev;

        size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
                + nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
                + nla_total_size(sizeof(u_int32_t))     /* ifindex */
                + nla_total_size(sizeof(u_int32_t))     /* ifindex */
#ifdef CONFIG_BRIDGE_NETFILTER
                + nla_total_size(sizeof(u_int32_t))     /* ifindex */
                + nla_total_size(sizeof(u_int32_t))     /* ifindex */
#endif
                + nla_total_size(sizeof(u_int32_t))     /* mark */
                + nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
                + nla_total_size(sizeof(struct nfqnl_msg_packet_timestamp));



