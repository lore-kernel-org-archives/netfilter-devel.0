Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9415C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 22:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91D8206D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 22:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgFNWDO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:03:14 -0400
Received: from correo.us.es ([193.147.175.20]:34014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgFNWDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 18:03:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE2D3FF90C
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 00:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E27A3DA78D
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 00:03:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CCDD1DA797; Mon, 15 Jun 2020 00:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8256CDA73D;
        Mon, 15 Jun 2020 00:03:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jun 2020 00:03:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 64563426CCB9;
        Mon, 15 Jun 2020 00:03:09 +0200 (CEST)
Date:   Mon, 15 Jun 2020 00:03:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: Run in separate network namespace, don't
 break connectivity
Message-ID: <20200614220309.GA9310@salvia>
References: <8efb5334f8b4df21b8833e576abd5721486c0182.1592170411.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8efb5334f8b4df21b8833e576abd5721486c0182.1592170411.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 14, 2020 at 11:41:57PM +0200, Stefano Brivio wrote:
> It might be convenient to run tests from a development branch that
> resides on another host, and if we break connectivity on the test
> host as tests are executed, we can't run them this way.
> 
> If kernel implementation (CONFIG_NET_NS), unshare(1), or Python
> bindings for unshare() are not available, warn and continue.
> 
> Suggested-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  tests/py/nft-test.py     | 6 ++++++
>  tests/shell/run-tests.sh | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 01ee6c980ad4..df97ed8eefb7 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -1394,6 +1394,12 @@ def main():
>      # Change working directory to repository root
>      os.chdir(TESTS_PATH + "/../..")
>  
> +    try:
> +        import unshare
> +        unshare.unshare(unshare.CLONE_NEWNET)
> +    except:
> +        print_warning("cannot run in own namespace, connectivity might break")
> +

In iptables-tests.py, there is an option for this:

        parser.add_argument('-N', '--netns', action='store_true',
                            help='Test netnamespace path')

Is it worth keeping this in sync with it?
