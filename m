Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61728C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 02:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DCA420675
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 02:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T8qNJffR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfCFCYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 21:24:36 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:36124 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfCFCYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 21:24:36 -0500
Received: by mail-ot1-f45.google.com with SMTP id v62so9372732otb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2019 18:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hJJcFPlxVH3ySQuQdXh4fahyCMeO39RLqRQvnBIas3Q=;
        b=T8qNJffRRJhcU409TbdfT2f1/S6IGEyy3IgGwgA7WjiDHcOaYAP5UE3g4p5HAQwtM+
         PEWYX3nkHEE47C0wmwyDhRnPmAiPgRMe1PphbV3w2zp/aOGQh7T1uwIz6G5k02B6cWrX
         QM6xyQ++O2krnpfLcCjWVpNgePtBCnjiuAL4n2R6EIbX4Y0E6ot2+w5zH5AUTMIwQZdU
         uo/NVJBQg1A5IoTJ88Bqk455wldOhhkm1EoGwQMWXo4T1gWBv7czyLp+TI6N1sF1Uy57
         4SFjE5czJE3dU+UXI2UtoNWj4bZQqGNPsdsErvaPXKB6OSi2vDUcTO7NRsUd5c3wSr3i
         tAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hJJcFPlxVH3ySQuQdXh4fahyCMeO39RLqRQvnBIas3Q=;
        b=T7Wxwr/18Mi7iTUmD/A418Rr3CsdDeR5pC99/qtKdUskqfertiFSAodfnBnh+SXOWA
         t2v41JfnLFEcxTm6raqgD+LFiI7Hm7cPUtsZVW09hWSqAfgjW97d6qMRpq+RLaBPWuPX
         W9UGpv/n3WM8BXPYnqPxE3vcLxjjyI9k0Zt2y1oWVXpkqVDLkLCeiaV6N1S4dO2GozrS
         REhy4lEnWtQDhQhv/IVMksbI0rzBUQzoDJVjVc1bPxjlHeaf6lK5jQyPIbvm0k1WksIm
         HCXL6kVa0LSMZQLK1xA2g9x2gNc8ogvR43VooTiWYXh0hMY+odecCZ+BKCo0XKMBCwlP
         rijQ==
X-Gm-Message-State: APjAAAVdDZQfnCbWnOsQlIJEgC1ux59Z6UBIDcZoRk6SL4vkTrCd/a9S
        wTHJiiZ6PsKIrhDrNXnrbRaFYh8XtLUvJrCpT6YZpX8=
X-Google-Smtp-Source: APXvYqzHoP2p/ZV2CKH/3rcxSdBMR4KeSHG4XNDxb8qf0bl/MY4SsdskFBZYQAktY3n2yRr4uMnIRLksG5UB+9WBARA=
X-Received: by 2002:a9d:6553:: with SMTP id q19mr2837239otl.21.1551839075080;
 Tue, 05 Mar 2019 18:24:35 -0800 (PST)
MIME-Version: 1.0
From:   satya phanisree <phanisree1998@gmail.com>
Date:   Wed, 6 Mar 2019 07:54:21 +0530
Message-ID: <CAJv4CxY1NHej0ohcQhnqcwBRgvFnXo82=Q=gnhZqAtu01SS_kQ@mail.gmail.com>
Subject: Netfilter
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi ,

    We are looking at trying to retrieve the complete conntrack table
using libnetfilter_conntrack API's. But when we used the below
sequence of API's we see that the call back register is getting called
once for every entery in the conntrack table. The sequence of API's we
have used is as follows :



cb
..........
..........
    nfct_snprintf ();<=====returns one entry from conntrack table
..........
..........


main

        nfct_callback_register ( ); <===== NFCT_T_ALL to fetch all the enteries
        ret = nfct_query ();
........
........



Is there a away for me to get the whole conntrack table in a single
invocation of single callback function ? So that the cb function not
called multiple times?


Thanks and Regards,
