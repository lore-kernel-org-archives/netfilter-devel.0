From: "sami ahokas" <sami.m.ahokas@gmail.com>
Subject: Memory leak in netfilter?
Date: Wed, 30 Jan 2008 09:03:19 +0200
Message-ID: <f04ec2cb0801292303r2ceaa44bj4548318e2b2f2e54@mail.gmail.com>
References: <f04ec2cb0801282351p1da0ca69u6e5c405f2d2566f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:13260 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYA3HDU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:03:20 -0500
Received: by rv-out-0910.google.com with SMTP id k20so113142rvb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jan 2008 23:03:19 -0800 (PST)
In-Reply-To: <f04ec2cb0801282351p1da0ca69u6e5c405f2d2566f8@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm using Linux kernel v2.6.20 in a routing device. My problem is that
after a couple of days my device resets itself due to lack of memory.
I monitored slabinfo to see who might be consuming all of the
available memory. What I saw was that nf_nat:help cache is constantly
growing and eventually eats all of the available memory (30MB). Has
any one seen this kind of behavior before? Any ideas what could cause
this?

br, Sami
