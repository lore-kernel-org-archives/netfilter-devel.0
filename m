From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Wed, 17 May 2006 00:09:57 -0700 (PDT)
Message-ID: <20060517.000957.45395448.davem@davemloft.net>
References: <20060515204142.GO7774@kenobi.snowman.net>
	<20060515210342.GP7774@kenobi.snowman.net>
	<446AC1FB.5070406@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, azez@ufomechanic.net, willy@w.ods.org,
	gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	marcelo@kvack.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932452AbWEQHKS@vger.kernel.org>
To: kaber@trash.net
In-Reply-To: <446AC1FB.5070406@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 17 May 2006 08:26:03 +0200

> +	if (info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE) &&
> +	    (info->seconds || info->hit_count))
> +		return 0;

I'm feeling particularly dense today... but what is the relative
precedence of '&' vs '&&'?

I've been told that if you have to look up C operator precedence,
don't bother and add parenthesis instead :)
