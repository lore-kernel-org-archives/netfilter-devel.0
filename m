From: Anton <anton.vazir@gmail.com>
Subject: Re: [ULOGD PATCH 2/4] Add label option (SQL part)
Date: Wed, 30 Apr 2008 09:34:40 +0500
Message-ID: <200804300934.41520.anton.vazir@gmail.com>
References: <1208815106-3315-1-git-send-email-chifflier@inl.fr> <1208815106-3315-3-git-send-email-chifflier@inl.fr> <48142E71.7000802@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pierre Chifflier <chifflier@inl.fr>,
	netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:39877 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYD3Eet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2008 00:34:49 -0400
In-Reply-To: <48142E71.7000802@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just IMHO,

String is more visual and understandable for human view, but 
for how much of the actual processing of the loged data 
done by hands? I suppose majority is somehow automated, 
scripted, etc. Integer allows much faster inserts, in-DB 
processing and lower traffic. I would vote for interger :)

Regards,
Anton.

On Sunday 27 April 2008 12:42, Pablo Neira Ayuso wrote:
> Pierre Chifflier wrote:
> > This patch adds support for "label" option in the SQL
> > schema. For example, it can be used by another module
> > to determine if the packet has been dropped, rejected
> > or accepted.
>
> I have kept this back until we discuss if it would be
> better to have a string instead of an integer.
