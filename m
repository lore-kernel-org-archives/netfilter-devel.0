From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/7] Add label option to NFLOG input plugin.
Date: Sun, 27 Apr 2008 09:27:35 +0200
Message-ID: <48142AE7.5020701@netfilter.org>
References: <4805E566.7010902@netfilter.org> <1208352161448-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37016 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751728AbYD0H1o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:27:44 -0400
In-Reply-To: <1208352161448-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> @@ -78,6 +78,13 @@ static struct config_keyset libulog_kset = {
>  			.options = CONFIG_OPT_NONE,
>  			.u.value = 0,
>  		},
> +		{
> +			.key	 = "label",
> +			.type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +			.u.value = 0,
> +		},
> +
>  	}
>  };

Wouldn't it better if we use a string instead of an integer? Thus, this
will really work as labeler.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
