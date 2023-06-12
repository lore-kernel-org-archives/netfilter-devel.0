Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61054C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 09:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjFLJxp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 05:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjFLJxJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 05:53:09 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A90E46A0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 02:37:30 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-39a55e706deso1380532b6e.3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 02:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686562649; x=1689154649;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtaI7/N6HM5p1lxbE/lWr+5dBnZ6TgGapLuwnXDXk80=;
        b=avWk6nIFe+0USWMpE/dNtAKSdE9r3cyUG3oDO50lmd3pM1ENCyM1IlkCVfAOBUcHX3
         +D6hLCFaasOI7937c2FHiE1JjOLq6EbamCmC/sedmyhIyvoLHUdLhHrPgX4wjTAvTEh+
         GPcCywMbJA8nrvgrI5hUJ4z9mZXyNsU0Jq/TkaH+PLHnOtEAOC/n6/z8wWBXpqLHLWLk
         6rrBxNEatGNeNoiS7RW7P5RpSYQsYtdiWFrXt6J6vpni1NvXSmeLovWagvtTLCpKL8p9
         qPbj4kBa+JphMTJxFN3Qin32Ia4kGsIVdjtnjZT7BRjsLqnfo4Jb52YEdO5Ztk7IvgEM
         TEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686562649; x=1689154649;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xtaI7/N6HM5p1lxbE/lWr+5dBnZ6TgGapLuwnXDXk80=;
        b=Xd+H+FPQU1GRK0mPGqmmiv0fXXbHt20QaYfCmbWzmtYSChub9TlPhtFcn0gYb30gea
         Zqf+swdllvin54PS6qQzG9tH/sM08tFOqMcxETD/ZhmsYAAfSUHrAl/YbQwjPEGtaOWZ
         JQdna95Tzkkqju0MDtS8XG0azOiVC8B5u1eoB8FAbBiINCp8g6ysCXidmHxydYiKxGLg
         ITtwojHenG041g7gbx09P5mg5eQufRKdwInZI09VYkpl/R6xWf/NSIkSIUldPqUWMP5y
         IygIy1RJ3pg1+R26OrpfkaZ9g3knUSuWMvqNsXjcLaciE7V5zoUIEQOTddlgbI7muwvC
         s3/g==
X-Gm-Message-State: AC+VfDzS5NpSp990s+tBy+y6x1o2Bkah3+b/UcEu52mOFBh2MVlaAQ7l
        mn/K5eB9Q8ctni0AuWREg/qnrvcmbneAb6iML65+HU25BD8=
X-Google-Smtp-Source: ACHHUZ6+h2GDeQwU/19vQuM2/TQ6pYXvc61yL5XK4tL6+dkp9IHIRdruytMb0bNXVF56mxEoISD+gv0ZkfElnPxCo14=
X-Received: by 2002:a05:6808:1885:b0:395:eed6:5193 with SMTP id
 bi5-20020a056808188500b00395eed65193mr3959281oib.10.1686562649234; Mon, 12
 Jun 2023 02:37:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAPK07tJebGZU+c=BkY+i8YnNVcWkdmruJswh_wcrmU_+RXFYCg@mail.gmail.com>
In-Reply-To: <CAPK07tJebGZU+c=BkY+i8YnNVcWkdmruJswh_wcrmU_+RXFYCg@mail.gmail.com>
From:   stanzgy <stanzgy@gmail.com>
Date:   Mon, 12 Jun 2023 17:36:53 +0800
Message-ID: <CAPK07tLNqtKkOc+-MKcQ7z=XfTpnrYponwWgc3crueKB40hfww@mail.gmail.com>
Subject: Re: help
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

help

On Mon, Jun 12, 2023 at 5:33=E2=80=AFPM stanzgy <stanzgy@gmail.com> wrote:
>
> --
> Best regards



--=20
Best regards
