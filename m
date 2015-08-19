From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxt_CT: add support for recently introduced
 zone options
Date: Thu, 20 Aug 2015 00:05:50 +0200
Message-ID: <20150819220550.GA5313@salvia>
References: <55be6cc4f6e6d0f7c590b6fefc678c36711ac05d.1439062590.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbbHSV7g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 17:59:36 -0400
Content-Disposition: inline
In-Reply-To: <55be6cc4f6e6d0f7c590b6fefc678c36711ac05d.1439062590.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 08, 2015 at 09:45:04PM +0200, Daniel Borkmann wrote:
[...]
> diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
> index 6b28fe1..86b1221 100644
> --- a/extensions/libxt_CT.c
> +++ b/extensions/libxt_CT.c
> @@ -16,7 +16,8 @@ static void ct_help(void)
>  " --helper name			Use conntrack helper 'name' for connection\n"
>  " --ctevents event[,event...]	Generate specified conntrack events for connection\n"
>  " --expevents event[,event...]	Generate specified expectation events for connection\n"
> -" --zone ID			Assign/Lookup connection in zone ID\n"
> +" --zone {ID|mark}		Assign/Lookup connection in zone ID/packet nfmark\n"
> +" --zone-dir {ORIGINAL|REPLY}	Only apply zone in a particular direction\n"

I suggest you add these options:

        --zone-orig ...
        --zone-reply ...
        --zone ...

so they match to what we have in the ctnetlink interface. Thanks!
