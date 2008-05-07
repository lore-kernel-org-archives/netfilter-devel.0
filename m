From: "Srinivas Murthy" <codevana@gmail.com>
Subject: Re: How to disable Connection Tracking runtime
Date: Tue, 6 May 2008 20:54:12 -0700
Message-ID: <df1bdeb10805062054jc1f0e4dla2979cfe9d065876@mail.gmail.com>
References: <df1bdeb10805052038y43f41d12gf45c7f512aea759@mail.gmail.com>
	 <alpine.LNX.1.10.0805060819150.11757@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:22984 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYEGDyN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2008 23:54:13 -0400
Received: by rv-out-0506.google.com with SMTP id l9so143933rvb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 May 2008 20:54:12 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0805060819150.11757@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I tried,

iptables -t raw -p all -j NOTRACK

I can see the rule installed.

However I still see these calls in the oprofile data.

_Sri

On Mon, May 5, 2008 at 11:19 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
>  On Tuesday 2008-05-06 05:38, Srinivas Murthy wrote:
>
>  >Hi,
>  > Is there a way to disable conntracking runtime?
>
>  Use -j NOTRACK.
>
