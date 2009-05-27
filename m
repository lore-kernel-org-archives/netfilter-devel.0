From: sachin sanap <sachin.sanap.1gb@gmail.com>
Subject: Re: BRIDGE_NF_EBTABLES dependency on BRIDGE_NETFILTER
Date: Wed, 27 May 2009 16:40:26 +0530
Message-ID: <17923cc80905270410j62a68559y151bd20503eeb5fb@mail.gmail.com>
References: <17923cc80905270228s4e5591e4ja03ad433dbf61c8e@mail.gmail.com>
	 <alpine.LSU.2.00.0905271135560.13919@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, buytenh@wantstofly.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:52871 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZE0LKZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 07:10:25 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2575291ywb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2009 04:10:26 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0905271135560.13919@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 27, 2009 at 3:06 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Wednesday 2009-05-27 11:28, sachin sanap wrote:
>
>>Hi,
>>Iam using 2.6.29.2 kernel and I dont understand why is
>>BRIDGE_NF_EBTABLES dependent on BRIDGE_NETFILTER in
>>net/bridge/netfilter/Kconfig ? I can remove the dependency and
>>successfully compile the kernel with BRIDGE_NF_EBTABLES on and
>>BRIDGE_NETFILTER off.
>>Does net/bridge/netfilter/Kconfig need an update or iam missing
>>something obvious?
>
> But what are you going to do with ebtables.ko if there is no one
> to make function calls into it?
>
NF_HOOK is called from two places one from the code thats enabled
because of BRIDGE_NETFILTER  i.e net/bridge/br_netfilter.c
and other from the bridge code itself i.e  net/bridge/br_forward.c
net/bridge/br_input.c etc

so that should not be a problem.
