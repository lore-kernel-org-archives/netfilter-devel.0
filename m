From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] nftables: Fix list of sets by family
Date: Fri, 28 Mar 2014 12:37:47 +0100
Message-ID: <CAOkSjBhjxrKAdcdyzgZLm-psS+Tm1Zxx6pf0XXyMt+kRWp2JRg@mail.gmail.com>
References: <dfe65abd0921773564be9ebfe55b55233380bd40.1395993386.git.anarey@gmail.com>
 <20140328102555.GB20105@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ana Rey <anarey@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39560 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaC1LiI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:38:08 -0400
Received: by mail-lb0-f175.google.com with SMTP id w7so3548818lbi.20
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 04:38:07 -0700 (PDT)
In-Reply-To: <20140328102555.GB20105@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 March 2014 11:25, Patrick McHardy <kaber@trash.net> wrote:
>
> These are two unrelated changes. Regarding the indentation, Arturro h=
as
> a patch that will also fix this in a more general way. Please seperat=
e
> the grammar fix and submit this patch, we'll fix the indentation with
> Arturro's monitor feature.
>

BTW, the monitor stuff is blocked by the set_elem event reporting patch=
 [0].
Could you please review it when you have time?

thanks, regards.

[0] http://patchwork.ozlabs.org/patch/331778/

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
