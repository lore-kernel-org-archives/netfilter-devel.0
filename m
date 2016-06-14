From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: extensions: libxt_MARK: Add translation to
 nft
Date: Tue, 14 Jun 2016 18:59:56 +0200
Message-ID: <20160614165956.GA2120@salvia>
References: <c6a9fe06-8b97-93c3-2abb-f50f2d64cd88@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: Roberto =?iso-8859-1?Q?Garc=EDa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48621 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbcFNRAD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 13:00:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 24230E7DC8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 19:00:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 156899EBA0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 19:00:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72FB99EBBA
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:59:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <c6a9fe06-8b97-93c3-2abb-f50f2d64cd88@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 09, 2016 at 12:24:53AM +0200, Roberto Garc=EDa wrote:
> diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
> index 556dbde..ec1ed05 100644
> --- a/extensions/libxt_MARK.c
> +++ b/extensions/libxt_MARK.c
> @@ -245,6 +245,28 @@ static void mark_tg_save(const void *ip,
> const struct xt_entry_target *target)
>  	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
>  }
>  +static int mark_tg_xlate(const void *ip, const struct
> xt_entry_target *target,
> +			 struct xt_xlate *xl, int numeric)

git am says this patch has been mangled by you MUA :(. Please resend.
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
