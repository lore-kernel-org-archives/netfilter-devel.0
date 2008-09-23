From: "Julius Volz" <juliusv@google.com>
Subject: Re: Getting IPVS and Netfilter SNAT to play together
Date: Tue, 23 Sep 2008 15:54:09 +0200
Message-ID: <f4845fc0809230654o159334d6p76952663f00cb881@mail.gmail.com>
References: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>
	 <alpine.LNX.1.10.0809230827410.29878@fbirervta.pbzchgretzou.qr>
	 <f4845fc0809230545n6c879a7eg7214b0a3b3db61a3@mail.gmail.com>
	 <f4845fc0809230613l68c1ba90s16e5482479bd3c9c@mail.gmail.com>
	 <alpine.LNX.1.10.0809230920330.29878@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	"Simon Horman" <horms@verge.net.au>,
	"Joseph Mack NA3T" <jmack@wm7d.net>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:32828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbYIWNyS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:54:18 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id m8NDsB1j027541
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 14:54:11 +0100
Received: from ug-out-1314.google.com (ugfk3.prod.google.com [10.66.187.3])
	by spaceape9.eur.corp.google.com with ESMTP id m8NDs9Z2017754
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 06:54:10 -0700
Received: by ug-out-1314.google.com with SMTP id k3so2000627ugf.5
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 06:54:09 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0809230920330.29878@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 23, 2008 at 3:21 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Tuesday 2008-09-23 09:13, Julius Volz wrote:
>>
>>Ok, the SYN/ACK from the backend is logged as --cstate INVALID in
>>PREROUTING and INPUT. This means that Netfilter thinks it doesn't
>>belong to any connection, although it just SNATed the SYN to the
>>backend correctly? Hmm... how can this be?
>
> That probably means skb->nfct is lost (set to NULL, which is what INVALID
> indicates) after SNAT (PREROUTING), when IPVS kicks in.

But at PREROUTING, the skb hasn't seen any part of IPVS yet. And the
prior SNAT for the SYN packet happened in POSTROUTING after all of
IPVS was finished. Basically, there should be no IPVS involved from
the time that the SYN is correctly SNATed and the time that the
SYN/ACK is not. Please correct me if I'm missing something here...

Julius

-- 
Julius Volz - Corporate Operations - SysOps

Google Switzerland GmbH - Identification No.: CH-020.4.028.116-1
