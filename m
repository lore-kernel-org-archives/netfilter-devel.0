Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C8CCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF93A20679
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405575AbfJWUii (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:38:38 -0400
Received: from correo.us.es ([193.147.175.20]:40906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405522AbfJWUii (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 16:38:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2121EE8631
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:38:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CE2866DD
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:38:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 01017DA4CA; Wed, 23 Oct 2019 22:38:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1F7FCE15C;
        Wed, 23 Oct 2019 22:38:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 23 Oct 2019 22:38:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CA98641E480C;
        Wed, 23 Oct 2019 22:38:30 +0200 (CEST)
Date:   Wed, 23 Oct 2019 22:38:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] py: add missing output flags.
Message-ID: <20191023203833.aidczbpuxokywu6i@salvia>
References: <20191022205855.22507-1-jeremy@azazel.net>
 <20191022205855.22507-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022205855.22507-3-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 22, 2019 at 09:58:53PM +0100, Jeremy Sowden wrote:
> `terse` and `numeric_time` are missing from the `output_flags` dict.
> Add them and getters and setters for them.

LGTM.

@Phil, is this fine with you? I let you decide on this.

BTW, would it make sense at some point to remove all the getter/setter
per option and use the setter/getter flags approach as in libnftables?

Thanks.

> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  py/nftables.py | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/py/nftables.py b/py/nftables.py
> index 81e57567c802..48eb54fe232d 100644
> --- a/py/nftables.py
> +++ b/py/nftables.py
> @@ -58,6 +58,8 @@ class Nftables:
>          "numeric_proto":  (1 << 7),
>          "numeric_prio":   (1 << 8),
>          "numeric_symbol": (1 << 9),
> +        "numeric_time":   (1 << 10),
> +        "terse":          (1 << 11),
>      }
>  
>      validator = None
> @@ -305,6 +307,39 @@ class Nftables:
>          """
>          return self.__set_output_flag("numeric_symbol", val)
>  
> +    def get_numeric_time_output(self):
> +        """Get current status of numeric times output flag.
> +
> +        Returns a boolean value indicating the status.
> +        """
> +        return self.__get_output_flag("numeric_time")
> +
> +    def set_numeric_time_output(self, val):
> +        """Set numeric times output flag.
> +
> +        Accepts a boolean turning numeric representation of time values
> +        in output either on or off.
> +
> +        Returns the previous value.
> +        """
> +        return self.__set_output_flag("numeric_time", val)
> +
> +    def get_terse_output(self):
> +        """Get the current state of terse output.
> +
> +        Returns a boolean indicating whether terse output is active or not.
> +        """
> +        return self.__get_output_flag("terse")
> +
> +    def set_terse_output(self, val):
> +        """Enable or disable terse output.
> +
> +        Accepts a boolean turning terse output either on or off.
> +
> +        Returns the previous value.
> +        """
> +        return self.__set_output_flag("terse", val)
> +
>      def get_debug(self):
>          """Get currently active debug flags.
>  
> -- 
> 2.23.0
> 
