From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Wrong MAC in redirected packet
Date: Thu, 26 Mar 2009 21:07:41 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903262106140.15111@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>  <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>  <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
  <49CA8A6B.1020603@gmail.com>  <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>  <49CA8C5A.1030908@gmail.com>  <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>  <49CA9B8B.7080605@gmail.com>
 <17e3a8f80903260326i636c7c0byaf4d9b0b8e77c514@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53363 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZCZUHo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:07:44 -0400
In-Reply-To: <17e3a8f80903260326i636c7c0byaf4d9b0b8e77c514@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-26 11:26, Kristian Evensen wrote:
>
>Turned out that it was the checksums. They were calculated correctly,
>but since I processed packets on input, tcp_hdr and udp_hdr of course
>returned invalid pointers. My code is now more or less RAWNAT, so if
>it is of interest to anybody else I will merge them and make it
>available.

I have now rebased the RAWNAT branch to Xt-a's master and
made the rawpost tables workable with all kernel versions.
It does not have MAC addr punning yet.
