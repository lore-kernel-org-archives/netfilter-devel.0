From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: fix iptables extensions build
 error    in cross-compilation environments
Date: Mon, 28 Jan 2013 12:29:16 +0100
Message-ID: <20130128112916.GA15718@1984>
References: <1358363255-30629-1-git-send-email-cristian.iorga@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Cristian Iorga <cristian.iorga@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38780 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3A1L30 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:29:26 -0500
Content-Disposition: inline
In-Reply-To: <1358363255-30629-1-git-send-email-cristian.iorga@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Cristian,

On Wed, Jan 16, 2013 at 09:07:35PM +0200, Cristian Iorga wrote:
> libtool is properly declared and used for cross-platform
> build environments

I'm hitting this error with your patch:

make[2]: se ingresa al directorio `/tmp/iptables/extensions'
  CC       libxt_AUDIT.lo
  CC       libxt_CHECKSUM.lo
  CC       libxt_CLASSIFY.lo
  CC       libxt_CONNMARK.lo
  CC       libxt_CONNSECMARK.lo
../libtool: 1552: ../libtool: ../libtool: 1552: ../libtool:
preserve_args+= --silent: not found
../libtool: 1564: ../libtool: preserve_args+= --silent: not
foundpreserve_args+= --tag CC: not found

../libtool: 1564: ../libtool: preserve_args+= --tag CC: not found
../libtool: 1: eval: base_compile+= gcc: not found
../libtool: 1: eval: base_compile+= -D_LARGEFILE_SOURCE=1: not found
../libtool: 1: eval: base_compile+= -D_LARGE_FILES: not
found../libtool: 1: eval:   CC       libxt_CT.lo
