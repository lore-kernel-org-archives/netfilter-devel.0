From: Fabricio Archanjo <farchanjo@gmail.com>
Subject: netfilter issue
Date: Thu, 9 Apr 2009 16:12:01 -0300
Message-ID: <9e9f4e5f0904091212t10a6aeccm4ecef9089a0b00fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40785 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761246AbZDITME (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:12:04 -0400
Received: by fxm2 with SMTP id 2so737535fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2009 12:12:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When, I compiling libnl-nft, i get that error:

  CC netfilter/nft_data.c
netfilter/nft_data.c:22: error: nested redefinition of 'enum nft_data_types'
netfilter/nft_data.c:22: error: redeclaration of 'enum nft_data_types'
netfilter/nft_data.c:23: error: redeclaration of enumerator 'NFT_DATA_VALUE'
../include/linux/netfilter/nf_tables.h:219: error: previous definition
of 'NFT_DATA_VALUE' was here
netfilter/nft_data.c:24: error: redeclaration of enumerator 'NFT_DATA_VERDICT'
../include/linux/netfilter/nf_tables.h:220: error: previous definition
of 'NFT_DATA_VERDICT' was here
make[2]: *** [netfilter/nft_data.o] Error 1
make[1]: *** [all] Error 2
make: *** [all] Error 2

What do i do to repair it? I wanted test nftables.
