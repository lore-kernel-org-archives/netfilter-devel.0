From: Iwan Budi Kusnanto <iwanbk@gmail.com>
Subject: Re: VLAN tagging not supported by ebtables ?
Date: Thu, 4 Jun 2009 17:52:05 +0700
Message-ID: <41f748550906040352o57022c9br55c8658adb84073b@mail.gmail.com>
References: <41f748550906040330l36d5b241w7b0d4d52db352a5@mail.gmail.com>
	 <alpine.LSU.2.00.0906041242320.32084@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:50820 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZFDKwD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:52:03 -0400
Received: by pxi12 with SMTP id 12so666185pxi.33
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2009 03:52:05 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0906041242320.32084@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6/4/09, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> I would say that VLAN tagging is done by routing a packet out a specific
>  (VLAN) interface.
>

Thanks Jan, we meet some condition that prevent us from adding VLAN
interface in our system.


-- 
Iwan Budi Kusnanto
