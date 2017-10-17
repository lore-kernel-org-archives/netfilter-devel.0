From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: add regression tests for xtables-translate
Date: Tue, 17 Oct 2017 13:35:04 +0200
Message-ID: <20171017113504.GA8841@salvia>
References: <20171016193218.8197-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40480 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756912AbdJQLfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:35:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 089BA1F4CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:35:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9595DA87E
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:35:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171016193218.8197-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 01:02:18AM +0530, Harsha Sharma wrote:
> This test suite is intended to detect regressions in the translation
> infrastructure. The script checks if ip[6]tables-translate produces the
> expected output, otherwise it prints the wrong translation and the
> expected one.
> 
> ** Arguments
> 
>   --all     # Show also passed tests
>   [test]    # Run only the specified test file
> 
> ** Test files structure
> 
> Test files are located under extensions directory. Every file contains
> tests about specific extension translations. A test file name must end
> with ".txlate".
> 
> Inside the files, every single test is defined by two consecutive lines:
> ip[6]tables-translate command and expected result. One blank line is left
> between tests by convention.
> 
> e.g.
> 
>   $ cat extensions/libxt_cpu.txlate
>   iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
>   nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept
> 
>   iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
>   nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept

I think you should replace this commit description to what this really
does, eg.

        libxt_TOS: add tests for translation infrastructure

        This patch checks that the iptables TOS to nftables translation
        works fine.

Please, revisit patch title and description and resubmit.

Thanks!

> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  extensions/libxt_TOS.txlate | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 extensions/libxt_TOS.txlate
> 
> diff --git a/extensions/libxt_TOS.txlate b/extensions/libxt_TOS.txlate
> new file mode 100644
> index 00000000..6d55eb24
> --- /dev/null
> +++ b/extensions/libxt_TOS.txlate
> @@ -0,0 +1,25 @@
> +ip6tables-translate -A INPUT -j TOS --set-tos 0x1f
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x07
> +
> +ip6tables-translate -A INPUT -j TOS --set-tos 0xff
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x3f
> +
> +ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Delay
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
> +
> +ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Cost
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
> +
> +ip6tables-translate -A INPUT -j TOS --set-tos Normal-Service
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
> +
> +ip6tables-translate -A INPUT -j TOS --and-tos 0x12
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
> +
> +ip6tables-translate -A INPUT -j TOS --or-tos 0x12
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
> +
> +ip6tables-translate -A INPUT -j TOS --xor-tos 0x12
> +nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
> +
> +
> -- 
> 2.11.0
> 
