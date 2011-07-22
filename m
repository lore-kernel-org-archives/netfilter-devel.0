From: 00bormoj@gmail.com
Subject: Re: Bug#631945: HFSC warning issue
Date: Fri, 22 Jul 2011 07:23:37 -0700
Message-ID: <CAAJ8s-QSoQFhd44KpCoY3wPNkPVh=3QzUM9B-Jbz-grF=V8H3g@mail.gmail.com>
References: <40cb21d3.13a4e2d8.4e2949de.1e1fc@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: 631945@bugs.debian.org, soltys@ziu.info, kaber@trash.net,
	netfilter-devel@vger.kernel.org, fdelawarde@wirelessmundi.com
To: Michal Pokrywka <wolfmoon@o2.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53035 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1GVOXi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:23:38 -0400
Received: by gwaa18 with SMTP id a18so1621396gwa.19
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2011 07:23:37 -0700 (PDT)
In-Reply-To: <40cb21d3.13a4e2d8.4e2949de.1e1fc@o2.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2011 at 2:58 AM, Michal Pokrywka <wolfmoon@o2.pl> wrote:
>> I had the same problem when I upgraded to 2.6.38 vanilla (and
>> currently at 2.6.39.1), but I can't remember what the last successful
>> version was (probably greater than 2.6.32). My syslog was full of the
>> WARN_ON trace from sch_hfsc.c:1427.
>
> Did you tested 2.6.38 or 2.6.38.8? Because mentioned patches was included in 2.6.38.8.

Sorry, I don't remember for sure. I am only 100% sure that I currently
have the issue on 2.6.39.1; anything else I may have remembered
incorrectly.
