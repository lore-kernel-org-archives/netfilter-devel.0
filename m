Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC2BC28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiHVUwH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiHVUwF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 16:52:05 -0400
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC9A51A15
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 13:52:04 -0700 (PDT)
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
        by mx0a-00364e01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MKnod2016641
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 16:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=jRzEf5ldVyXOJMmmR5MBzxUV26GRIKHAGatrWR5Rps8=;
 b=TWu/QEbE1HeBkKyLpa5scMc7WE2tJR1nLopzpBRWSxT7GSVj4FPK9eTXj6fY5M0XIjQ6
 dOrGI2nEh6jCefxuoRn7v0kdDi3+ixwePxLkCaNzmsT99mBz92O6OU9lBIiqrRy3H15i
 bXNTh5wkWwONDxjRyYgnkC6kyGEDYrKy6BcKG52cAugYes7MaaR/WwtTjWOhK4u38sRt
 tT0K3BuZCkLCdn8jo9XA3tzyX8YvsCV8sRwkdEt0GCLhd8i1WololVMAJ5nMm77qj0Rv
 HywQVWfIWFDnXA0GilDTMCKcvA2LfP67kKUtVmF1Oc+dGYXN0UG8Q5qOQAZxLfa3bCw9 cQ== 
Received: from sendprdmail21.cc.columbia.edu (sendprdmail21.cc.columbia.edu [128.59.72.23])
        by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 3j4fkvgr7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 16:52:04 -0400
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
        by sendprdmail21.cc.columbia.edu (8.14.7/8.14.4) with ESMTP id 27MKpxKK011791
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 16:52:03 -0400
Received: by mail-ua1-f70.google.com with SMTP id y47-20020a9f3272000000b003874d9b010aso2506025uad.6
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 13:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=jRzEf5ldVyXOJMmmR5MBzxUV26GRIKHAGatrWR5Rps8=;
        b=pNcSKONkWaCZY0DwCHYZpWtE6Fm8upEgr3UzzQRAC7ANZDVEnqb8iI9nUCAal+NCQU
         qswqZl7VcLGAyVZxYHcHhB7SyyuPjYVW/3yKQNzf3abJaNBr6JecHhlTZh70WkDY6dZo
         jPvcNrGLqtwo9p2kmI8vRfaSNTMkDdONXpysh3yKISbcVCAqSiv8UM7klskbGZBEgRCU
         GOvDrcbNXGuGLha/Bamvdub2WrIgz66XQ/LAHbhTDhV4EYB5N7Ta7GaWbjI+K1Mw1p47
         x9OGFgcPEfhje52iSGwkmSj61XeUg6UIqBHE3TyQCeNJjqDgtK9TMlu3nj6Fp4gCsmHK
         9J9w==
X-Gm-Message-State: ACgBeo3ZGx3pYV5TTX1okRLCZ/dk1wWRM0WKVqnlulBFCOa7dJXXU8y6
        1XEtDQW8ZzbhGkdPYqi7hog6ycHAXVJaiFsbcCFEiqx2czu94VjcLlwUTZTBvFU8wpwXqyHOPzR
        SsiwEVso1eN0dOfqLpcJEz6f/4KqfQfwhC2xHKHCkw8kP8aTP+6NE
X-Received: by 2002:a67:d284:0:b0:390:3f27:a274 with SMTP id z4-20020a67d284000000b003903f27a274mr4411365vsi.12.1661201522906;
        Mon, 22 Aug 2022 13:52:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5tcmijsMj/vgPupQntehD8NN8viBte3C+4jiOzfZwp48FzNQTAjr1Gcl87ULNyUQ2RcEcIAH8sPVJ7ErsYTc0=
X-Received: by 2002:a67:d284:0:b0:390:3f27:a274 with SMTP id
 z4-20020a67d284000000b003903f27a274mr4411355vsi.12.1661201522713; Mon, 22 Aug
 2022 13:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAEHB2488dNqBKcgWLSeq500JLC1+q6RV=ENcUPm=rN9bWf0QkQ@mail.gmail.com>
 <20220819123542.GA2461@breakpoint.cc> <CALbthtdzW-_4TVngjt-VjCS6GqCEP967-UE7oEoDkBAVaRFOzw@mail.gmail.com>
 <20220822204112.GA19050@breakpoint.cc>
In-Reply-To: <20220822204112.GA19050@breakpoint.cc>
From:   Gabriel Ryan <gabe@cs.columbia.edu>
Date:   Mon, 22 Aug 2022 16:51:55 -0400
Message-ID: <CALbthteTSmd9xmBUdBSRzFNMqFemxnba=SnvNgY5KrLYEvpMhQ@mail.gmail.com>
Subject: Re: data-race in nf_tables_newtable / nf_tables_newtable
To:     Florian Westphal <fw@strlen.de>
Cc:     Abhishek Shah <abhishek.shah@columbia.edu>, coreteam@netfilter.org,
        davem@davemloft.net, edumazet@google.com, kadlec@netfilter.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: HNoadaxO7Aa9cTnrdieGr_oUtYmOJvZW
X-Proofpoint-ORIG-GUID: HNoadaxO7Aa9cTnrdieGr_oUtYmOJvZW
X-CU-OB: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_13,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=10 suspectscore=0 clxscore=1015 adultscore=0 bulkscore=10
 impostorscore=10 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=877
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208220084
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ok, glad everything worked out then, thanks for sharing!

Best,

Gabe

On Mon, Aug 22, 2022 at 4:42 PM Florian Westphal <fw@strlen.de> wrote:
>
> Gabriel Ryan <gabe@cs.columbia.edu> wrote:
> > Hi Florian,
> >
> > I just looked at the lock event trace from our report and it looks
> > like two distinct commit mutexes were held when the race was
> > triggered. I think the race is probably on the table_handle variable
> > on net/netfilter/nf_tables_api.c:1221, and not the table->handle field
> > being written to.
>
> See
>
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__patchwork.ozlabs.o=
rg_project_netfilter-2Ddevel_patch_20220821085939.571378-2D1-2Dpablo-40netf=
ilter.org_&d=3DDwIFAg&c=3D009klHSCxuh5AI1vNQzSO0KGjl4nbi2Q0M1QLJX9BeE&r=3DE=
yAJYRJu01oaAhhVVY3o8zKgZvacDAXd_PNRtaqACCo&m=3DtKybb4B0md9Rrb5d9AH-UN2fjr4L=
8y6LtRxywepWhKsWCyN0OWaRwAtDbGt10WQD&s=3DuJ4BtOvCcZOe6F17rDKQipDF0McLeOwaUL=
9jO3BgTCU&e=3D
>
> which makes table_handle per netns.
