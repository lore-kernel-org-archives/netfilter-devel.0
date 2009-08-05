From: Giacomo <delleceste@gmail.com>
Subject: NF_INET_LOCAL_OUT and packet checksum
Date: Wed, 5 Aug 2009 10:20:32 +0200
Message-ID: <885896af0908050120k5b0d839fj65fe1aa4e6ac754c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53013 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741AbZHEIUc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:20:32 -0400
Received: by ewy10 with SMTP id 10so937644ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2009 01:20:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all.
I would like to know wether in NF_INET_LOCAL_OUT packets arrive
already checksummed
(both IP and layer4 checksums).

Actually I noticed, in nf_nat_core.c and nf_nat_proto_tcp/udp.c the use of

csum_replace4() and csum_replace2().

Is the checksum in all cases already correctly calculated in this hook?
Does netfilter recalculate it afterwards? (post routing?)

Thanks in advance.

Giacomo
