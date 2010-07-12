From: Pete Kay <petedao@gmail.com>
Subject: unable to find struct ip_nat_multi_range
Date: Mon, 12 Jul 2010 22:44:05 +0800
Message-ID: <AANLkTiknjTq-sw5RKFaczEHlIVu_1DJQitTGiG9MX2HJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:46128 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0GLOoH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:44:07 -0400
Received: by pxi14 with SMTP id 14so1823603pxi.19
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jul 2010 07:44:05 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am using kernel 2.6.33 right now, and I can no longer find ip_nat.h
anywhere in the file system.

I used to have that file with 2.6.18 kernel.

The problem I am having is that I need struct ip_nat_multi_range to
build the ip_entry structure for DNAT / SNAT ( -- to-destionat, and
--from-source field).

Is there any alternative other than using struct ip_nat_multi_range?

thanks,
P
