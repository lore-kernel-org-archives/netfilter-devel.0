Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95278EB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 19:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjGRTHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 15:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGRTHm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 15:07:42 -0400
X-Greylist: delayed 330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Jul 2023 12:07:37 PDT
Received: from smtp04.easynet.dev (smtp04.easynet.dev [89.38.58.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC842F4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 12:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=easynet.dev; s=mail;
        t=1689706924; bh=z6WSZRt3fSdNUmXKM/meZmv6l/LHQlDE2MqWOBHhYVo=;
        h=Date:To:From:Subject:From;
        b=rRFpdLRHQEnDMEXh9fAbFmYQrzYE9NmoZRUypnNiVZz02JrVSS48jlxZATej9FtWv
         5Ol0UsCN+eNHOZqqEd1mgTG6UnfcFR22WmFoh1pLaMSI5K2XMapXau7nGL7P0m+kur
         DSVckVH+361OE12u0hfPmNq6jsLkSNXtg43Riga0S70GnroH1uLzoqG2Hz6E7S6wAG
         FYzdUVNH1jgmKSM1bw0zAdhtuxAKujW1cinINMq4bGGY4fBIC9qyYK2EIeZYQppidp
         pDO2iZSSHEEAINreqHx2rPSq8TAWKeD3TvyZTLFJY+FU160HNgXOq5xSlx/SZc8cMz
         mEwE9ZhYwgbXQ==
Received: from [192.168.55.102] (unknown [89.38.58.13])
        (Authenticated sender: adrian@easynet.dev)
        by smtp1.easynet.dev (Postfix) with ESMTPSA id 1D385600AD
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 22:02:04 +0300 (EEST)
Message-ID: <ff54bc23-95f3-8300-c9d4-e5d74581a0e7@easynet.dev>
Date:   Tue, 18 Jul 2023 21:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Easynet <devel@easynet.dev>
Subject: libnftnl adding element to a set of type ipv4_addr or ipv6_addr
Organization: EasyNet Consulting SRL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm building a small firewall daemon that it receives if an user is 
authenticated and then is adding his IP in a set to be allowed for 24h.
I'm new in nftnl library and I started to read the documentation and 
also the examples.

Until now I was able to add in my daemon these tools based on libnftnl:

- create / delete / get tables
- create / delete chains
- create / delete sets.

Right now I'm facing an issue that I can't understand how to build the 
nftnl packet for adding an element to my set, which has interval and 
timeout flags.

The function I'm using it looks very similar to one in libnftnl, with 
modifications:

/*
* Set add element
*/
int32_t nft_set_element_add(char *req_family, char *table_name, char 
*set_name, char *element)
{
     struct mnl_socket *nl;
     char buf[MNL_SOCKET_BUFFER_SIZE];
     struct mnl_nlmsg_batch *batch;
     struct nlmsghdr *nlh;
     uint32_t portid, seq, family;
     struct nftnl_set *s;
     struct nftnl_set_elem *e;
     uint16_t data;
     uint32_t mask;
     uint32_t data32;
     uint64_t data64;
     uint64_t timeout;

     char strAddr[32];

     in_addr_t ipv4;

     int ret;

     s = nftnl_set_alloc();
     if (s == NULL) {
         perror("OOM");
         exit(EXIT_FAILURE);
     }

     seq = time(NULL);

     family = nft_check_table_family(req_family);

     nftnl_set_set_str(s, NFTNL_SET_TABLE, table_name);
     nftnl_set_set_str(s, NFTNL_SET_NAME, set_name);

     /* Add to dummy elements to set */
     e = nftnl_set_elem_alloc();
     if (e == NULL) {
         perror("OOM");
         exit(EXIT_FAILURE);
     }

     strcpy(strAddr, "192.168.10.10");

     ipv4 = inet_addr(strAddr);
     printf("IPv4: %u\n", ipv4);
     //timeout = 3600;

     nftnl_set_elem_set(e, NFTNL_SET_ELEM_KEY, &ipv4, sizeof(ipv4));
     //nftnl_set_elem_set(e, NFTNL_SET_ELEM_TIMEOUT, &timeout , 
sizeof(timeout));
     nftnl_set_elem_add(s, e);

     batch = mnl_nlmsg_batch_start(buf, sizeof(buf));

     nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
     mnl_nlmsg_batch_next(batch);

     nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
                     NFT_MSG_NEWSETELEM, family,
                     NLM_F_CREATE | NLM_F_EXCL | NLM_F_ACK,
                     seq++);
     nftnl_set_elems_nlmsg_build_payload(nlh, s);
     nftnl_set_free(s);
     mnl_nlmsg_batch_next(batch);

     nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
     mnl_nlmsg_batch_next(batch);

     nl = mnl_socket_open(NETLINK_NETFILTER);
     if (nl == NULL) {
         perror("mnl_socket_open");
         exit(EXIT_FAILURE);
     }

     if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
         perror("mnl_socket_bind");
         exit(EXIT_FAILURE);
     }
     portid = mnl_socket_get_portid(nl);

     if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
                   mnl_nlmsg_batch_size(batch)) < 0) {
         perror("mnl_socket_send");
         return(EXIT_FAILURE);
     }

     mnl_nlmsg_batch_stop(batch);

     ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
     while (ret > 0) {
         ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
         if (ret <= 0)
             break;
         ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
     }
     if (ret == -1) {
         perror("error");
         return EXIT_FAILURE;
     }
     mnl_socket_close(nl);

     return EXIT_SUCCESS;
}

I was able to add timeout flag for the IP, but the IP is added as a range:

         set IPTVv4_ALLOW {
                 type ipv4_addr
                 flags interval,timeout
                 elements = { 192.168.10.10-255.255.255.255 }
         }


I couldn't find too much information in the documentation or looking 
into the nftables code or Linux Kernel. For me are too complicated to 
understand the logic behind.
Can somebody advice me how can I implement the nflnl message correctly 
to be able to add just the host for example? Or where I can find the 
info about how nftnl message should be created?

Kind regards.

