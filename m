Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A235C10DCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 09:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E35120674
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 09:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qHy7g1bj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgCRJpn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 05:45:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39682 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgCRJpn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 05:45:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02I9dv0G045908;
        Wed, 18 Mar 2020 09:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=DPaJj+Kw//j+LXxwbYV5J7S+pbT4g6NsUS0Fl9ib020=;
 b=qHy7g1bjlf6UHC95CztIw/PNo9+S8DqxVu2Xz+9v5LPC6zv+NzRqAigbRc72dUpaICHa
 J5wjOf24alHrbVf2TRI90y/qJfbtIp20jO5XMneMFvTe8vyB1G4zvpv+9djafyA6HdCL
 I04aui+vMJkovQbSqlROyKy+mC5c00Iu9+dKqCJZ2zKB/XWM0FOJIepfdSNsSB3EbDAg
 Qo2MHDLENhqyC1PPoMigs992QMVU5osDYfebx9gRia61SoJvuh1PUc8w1DlmkrknlYX2
 CbOXg0q+YCRcNy0Q+hu/vvbp/qBJvXCml3UhNIkWGQ038FRsVizWfYUsneYQn8xmJoZy 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yub271es2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 09:45:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02I9LasN141579;
        Wed, 18 Mar 2020 09:45:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ys92fu82n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 09:45:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02I9jbV8019667;
        Wed, 18 Mar 2020 09:45:37 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 02:45:36 -0700
Date:   Wed, 18 Mar 2020 12:45:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [bug report] netfilter: nf_tables: add elements with stateful
 expressions
Message-ID: <20200318094531.GA4421@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=732
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=3
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=805 mlxscore=0 phishscore=0 adultscore=0 suspectscore=3
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180048
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo Neira Ayuso,

The patch 409444522976: "netfilter: nf_tables: add elements with
stateful expressions" from Mar 11, 2020, leads to the following
static checker warning:

	net/netfilter/nf_tables_api.c:5140 nft_add_set_elem()
	warn: passing freed memory 'expr'

net/netfilter/nf_tables_api.c
  5067          ext = nft_set_elem_ext(set, elem.priv);
  5068          if (flags)
  5069                  *nft_set_ext_flags(ext) = flags;
  5070          if (ulen > 0) {
  5071                  udata = nft_set_ext_userdata(ext);
  5072                  udata->len = ulen - 1;
  5073                  nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
  5074          }
  5075          if (obj) {
  5076                  *nft_set_ext_obj(ext) = obj;
  5077                  obj->use++;
  5078          }
  5079          if (expr) {
  5080                  memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
  5081                  kfree(expr);
                              ^^^^
Freed here

  5082          }
  5083  
  5084          trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
  5085          if (trans == NULL)
  5086                  goto err_trans;
  5087  
  5088          ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
  5089          err = set->ops->insert(ctx->net, set, &elem, &ext2);
  5090          if (err) {
  5091                  if (err == -EEXIST) {
  5092                          if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
  5093                              nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
  5094                              nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
  5095                              nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
  5096                                  err = -EBUSY;
  5097                                  goto err_element_clash;
  5098                          }
  5099                          if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
  5100                               nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
  5101                               memcmp(nft_set_ext_data(ext),
  5102                                      nft_set_ext_data(ext2), set->dlen) != 0) ||
  5103                              (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
  5104                               nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
  5105                               *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
  5106                                  err = -EBUSY;
  5107                          else if (!(nlmsg_flags & NLM_F_EXCL))
  5108                                  err = 0;
  5109                  }
  5110                  goto err_element_clash;
  5111          }
  5112  
  5113          if (set->size &&
  5114              !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
  5115                  err = -ENFILE;
  5116                  goto err_set_full;
  5117          }
  5118  
  5119          nft_trans_elem(trans) = elem;
  5120          list_add_tail(&trans->list, &ctx->net->nft.commit_list);
  5121          return 0;
  5122  
  5123  err_set_full:
  5124          set->ops->remove(ctx->net, set, &elem);
  5125  err_element_clash:
  5126          kfree(trans);
  5127  err_trans:
  5128          if (obj)
  5129                  obj->use--;
  5130          kfree(elem.priv);
  5131  err_parse_data:
  5132          if (nla[NFTA_SET_ELEM_DATA] != NULL)
  5133                  nft_data_release(&data, desc.type);
  5134  err_parse_key_end:
  5135          nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
  5136  err_parse_key:
  5137          nft_data_release(&elem.key.val, NFT_DATA_VALUE);
  5138  err_set_elem_expr:
  5139          if (expr != NULL)
  5140                  nft_expr_destroy(ctx, expr);
                                              ^^^^

Freed again

  5141  
  5142          return err;
  5143  }

regards,
dan carpenter
