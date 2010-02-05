From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri, 5 Feb 2010 08:15:32 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50488 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab0BEHPe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:15:34 -0500
In-Reply-To: <1265334195-28120-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-05 02:43, Florian Westphal wrote:

>Hello netfilter team,
>
>following patch series adds CONFIG_COMPAT
>support to ebtables (unfortunately tested on x86_64 only).

(Good thing I acquired that sparc64! Now if only the virtualization was 
usable with Linux-only...;)

In a quick look, ebtables 2.0.8-2 seems to just work there in both
32/64 and 64/64 [U/K-bitness] combinations:


	# make CC="gcc -m64" LD="ld -melf64_sparc" -j24
	...
	# LD_LIBRARY_PATH=.:extensions ./ebtables -A INPUT -p 0x0800 --ip-source 1.2.3.4
	# LD_LIBRARY_PATH=.:extensions ./ebtables -A INPUT -p 0x0800 --ip-source 1.2.3.4
	# LD_LIBRARY_PATH=.:extensions ./ebtables -L
	Bridge table: filter

	Bridge chain: INPUT, entries: 2, policy: ACCEPT
	-p 0x800 --ip-src 1.2.3.4 -j CONTINUE
	-p 0x800 --ip-src 1.2.3.4 -j CONTINUE

	Bridge chain: FORWARD, entries: 0, policy: ACCEPT

	Bridge chain: OUTPUT, entries: 0, policy: ACCEPT
	# file ebtables
	ebtables: ELF 64-bit MSB executable, SPARC V9, relaxed memory ordering, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.4, not stripped


and

	# make clean; make -j24
	...
	# LD_LIBRARY_PATH=.:extensions ./ebtables -L
	Bridge table: filter

	Bridge chain: INPUT, entries: 2, policy: ACCEPT
	-p 0x800 --ip-src 1.2.3.4 -j CONTINUE 
	-p 0x800 --ip-src 1.2.3.4 -j CONTINUE 

	Bridge chain: FORWARD, entries: 0, policy: ACCEPT

	Bridge chain: OUTPUT, entries: 0, policy: ACCEPT
	# LD_LIBRARY_PATH=.:extensions ./ebtables -A INPUT -p 0x0800 --ip-source 1.2.3.5
	# LD_LIBRARY_PATH=.:extensions ./ebtables -L
	Bridge table: filter

	Bridge chain: INPUT, entries: 3, policy: ACCEPT
	-p 0x800 --ip-src 1.2.3.4 -j CONTINUE 
	-p 0x800 --ip-src 1.2.3.4 -j CONTINUE 
	-p 0x800 --ip-src 1.2.3.5 -j CONTINUE 

	Bridge chain: FORWARD, entries: 0, policy: ACCEPT

	Bridge chain: OUTPUT, entries: 0, policy: ACCEPT
	# file ebtables
	ebtables: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.4, not stripped


So I wonder whether extra patches are really needed for x86_64.

