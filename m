Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF97BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLVXXG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 18:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLVXXF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 18:23:05 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2568A6275;
        Thu, 22 Dec 2022 15:23:05 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id d14so4955649edj.11;
        Thu, 22 Dec 2022 15:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s+xWxUTgn6w8vQ0J6vyX2GHOWyGLyVKHrPrQZJaoicc=;
        b=eV5qB+px6/W3VKj+9+e8NKpP8cF1/d+EEyYA9+rOJCAG8Id968JjnBBL9ogBW0U5pF
         UGHpblel2zDcvnesOkFd5yIx4saoWFm1d/L1xIDPeCCMxo0bohl1FSt4UsQGY28SPIJl
         uPuTF+zMfolSJcHprsTF97AMrTeVyu7jMldwiE3krMK2IN8LKNMzsP66BQ3U7cgpM3/h
         CEtvxaNtSwCb1XuZsUqyBIv4Rs3lmuTnlRbwkDFC/ZXpG8fqSP721WziXnqMYGecFdb0
         rW5QgZDgZ9hS6tV3GLhgrcLy+UDs8bpV+dqxiDR0wfgmPg893J0PemRmrfuRDq1i7CA0
         LNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s+xWxUTgn6w8vQ0J6vyX2GHOWyGLyVKHrPrQZJaoicc=;
        b=2FrJKVQtv7AgVoJSPgtdpLKDsQyCIN3t67gFlRKkxtoCS757apO/gosCl9NTMI8FQS
         LiYIfNA0+95TsCmzVLdd6x9T/DhLDftFNfAXgSaiaPSrldNiEbW2aLnm5XBw3FYVRK4Y
         JWqh7QMuYeDMZ0NJEI7JjZo+5RR6VDqvQSb3iYoAt8oB5kOaufwoYyMdOEe4jg+/6T9i
         Z1kJG5oJv7L5yZh0mjYo+MjOdSKAvekTSXcK5qfYDdiLXmC2qGYy0PqrcfkkSlAl7Zfl
         1kBxUmSW25tZ9PDm2651MMMpO+Guc3UafqQ/cIenlimiG8zk8vb5z8e589t7BqkfFxJS
         6Few==
X-Gm-Message-State: AFqh2krlZFpJCyJTg8l8Gq5Vbv6hdmd5TtfHR3L6Uj7j8lDqT2tzTUY8
        pTPXOqVOdiiGIpeJvhpZQTROYDvChBQuc+S3Mp8DBN2QLkM=
X-Google-Smtp-Source: AMrXdXsfA6Om9waNFz8l6mUiM18gNQnHcSRID/1qNIuAFfyOFCQPlA9plakrjwrqr0Q+fjPSBvu03gesw5KUJS/pDGs=
X-Received: by 2002:aa7:dd41:0:b0:46f:a73d:6bd7 with SMTP id
 o1-20020aa7dd41000000b0046fa73d6bd7mr750542edw.93.1671751383488; Thu, 22 Dec
 2022 15:23:03 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
Date:   Fri, 23 Dec 2022 02:22:52 +0300
Message-ID: <CAEmTpZFTQVDYw4w2LgTmABZ8ygJtwtLj+Kj9CsZmNARpuB2oHQ@mail.gmail.com>
Subject: ipset bug (kernel hang)
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kadlecsik.jozsef@wigner.hu, kadlec@sunserv.kfki.hu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ipset create acl_cdc_cert hash:net,port,net
ipset add acl_cdc_cert 0.0.0.0/0,tcp:1-2,192.168.230.128/25

and kernel 6.0.12 hangs (!)

Seems the problem happens only if both 0.0.0.0/0 and port range
specified at the same time.

Please tell me where to report.

-- 
Segmentation fault
