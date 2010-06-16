From: martinbarrowcliff <martinbarrowcliff@gmail.com>
Subject: 2.6.34 ALIGN patch
Date: Wed, 16 Jun 2010 09:55:31 -0400
Message-ID: <4C18D7D3.90807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45061 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab0FPNyi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:54:38 -0400
Received: by gwj15 with SMTP id 15so3959657gwj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2010 06:54:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I successfully applied patch from
commit a79ff731a1b277d0e92d9453bdf374e04cec717a
and reinstalled headers.

Now kernel fails to build right here:

  CC      lib/hexdump.o
  CC      lib/kasprintf.o
  CC      lib/bitmap.o
lib/bitmap.c: In function 'bitmap_find_next_zero_area':
lib/bitmap.c:341:2: error: implicit declaration of function '__ALIGN_MASK'
make[1]: *** [lib/bitmap.o] Error 1
make: *** [lib] Error 2



Marty B.
