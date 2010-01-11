From: net expert <netexpert201@gmail.com>
Subject: Re: IP table acceleration
Date: Sun, 10 Jan 2010 23:15:14 -0600
Message-ID: <e8b4413d1001102115p44e05c12s5af7f98c13dc733f@mail.gmail.com>
References: <e8b4413d1001102101i342ebe9fjabf97170333716f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:37532 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0AKFPP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2010 00:15:15 -0500
Received: by iwn32 with SMTP id 32so4411597iwn.33
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jan 2010 21:15:15 -0800 (PST)
In-Reply-To: <e8b4413d1001102101i342ebe9fjabf97170333716f2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
 =A0=A0 I am trying to offload some of the IP table features (primarily
NAT and filters) to an ASIC. Is there anyway to listen for=A0NAT and
filter configuration messages from user space. Or any other
implementation suggestion will be appreciated.

 -SP
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
