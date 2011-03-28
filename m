From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter:ipset: References are protected by rwlock
 instead of mutex
Date: Mon, 28 Mar 2011 14:35:01 +0200
Message-ID: <4D908075.1010008@trash.net>
References: <1301049733-32160-1-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-2-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41150 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1C1MfE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:35:04 -0400
In-Reply-To: <1301049733-32160-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 25.03.2011 11:42, schrieb Jozsef Kadlecsik:
> The timeout variant of the list:set type must reference the member sets.
> However, its garbage collector runs at timer interrupt so the mutex protection
> of the references is a no go. Therefore the reference protection
> is converted to rwlock.
> 

>  __ip_set_get(ip_set_id_t index)
>  {
> -	atomic_inc(&ip_set_list[index]->ref);
> +	write_lock_bh(&ip_set_ref_lock);
> +	ip_set_list[index]->ref++;
> +	write_unlock_bh(&ip_set_ref_lock);
>  }
>  

I'm not sure I get this, why aren't regular atomic ops working
here?
