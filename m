From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: extend nft to list set handle and delete set via
 set handle
Date: Sun, 14 Jan 2018 18:36:58 +0100
Message-ID: <20180114173658.ft5u5tkqtvq2fimx@salvia>
References: <20180114161846.20760-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751766AbeANRhH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jan 2018 12:37:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E41F1140AA1
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 18:37:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4F5ADA841
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 18:37:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180114161846.20760-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 14, 2018 at 09:48:46PM +0530, Harsha Sharma wrote:
> Print 'handle' attribute in sets when listing via '-a' option and
> delete sets via their unique set handles listed with '-a' option.
> For e.g.
> 
> nft delete set [<family>] <table-name> [handle <handle>]
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  include/linux/netfilter/nf_tables.h |  2 ++
>  src/netlink.c                       |  4 ++++
>  src/parser_bison.y                  | 16 ++++++++++++++--
>  src/rule.c                          |  6 +++++-
>  4 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 6db9130..a4c88ff 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -299,6 +299,7 @@ enum nft_set_desc_attributes {
>   *
>   * @NFTA_SET_TABLE: table name (NLA_STRING)
>   * @NFTA_SET_NAME: set name (NLA_STRING)
> + * @NFTA_SET_HANDLE: numeric handle of the set (NLA_U64)
>   * @NFTA_SET_FLAGS: bitmask of enum nft_set_flags (NLA_U32)
>   * @NFTA_SET_KEY_TYPE: key data type, informational purpose only (NLA_U32)
>   * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
> @@ -316,6 +317,7 @@ enum nft_set_attributes {
>  	NFTA_SET_UNSPEC,
>  	NFTA_SET_TABLE,
>  	NFTA_SET_NAME,
> +	NFTA_SET_HANDLE,

Please, add attributes always right at the end of the list. Otherwise,
this breaks binary compatibility.
