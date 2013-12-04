From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: Merging iptables-nftables into iptables
Date: Wed, 4 Dec 2013 16:11:18 +0100
Message-ID: <CAOkSjBj5z7x+15Dmw-EWtqiBWfv4h+DBO0s7KNeZgkgrZP4g+w@mail.gmail.com>
References: <20131204114834.GA13280@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37702 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3LDPLk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:11:40 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so9280618lbv.24
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2013 07:11:38 -0800 (PST)
In-Reply-To: <20131204114834.GA13280@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 December 2013 12:48, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> Hi,
>
> The iptables-nftables tree [1] currently stores the iptables over
> nftables compatibility support. This allows you to run iptables
> commands using the nftables kernel infrastructure.
>
> JFYI, my plan is to merge the iptables-nftables into iptables at some
> point of this week given that it contains stuff that is scheduled for
> 3.13.  After that merge, the iptables-nftables will be disabled.
>
> [1] http://git.netfilter.org/iptables-nftables/

Could you give some hints about releases of userspace stuff?
(libnftables, nft, new iptables...)

Is 3.13 a deadline for releases?

I'm new to these situations :-)

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
