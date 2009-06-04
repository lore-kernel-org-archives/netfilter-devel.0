From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: VLAN tagging not supported by ebtables ?
Date: Thu, 4 Jun 2009 12:42:50 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906041242320.32084@fbirervta.pbzchgretzou.qr>
References: <41f748550906040330l36d5b241w7b0d4d52db352a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be
To: Iwan Budi Kusnanto <iwanbk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43482 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZFDKmt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:42:49 -0400
In-Reply-To: <41f748550906040330l36d5b241w7b0d4d52db352a5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-06-04 12:30, Iwan Budi Kusnanto wrote:

>Hi,
>I'm new to ebtables. From my googling and looking into ebtables source
>code, ebtables doesn't support vlan tagging ? Am i right ? ( i already
>looked at ebt_vlan.c).
>
>If yes, is there any reason why vlan tagging support in ebtables not
>implemented by netfiler/ebtables developer ?

I would say that VLAN tagging is done by routing a packet out a specific 
(VLAN) interface.
