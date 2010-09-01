From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: Re: get tcp header
Date: Wed, 1 Sep 2010 11:57:35 +0200
Message-ID: <AANLkTinQvTBiw7Gno42xdRdgF5_aCGb8BdEo82ocoY2e@mail.gmail.com>
References: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
	<alpine.LNX.2.01.1008312034240.10509@obet.zrqbmnf.qr>
	<AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54953 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0IAJ5g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:57:36 -0400
Received: by wyb35 with SMTP id 35so9034797wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2010 02:57:35 -0700 (PDT)
In-Reply-To: <AANLkTikQoVP_c6JfoSjz46WrARzP1QEEeuoabSdRjk8A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"If a packet is handled by a bridge, that is, a component that does not
deal with layer 3 or 4, there is no point in spending time to find the
start of the layer 3/4 header."

Ok, well: great. but in this case (bridge) also the skb_network_header
function is senseless because we don't have to find layer3 header.
isn't it?

in general: when i can use the skb_transport_header function?
