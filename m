From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: checkentry function
Date: Tue, 5 Oct 2010 15:01:47 +0900
Message-ID: <20101005150147.62226282@s6510>
References: <AANLkTimeoRTBMY0OH5sDtVEfqFCx9F3go1qGKy5cJpWS@mail.gmail.com>
	<20101005144615.0f84d53a@s6510>
	<AANLkTikDi3ziyH9eJbEhjOBwjFVHrtsMzYEJes4=eiJF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:47364 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab0JEGBv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:01:51 -0400
In-Reply-To: <AANLkTikDi3ziyH9eJbEhjOBwjFVHrtsMzYEJes4=eiJF@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 5 Oct 2010 07:52:39 +0200
Nicola Padovano <nicola.padovano@gmail.com> wrote:

> > In current kernels, checkentry returns errno values.
> > 0 = okay
> > <0 is error (example -EINVAL).
> 0 = ok? and then you say 0 is error? which one?
> 

Negative (ie < 0) is used for error numbers. This is confusing
because in older kernels the checkentry returned a bool which
is defined as 1 okay and 0 for error. 
