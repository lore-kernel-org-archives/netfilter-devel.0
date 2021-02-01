Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B825BC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 10:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6089464E94
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 10:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhBAKts (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 05:49:48 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39746 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhBAKtq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 05:49:46 -0500
Received: by mail-wr1-f48.google.com with SMTP id a1so16052416wrq.6
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Feb 2021 02:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P28sGIC6/IGQ1WtgSCh2q8jWo7HSM8OsU8a8un06ISE=;
        b=YFajan8+1OZ5rPTs1pwZG4Jv1gjqJU/Zz9BRX/yIJ5gjDiOpnqIk1wrg7hXo6sdOlK
         qz8gcY73YhYgf+j1YLyy80rCKjYQRXqDTN8w5GrHLBFbs2iMexyMfHQ4GEDJp8n24Ok0
         fKhCL3HEAwOE4RNMp00712uxF1TZJkpmdjToTqtL0QLzDB1lIZ33RHpLc1g1r5tlreBV
         nEyxC9J8q0czTnfCoWR6ql+OWHKyAhJkS0Lu6y7OEg9S8dcV0Iiw/BY+V8pGI4/VevtI
         h6RzOazHpU5xnZFq0HbEowEyTuW7IRZwl2ZjlLzjYfq6eNYp7449nHU8wImBn+cao//o
         QyBg==
X-Gm-Message-State: AOAM530ByfwtewAoNG70gTv8iholvEmHYFPXq9kmmKMQwkpn1Is4URxm
        x2uJ/UdHm691zzrmPY2l+73xDNZLVeM=
X-Google-Smtp-Source: ABdhPJwH5hy1B6+R1DhPn4DpCCu22rcZEKHyn9SK7PalVvB8s2dL0svtw3gdlluHpB/2OL5VEjEivw==
X-Received: by 2002:adf:f28b:: with SMTP id k11mr17373439wro.418.1612176543940;
        Mon, 01 Feb 2021 02:49:03 -0800 (PST)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id e16sm26583692wrp.24.2021.02.01.02.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 02:49:03 -0800 (PST)
Subject: Re: [conntrack-tools PATCH 1/3] tests: introduce new python-based
 framework for running tests
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <161144773322.52227.18304556638755743629.stgit@endurance>
 <20210201033147.GA20941@salvia>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <949b08b1-d7c7-c040-7218-9df63562c032@netfilter.org>
Date:   Mon, 1 Feb 2021 11:49:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201033147.GA20941@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2/1/21 4:31 AM, Pablo Neira Ayuso wrote:
> 
> A few nitpick requests and one suggestion:
> 
> * Rename cttools-testing-framework.py to conntrackd-tests.py

Done.

> * Move it to the tests/conntrackd/ folder

Done.


> * Missing yaml dependency in python in my test machine
> 
> Traceback (most recent call last):
>    File "cttools-testing-framework.py", line 36, in <module>
>      import yaml
> ModuleNotFoundError: No module named 'yaml'
> 
> this is installed from pip, right? Just a note in the commit message
> is fine.

It was already present in the commit message.

I made it more clear:

=== 8< ===
On Debian machines, it requires the *python3-yaml* package to be installed as a 
dependency
=== 8< ===

> 
> * Would it be possible to define the scenario in shell script files?
>    For example, to define the "simple_stats" scenario, the YAML file
>    looks like this:
> 
> - name: simple_stats
> - script: shell/simple_stats.sh
> 
> The shell script takes "start" or "stop" as $1 to set up the scenario.
> For developing more test, having the separated shell script might be
> convenient.
> 

This is already supported:

=== 8< ===
- name: myscenario
   start:
     - ./script.sh start
   stop:
     - ./script.sh stop
=== 8< ===

> Thanks !
> 

Thanks for the review. I made the changes you requested and pushed it to the 
repository.

I plan to follow up soon with more tests.

Question: I have a few testcases that trigger bugs, segfaults etc. Would it be 
OK to create something like 'failingtestcases.yaml' and register all those bugs 
there until the get fixed? That way we have reproducible bugs until we can fix them.
