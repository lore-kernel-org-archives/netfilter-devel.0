From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: fix for userspace expectations
Date: Tue, 12 Apr 2011 09:59:52 -0700
Message-ID: <BANLkTinVysqxicSa9mF1BTieCrJxyv-rUg@mail.gmail.com>
References: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>
	<4D908351.5010407@netfilter.org>
	<AANLkTi=LNMqTMf34OnjP3rgp5hrw=bLgrdZneZ4cyffi@mail.gmail.com>
	<4D91B083.2000001@netfilter.org>
	<AANLkTi=XfknKE9RkiohtW4+xzpAe2CGY1JDg7_JtfSUG@mail.gmail.com>
	<4D925614.2000909@netfilter.org>
	<AANLkTi=9y=E3dfq3QZEUHcQ506uHb+VhsivB+Ot-QQgR@mail.gmail.com>
	<4DA1986A.4080305@netfilter.org>
	<BANLkTinjb2yhAQo4Zqs1hMgcBCH1caM0yQ@mail.gmail.com>
	<4DA40CD6.9030501@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44920 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab1DLQ7x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:59:53 -0400
Received: by vxi39 with SMTP id 39so5046649vxi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2011 09:59:52 -0700 (PDT)
In-Reply-To: <4DA40CD6.9030501@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2011 at 1:27 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The main change is the following: You have to use the iptables CT target
> with the option --userspace-helper in the raw table of prerouting.

Patches to the iptables man page would be helpful.

Your example passes all traffic through the CT target.

Is that necessary? Can I match just tcp packets on the ports used by
the protocol who's connections are being tracked? Can the CT target be
used in the filter table?

>> Can you suggest a reliable way to reproduce the crash? I only saw it

Can you suggest a reliable way to reproduce the crash?

>> once, and have no way to reproduce reliably, so no way to assure you
>> the patch fixes the problem, I can only tell you if my code continues
>> to work correctly.
>
> I sent an email to describe the problem to the ML. Every expectation

Perhaps this was private email with some other netfilter devs? I can't
find it in the archives:

http://marc.info/?l=netfilter-devel&w=2&r=1&s=pablo&q=b

Cheers,
Sam
