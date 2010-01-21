From: net expert <netexpert201@gmail.com>
Subject: netfilter Integration with hardware
Date: Thu, 21 Jan 2010 13:11:11 -0600
Message-ID: <e8b4413d1001211111l1a08a109w8403572a0e9e68d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f196.google.com ([209.85.223.196]:45141 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0AUTLN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:11:13 -0500
Received: by iwn34 with SMTP id 34so284223iwn.21
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2010 11:11:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

We have general purpose CPU (PPC) and an ASIC on our board. ASIC can
perform all lookups according to the packet address/port
source/destination,protocol type, MAC address source/destination.
Depending on the outcome of
the lookup ASIC can
- drop the packet
- forward the packet to one of the interfaces
- forward the packet to the CPU and so on.


We are running 2.6 Linux kernel in the CPU. Naturally I would like to
use netfilter for management of the hardware (ASIC) tables and use the
hardware to forward as many packets as possible without CPU
intervention.

I read through the documentation and started to study the source code.
It appears, that it's possible to solve the
problem. But I would like to avoid solving the same time problem
twice. Is there any example(s) for this type of integration ? any
documentation/tips/links could save me lot of time.

Thanks,
