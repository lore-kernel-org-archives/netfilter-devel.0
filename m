From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Utilization of Multi-core hardware by Netfilter
Date: Tue, 22 Jun 2010 20:08:19 +0530
Message-ID: <AANLkTik76jQGjSbpXUo29e_75fUV_m8uQxLqEpW9jte5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51412 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab0FVOiV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:38:21 -0400
Received: by gye5 with SMTP id 5so2958854gye.19
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jun 2010 07:38:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I am  pumping data at a connection rate of 6000 connections per second
 on  a Dual Core CPU .
But CPU 0 is the one which is always occupied  upto 100% and CPU 1 is
always 98-100% idle  and after CPU0 reaches 100% connections starts to
fail.
Any pointers other than RPS/RFS  to load balance the CPU utilization ?
I m using linux-2.6.26 kernel .

Anand
