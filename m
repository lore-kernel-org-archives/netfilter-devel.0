From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Couldn't load match `pknock':(null)
Date: Wed, 19 Aug 2009 04:07:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908190407200.24013@fbirervta.pbzchgretzou.qr>
References: <7e36c7130908181531r3262c9b6kf3f038f9092cc34f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: fender <frozenspot@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37100 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZHSCIA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:08:00 -0400
In-Reply-To: <7e36c7130908181531r3262c9b6kf3f038f9092cc34f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-08-19 00:31, fender wrote:

>Hi people,
>
>I've just applied some patches to the pknock match module to work with
>kernel > 2.6.28 and iptables 1.4.x.
>
>What I get when I try to execute this module is:
>
># iptables -m pknock --help
>iptables v1.4.3: Couldn't load match `pknock':(null)
>
>
>Does anyone have any clue about this issue?

My guess that this had been addressed with commit v1.4.3.1-3-gc4edfa6.
