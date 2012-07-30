From: Arif Hossain <aftnix@gmail.com>
Subject: Building iptables from source with kernel source
Date: Mon, 30 Jul 2012 17:01:22 +0600
Message-ID: <1343646082.3347.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47992 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2G3LMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jul 2012 07:12:01 -0400
Received: by pbbrp8 with SMTP id rp8so9671315pbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jul 2012 04:12:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to build iptables from git tree.

The extension i've written resides in extensions/libxt_mymatch.c

Now the header is in
<kernel_source>/include/linux/netfilter/xt_mymatch.h

But when i'm trying to build iptables, its not finding xt_mymatch.h.

I've tried these configure options

$./configure --with-ksource=<kernel_source_path>
and
$./configure --with-ksource=<kernel_source_path>/include

But both failed.

On the side not I want to prevent the build process to look up for
declarations in "kernel-devel" that is /usr/src/linux. I want the build
to be dependent only to the kernel_source i'm supplying. (Its because
i'm using a modified kernel source, so i don't want to take any
declaration from distribution's kernel package.


-- 
Cheers

aft
aftnix@gmail.com

