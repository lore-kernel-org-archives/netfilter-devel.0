Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48197EB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jul 2023 10:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjGQKZj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jul 2023 06:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjGQKZi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2023 06:25:38 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D1A133
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2023 03:25:36 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3fbfcc6daa9so39215725e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2023 03:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689589534; x=1692181534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EQ4g6j6YW9aeSXlRgsNv0/a8QExYDKl+YHIEt9igAwk=;
        b=jH/lcNV6b0UBb5KYMmqvehb4iCURKicAN0TStjgjmCICDRV/1KB6CwaRPLqubwWgQh
         OFB17IFW3Kkf5HHYQbVxY+/pbWJNbZuPBVzsm6HYdzHFS9GSGz36pIYC0JWjTqahsB+y
         CanEmElbJsEw7HJLPrS1SDM9j3EPaGuZouKbzBLPtgCo3jXGorwRMPIUF/n0Qzrz4pED
         qVTfUcrOHO2ZoqloHiKXp2Amr+FlAsAs+3UigYvOa9oiZ0U+4rp5xF5SEMESb52bQXDT
         e72RWcfEN/HsvOHjCoOQ3bwKTfSoPnH2vK7ENY3TC73Q1xYwH7IHLeGDlTJ3R35QBuHF
         IIHw==
X-Gm-Message-State: ABy/qLYgVBYJAUuIFTuNaFw4ECe2/EU0Q2R67DYkerAMIjKtjhtVEn3y
        JHIMZp+L/vtCInjoUVT+ueLf6SFNN6U=
X-Google-Smtp-Source: APBJJlEUDPduFgl8xBZeUKNPC69d5ppm7G96RJafenlt2RpujBQPVUyodZkbQkM1TaL3Cj9nniQBEQ==
X-Received: by 2002:a7b:ce0d:0:b0:3fb:df34:176e with SMTP id m13-20020a7bce0d000000b003fbdf34176emr8912948wmc.31.1689589534245;
        Mon, 17 Jul 2023 03:25:34 -0700 (PDT)
Received: from ?IPV6:2a0c:5a85:a105:cd00:7813:538a:55d6:7150? ([2a0c:5a85:a105:cd00:7813:538a:55d6:7150])
        by smtp.gmail.com with ESMTPSA id y20-20020a7bcd94000000b003fa96620b23sm7736102wmj.12.2023.07.17.03.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 03:25:33 -0700 (PDT)
Message-ID: <cc7b9429-540e-967d-1c50-7475b28a0973@netfilter.org>
Date:   Mon, 17 Jul 2023 12:25:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [ANNOUNCE] nftables 1.0.8 release
Content-Language: en-US
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <ZLEr3Eg59HyPUUSR@calendula>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <ZLEr3Eg59HyPUUSR@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 7/14/23 13:05, Pablo Neira Ayuso wrote:
> Hi!
> 
> The Netfilter project proudly presents:
> 
>          nftables 1.0.8
> 

It seems the python package is a bit broken.

The problem can be reproduced using the tests/build/run-tests.sh script, which 
will produce something like:

==== 8< ====
/usr/lib/python3/dist-packages/setuptools/_distutils/cmd.py:66: 
SetuptoolsDeprecationWarning: setup.py install is deprecated.
!!

 
********************************************************************************
         Please avoid running ``setup.py`` directly.
         Instead, use pypa/build, pypa/installer, pypa/build or
         other standards-based tools.

         See https://blog.ganssle.io/articles/2021/10/setup-py-deprecated.html 
for details.
 
********************************************************************************

!!
   self.initialize_options()
/usr/lib/python3/dist-packages/setuptools/_distutils/cmd.py:66: 
EasyInstallDeprecationWarning: easy_install command is deprecated.
!!

 
********************************************************************************
         Please avoid running ``setup.py`` and ``easy_install``.
         Instead, use pypa/build, pypa/installer, pypa/build or
         other standards-based tools.

         See https://github.com/pypa/setuptools/issues/917 for details.
 
********************************************************************************

!!
   self.initialize_options()
TEST FAILED: 
/tmp/tmp.JeA0ZINB5h/nftables-1.0.8/_inst/local/lib/python3.11/dist-packages/ 
does NOT support .pth files
bad install directory or PYTHONPATH

You are attempting to install a package to a directory that is not
on PYTHONPATH and which Python does not read ".pth" files from.  The
installation directory you specified (via --install-dir, --prefix, or
the distutils default setting) was:

     /tmp/tmp.JeA0ZINB5h/nftables-1.0.8/_inst/local/lib/python3.11/dist-packages/

and your PYTHONPATH environment variable currently contains:

     ''

Here are some of your options for correcting the problem:

* You can choose a different installation directory, i.e., one that is
   on PYTHONPATH or supports .pth files

* You can add the installation directory to the PYTHONPATH environment
   variable.  (It must then also be on PYTHONPATH whenever you run
   Python and want to use the package(s) you are installing.)

* You can set up the installation directory to support ".pth" files by
   using one of the approaches described here:

 
https://setuptools.pypa.io/en/latest/deprecated/easy_install.html#custom-installation-locations


Please make the appropriate changes for your system and try again.
error: could not create 'nftables.egg-info': Permission denied
make[3]: *** [Makefile:462: install-exec-local] Error 1
make[2]: *** [Makefile:349: install-am] Error 2
make[1]: *** [Makefile:481: install-recursive] Error 1
make: *** [Makefile:697: distcheck] Error 1
==== 8< ====

I ignore what the fix is at the moment, but if if distutils is truly deprecated 
then a revert of 
https://git.netfilter.org/nftables/commit/?id=1acc2fd48c755a8931fa87b8d0560b750316059f 
may not be the correct solution.


