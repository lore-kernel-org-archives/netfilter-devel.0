Return-Path: <SRS0=zuan=AH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E85C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jun 2020 10:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE652070A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jun 2020 10:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zLO3QwSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFZKWw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Jun 2020 06:22:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgFZKWw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jun 2020 06:22:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05QALxDf014730;
        Fri, 26 Jun 2020 10:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=riXch1ZuAQX/FCpzFaBBF7seYp2RjnFD68L9r5LdNXU=;
 b=zLO3QwSoP9boMb0wCy1aaEAm7eUUl3PTOVbGPE9v3CbGdeQKU1sBCljUSQ+jzG5wr8zO
 24T4T5eBA44Y0OGLJR4tdFBOvTF2TISL5of7zqC6OscqSTgFspDrcmzT8aI4vElzfJSV
 n1VL+nLpgSD1kIN6PZfqHJHv1WPnCrcuL9X0+f0r7uXndyyVrP8DT6oJXbI7gh20Q/8+
 QMEqiLQ32z2149OUq/7zIZHOpDK13P9wetaEsn36wpaHsijqJxbVUU9GTV88eeX7srmx
 E5kckXaNCXw+4m6jZW13K1O432LUO/RKJ/xbXrOdXlR/EARSSRB8x/6PBw0BSgRQA+R7 BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31uustwau3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 10:22:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05QAEJXE192332;
        Fri, 26 Jun 2020 10:22:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uuraf93g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jun 2020 10:22:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05QAMmDm024888;
        Fri, 26 Jun 2020 10:22:48 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Jun 2020 10:22:47 +0000
Date:   Fri, 26 Jun 2020 13:22:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     rgb@redhat.com
Cc:     netfilter-devel@vger.kernel.org
Subject: [bug report] audit: log nftables configuration change events
Message-ID: <20200626102242.GA313925@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=3 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260075
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Richard Guy Briggs,

The patch 8e6cf365e1d5: "audit: log nftables configuration change
events" from Jun 4, 2020, leads to the following static checker
warning:

	net/netfilter/nf_tables_api.c:6160 nft_obj_notify()
	warn: use 'gfp' here instead of GFP_XXX?

net/netfilter/nf_tables_api.c
  6153  void nft_obj_notify(struct net *net, const struct nft_table *table,
  6154                      struct nft_object *obj, u32 portid, u32 seq, int event,
  6155                      int family, int report, gfp_t gfp)
                                                    ^^^^^^^^^
  6156  {
  6157          struct sk_buff *skb;
  6158          int err;
  6159          char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
                                      ^^^^^^^^^^
This should probably be "gfp".

  6160                                table->name, table->handle);
  6161  
  6162          audit_log_nfcfg(buf,
  6163                          family,
  6164                          obj->handle,
  6165                          event == NFT_MSG_NEWOBJ ?
  6166                                  AUDIT_NFT_OP_OBJ_REGISTER :
  6167                                  AUDIT_NFT_OP_OBJ_UNREGISTER);
  6168          kfree(buf);
  6169  
  6170          if (!report &&
  6171              !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
  6172                  return;
  6173  
  6174          skb = nlmsg_new(NLMSG_GOODSIZE, gfp);
                                                ^^^

  6175          if (skb == NULL)
  6176                  goto err;
  6177  
  6178          err = nf_tables_fill_obj_info(skb, net, portid, seq, event, 0, family,
  6179                                        table, obj, false);
  6180          if (err < 0) {
  6181                  kfree_skb(skb);
  6182                  goto err;
  6183          }
  6184  
  6185          nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
  6186          return;
  6187  err:
  6188          nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
  6189  }

regards,
dan carpenter
