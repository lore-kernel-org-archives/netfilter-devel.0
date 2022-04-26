Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D79C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 13:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346973AbiDZNM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 09:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350669AbiDZNM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 09:12:56 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 06:09:44 PDT
Received: from libero.it (smtp-16-i2.italiaonline.it [213.209.12.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7F257B15
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 06:09:44 -0700 (PDT)
Received: from oxapps-32-139.iol.local ([10.101.8.185])
        by smtp-16.iol.local with ESMTPA
        id jKvnnbYozxXfVjKvnnHQVJ; Tue, 26 Apr 2022 15:08:39 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1650978519; bh=LnfUkAF2RXpLq0vLEyGro/2t+ZCWvaTiEFpHiiWUgGo=;
        h=From;
        b=CNdzjz1t4Muou49iKzMUDS1b2PYI06Ww9KBnC4TUDJa7dWNAyP97QOmDhoCQAGHLU
         lstCQF3b2zfVYjTgVKqKerPhfbOqr63TK1ofI06qGC4AG7emIWKgdQHq4pMpl4J3gM
         tWoWyLB8Hvd723B6Wh8Z5/UsZABZIv7FbJr2yv9tazMwMPVgtLPHPmg5ajzlERPiSs
         vfapxlwuEojheFNPBjHNyMsHDcS/ka1CquICvtqhIdxo2usXPuWh+fl975RoFMQnsc
         cw3GuBj9VP/XGcvJ8Z9v1fvgAN5gmU3rTOJjM9get7auMoXYtTfAHbf5ODnLSbIfFF
         B3UuVqNp04BbQ==
X-CNFS-Analysis: v=2.4 cv=XoI/hXJ9 c=1 sm=1 tr=0 ts=6267eed7 cx=a_exe
 a=95DrdsVzeyCVcycVxCHoRw==:117 a=TjoVofBiY4gA:10 a=IkcTkHD0fZMA:10
 a=PiMdsTonhmIA:10 a=3HDBlxybAAAA:8 a=2Zf4G7EUPoeRlIgEYTMA:9 a=QEXdDO2ut3YA:10
 a=laEoCiVfU_Unz3mSdgXN:22
Date:   Tue, 26 Apr 2022 15:08:39 +0200 (CEST)
From:   Dario Binacchi <dariobin@libero.it>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Message-ID: <1046776651.940442.1650978519019@mail1.libero.it>
In-Reply-To: <YmfsWQ++9p5PdeGp@salvia>
References: <20220425160513.5343-1-dariobin@libero.it>
 <YmfsWQ++9p5PdeGp@salvia>
Subject: Re: [PATCH 1/1] configure: add an option to compile the examples
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev39
X-Originating-IP: 87.0.15.73
X-Originating-Client: open-xchange-appsuite
x-libjamsun: fBH18Zlb/lHFgkyixc+ofAxzuJtr5tl5
x-libjamv: hYVbSyt7CC8=
X-CMAE-Envelope: MS4xfJg8pwlZhIEmWRVonKBEjwAmzhhe1rLNIiSi8/8AYF2xQ8ehOlh0U+Vjt9xfEV86TgnHDddZHeDlbtkKoqe93pUpKREGQZ31gOrOUHxpnqKIr+ZMu7wF
 fLKNUWAHK6OMs6mECv7sISrOf/DkWTvhyDy3QMjQ0hlPTJnVEo5fvvDlG8Fa8d2nTbgYasbKaVaVe8ZNpJEnazk9M8dEoGqcAyB/sYBVS3mt3I9KBNvjblap
 5kMEj9zngjFdIxqp88l4eg==
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


> Il 26/04/2022 14:58 Pablo Neira Ayuso <pablo@netfilter.org> ha scritto:
> 
>  
> On Mon, Apr 25, 2022 at 06:05:13PM +0200, Dario Binacchi wrote:
> > Using a configure option to compile the examples is a more common
> > practice. This can also increase library usage (e.g. buildroot would
> > now be able to install such applications on the created rootfs).
> 
> From context, I assume this is for libmnl
Yes, libmnl

> 
> If you run `make' it does not compile the examples.

yes, as before the patch. 
To compile the examples you need to run `./configure --enable-examples && make'
instead of `make check'.

Thanks and regards,
Dario
