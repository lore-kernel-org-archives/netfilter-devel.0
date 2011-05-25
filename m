From: JP Abgrall <jpa@google.com>
Subject: Re: Force socket error on iptables reject with icmp semantics?
Date: Tue, 24 May 2011 18:57:50 -0700
Message-ID: <BANLkTim10aVkudq_iOtW8KWLqNpS=TBo=Q@mail.gmail.com>
References: <BANLkTi=APDmR7c8eqVySKofXx_wMtgPGOw@mail.gmail.com> <4DDB57DB.8050004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:19079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1EYB6N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 21:58:13 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p4P1wB3R003014
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 18:58:12 -0700
Received: from gyd8 (gyd8.prod.google.com [10.243.49.200])
	by hpaq6.eem.corp.google.com with ESMTP id p4P1vpHj024613
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 18:58:10 -0700
Received: by gyd8 with SMTP id 8so2950232gyd.28
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 18:58:10 -0700 (PDT)
In-Reply-To: <4DDB57DB.8050004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 24, 2011 at 00:01, Patrick McHardy <kaber@trash.net> wrote:
> The interpretation and handling of the ICMP errors is up to the higher
> layer protocols.
This is only for DEST_UNREACH, and I was expecting that the convert
table/func was the way to deal with it. But apparently not.

How about e.g. "--reject-with-forced-socket-error-matching-icmp
--reject-with icmp*blabla"?

> Unless there's something wrong in your setup, the ICMP message should
> be received by the socket anyways.
My understanding was that it won't happen if an ingress packet gets
rejected. In that case the icmp is only sent back out, as it uses
icmp*_send().

I'll see if it is not too hard to have icmp*_send(...., direction),
and call it for each direction.

For now, I'll keep my reject change (after fixing the arg in the v6
convert call) as it does allow user space to not wait for incoming
data after that.
--
