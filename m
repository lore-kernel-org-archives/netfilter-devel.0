From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/4] Add label option (SQL part)
Date: Wed, 30 Apr 2008 10:40:19 +0200
Message-ID: <48183073.1000109@netfilter.org>
References: <1208815106-3315-1-git-send-email-chifflier@inl.fr> <1208815106-3315-3-git-send-email-chifflier@inl.fr> <48142E71.7000802@netfilter.org> <200804300934.41520.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pierre Chifflier <chifflier@inl.fr>,
	netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35544 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756485AbYD3Ik1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:40:27 -0400
In-Reply-To: <200804300934.41520.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> Just IMHO,
> 
> String is more visual and understandable for human view, but 
> for how much of the actual processing of the loged data 
> done by hands? I suppose majority is somehow automated, 
> scripted, etc. Integer allows much faster inserts, in-DB 
> processing and lower traffic. I would vote for interger :)

Indeed. The patch was applied yesterday with a minor revision (rename
label to numberic_label)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
