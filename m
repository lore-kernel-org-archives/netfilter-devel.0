Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AECC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 14:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255B8206BA
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 14:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OMw3FzS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfCDO57 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:57:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39870 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfCDO57 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 09:57:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x24Emu8k064531;
        Mon, 4 Mar 2019 14:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=UW8ADiLCjcx+vQfROyGJLDUkGWWNJoQLBCbbbCoB9ws=;
 b=OMw3FzS7Y1rapg6R2x14Kd9XMxbn/MdUJbcY0FPTmnrhE46Ro92nvszIvPO0MEBdPwZT
 7IMXLsiTpoNTg6fiahi0UGsSobEsn39+AE+VQmW/GUBYO1JENROskLPzXKvXsds+p+BL
 gqwpr8QE4b89M72AdHu+me9CBUchojBfrC/TmXctWkHb1XjdvKxztwk5QSHKsVbE+P2n
 OasJyiNMB4+mfCfS0uneUhlJtQnoct+3hH+xYVsPA5SS4Uva3vUagVhWzBTvXih7PHS/
 MDMgJSxn7taGk3YDGBKGaX19FmauRQ/1kqAiIji4bpqMeWUZY1T/2RgY0MaF4vh2CvB6 Lw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qyfbdyjf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Mar 2019 14:57:51 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x24EvpLA018777
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Mar 2019 14:57:51 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x24EvopJ022743;
        Mon, 4 Mar 2019 14:57:50 GMT
Received: from kadam (/197.157.34.180)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Mar 2019 06:57:48 -0800
Date:   Mon, 4 Mar 2019 17:57:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Karuna Grewal <karunagrewal98@gmail.com>
Cc:     kbuild-all@01.org, pablo@netfilter.org, arturo@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for
 NFT_META_TSTAMP_NS
Message-ID: <20190304145741.GB13452@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301092401.GA17755@nebula>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9184 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903040109
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Karuna,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Karuna-Grewal/netfilter-nft_meta-Extend-support-for-NFT_META_TSTAMP_NS/20190301-182752
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

smatch warnings:
net/netfilter/nft_meta.c:261 nft_meta_get_eval() warn: right shifting more than type allows 32 vs 32

# https://github.com/0day-ci/linux/commit/02c5bd91b2cb1485eeb226b93c885aaa3f7a2a39
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 02c5bd91b2cb1485eeb226b93c885aaa3f7a2a39
vim +261 net/netfilter/nft_meta.c

0fb4d2195 wenxu             2019-01-16  247  	case NFT_META_IIFKIND:
0fb4d2195 wenxu             2019-01-16  248  		if (in == NULL || in->rtnl_link_ops == NULL)
0fb4d2195 wenxu             2019-01-16  249  			goto err;
0fb4d2195 wenxu             2019-01-16  250  		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
0fb4d2195 wenxu             2019-01-16  251  		break;
0fb4d2195 wenxu             2019-01-16  252  	case NFT_META_OIFKIND:
0fb4d2195 wenxu             2019-01-16  253  		if (out == NULL || out->rtnl_link_ops == NULL)
0fb4d2195 wenxu             2019-01-16  254  			goto err;
0fb4d2195 wenxu             2019-01-16  255  		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
0fb4d2195 wenxu             2019-01-16  256  		break;
02c5bd91b Karuna Grewal     2019-03-01  257  	case NFT_META_TSTAMP_NS:
02c5bd91b Karuna Grewal     2019-03-01  258  		if (skb->tstamp == 0)
02c5bd91b Karuna Grewal     2019-03-01  259  			__net_timestamp((struct sk_buff *)skb);
02c5bd91b Karuna Grewal     2019-03-01  260  		u64 timestamp = ktime_to_ns(skb->tstamp);
02c5bd91b Karuna Grewal     2019-03-01 @261  		*dest = (u32) timestamp >> 32;
                                                                ^^^^^^^^^^^^^^^
Missing parentheses.  Generally, kernel style is to not put a space
after a cast, because casting is a high precedence operation.

02c5bd91b Karuna Grewal     2019-03-01  262  		*(dest + 1) = (u32) timestamp;
02c5bd91b Karuna Grewal     2019-03-01  263  		break;
96518518c Patrick McHardy   2013-10-14  264  	default:
96518518c Patrick McHardy   2013-10-14  265  		WARN_ON(1);
96518518c Patrick McHardy   2013-10-14  266  		goto err;
96518518c Patrick McHardy   2013-10-14  267  	}
96518518c Patrick McHardy   2013-10-14  268  	return;
96518518c Patrick McHardy   2013-10-14  269  
96518518c Patrick McHardy   2013-10-14  270  err:
a55e22e92 Patrick McHardy   2015-04-11  271  	regs->verdict.code = NFT_BREAK;
96518518c Patrick McHardy   2013-10-14  272  }
96518518c Patrick McHardy   2013-10-14  273  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
