Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1A3C43215
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 13:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC94E20855
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 13:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKUNG5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 08:06:57 -0500
Received: from correo.us.es ([193.147.175.20]:48908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfKUNG4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 08:06:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0434BAE8C
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 14:06:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1B8DB7FFB
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 14:06:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 96775B7FF6; Thu, 21 Nov 2019 14:06:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A29CD2B1E;
        Thu, 21 Nov 2019 14:06:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Nov 2019 14:06:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 15E3842EF4E1;
        Thu, 21 Nov 2019 14:06:50 +0100 (CET)
Date:   Thu, 21 Nov 2019 14:06:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC 3/4] files: add example secmark config
Message-ID: <20191121130651.s4sj6u5qjqmxivww@salvia>
References: <20191120174357.26112-1-cgzones@googlemail.com>
 <20191120174357.26112-3-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191120174357.26112-3-cgzones@googlemail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch does not apply here to current git HEAD for some reason.

On Wed, Nov 20, 2019 at 06:43:56PM +0100, Christian Göttsche wrote:
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> ---
>  files/examples/Makefile.am |  1 +
>  files/examples/secmark.nft | 85 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
>  create mode 100755 files/examples/secmark.nft
> 
> diff --git a/files/examples/Makefile.am b/files/examples/Makefile.am
> index c40e041e..b29e9f61 100644
> --- a/files/examples/Makefile.am
> +++ b/files/examples/Makefile.am
> @@ -1,4 +1,5 @@
>  pkgdocdir = ${docdir}/examples
>  dist_pkgdoc_SCRIPTS = ct_helpers.nft \
>  		load_balancing.nft \
> +		secmark.nft \
>  		sets_and_maps.nft
> diff --git a/files/examples/secmark.nft b/files/examples/secmark.nft
> new file mode 100755
> index 00000000..0e010056
> --- /dev/null
> +++ b/files/examples/secmark.nft
> @@ -0,0 +1,85 @@
> +#!/usr/sbin/nft -f
> +
> +# This example file shows how to use secmark labels with the nftables framework.
> +# This script is meant to be loaded with `nft -f <file>`
> +# You require linux kernel >= 4.20 and nft >= 0.9.3
> +# For up-to-date information please visit https://wiki.nftables.org
> +
> +
> +flush ruleset
> +
> +table inet filter {
> +	secmark ssh_server {
> +		"system_u:object_r:ssh_server_packet_t:s0"
> +	}
> +
> +	secmark dns_client {
> +		"system_u:object_r:dns_client_packet_t:s0"
> +	}
> +
> +	secmark http_client {
> +		"system_u:object_r:http_client_packet_t:s0"
> +	}
> +
> +	secmark https_client {
> +		"system_u:object_r:http_client_packet_t:s0"
> +	}
> +
> +	secmark ntp_client {
> +		"system_u:object_r:ntp_client_packet_t:s0"
> +	}
> +
> +	secmark icmp_client {
> +		"system_u:object_r:icmp_client_packet_t:s0"
> +	}
> +
> +	secmark icmp_server {
> +		"system_u:object_r:icmp_server_packet_t:s0"
> +	}
> +
> +	secmark ssh_client {
> +		"system_u:object_r:ssh_client_packet_t:s0"
> +	}
> +
> +	secmark git_client {
> +		"system_u:object_r:git_client_packet_t:s0"
> +	}
> +
> +	map secmapping_in {
> +		type inet_service : secmark
> +		elements = { 22 : "ssh_server" }
> +	}
> +
> +	map secmapping_out {
> +		type inet_service : secmark
> +		elements = { 22 : "ssh_client", 53 : "dns_client", 80 : "http_client", 123 : "ntp_client", 443 : "http_client", 9418 : "git_client" }
> +	}
> +
> +	chain input {
> +		type filter hook input priority 0;
> +
> +		# label new incoming packets and add to connection
> +		ct state new meta secmark set tcp dport map @secmapping_in
> +		ct state new meta secmark set udp dport map @secmapping_in
> +		ct state new ip protocol icmp meta secmark set "icmp_server"
> +		ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_server"
> +		ct state new ct secmark set meta secmark
> +
> +		# set label for est/rel packets from connection
> +		ct state established,related meta secmark set ct secmark
> +	}
> +
> +	chain output {
> +		type filter hook output priority 0;
> +
> +		# label new outgoing packets and add to connection
> +		ct state new meta secmark set tcp dport map @secmapping_out
> +		ct state new meta secmark set udp dport map @secmapping_out
> +		ct state new ip protocol icmp meta secmark set "icmp_client"
> +		ct state new ip6 nexthdr icmpv6 meta secmark set "icmp_client"
> +		ct state new ct secmark set meta secmark
> +
> +		# set label for est/rel packets from connection
> +		ct state established,related meta secmark set ct secmark
> +	}
> +}
> -- 
> 2.24.0
> 
