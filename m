From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [HEADS UP] Migrating ebtables and arptables to netfilter.org
Date: Thu, 29 May 2014 01:37:43 -0700
Message-ID: <CAHo-OoxDb6rREH1kZNKSGWzVL6pwwuzgEgYbHWA-NAUX9fRJqg@mail.gmail.com>
References: <20140527083359.GA4342@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	bridge@lists.linux-foundation.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:61451 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbaE2Iho (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 04:37:44 -0400
In-Reply-To: <20140527083359.GA4342@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Missing tags if there were any previously.

On Tue, May 27, 2014 at 1:33 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi!
>
> We're migrating arptables and ebtables to git.netfilter.org. The new
> location for the repositories are:
>
> 1) arptables:
>
>         git://git.netfilter.org/arptables
>         http://git.netfilter.org/arptables/
>
> 2) ebtables:
>
>         git://git.netfilter.org/ebtables
>         http://git.netfilter.org/ebtables/
>
> Originally, these two applications were located in the same repository
> which has been kept at:
>
>         http://git.netfilter.org/ebtables.old-history/
>
> just for the record.
>
> I have git-filter-branch the original repository to separate the
> ebtables and the arptables in two independent repositories.
>
> Let me know if you experience any problem in this migration,
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
