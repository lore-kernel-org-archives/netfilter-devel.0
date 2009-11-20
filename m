From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_queue: Put devs after calling handler
Date: Fri, 20 Nov 2009 13:41:09 +0100
Message-ID: <4B068E65.6050509@trash.net>
References: <4B05FEA0.402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34268 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZKTMlG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:41:06 -0500
In-Reply-To: <4B05FEA0.402@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> Put devs after calling handler.
> 
> If we put the devs before calling handler, the devs may disappear when the handler is running.
> 
> @@ -236,9 +231,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	const struct nf_afinfo *afinfo;
>  
>  	rcu_read_lock();
> -
> -	nf_queue_entry_release_refs(entry);
> -

The devices won't disappear under rcu_read_lock().
