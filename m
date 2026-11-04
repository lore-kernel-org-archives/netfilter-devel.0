Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786532;
	b=gPHJES838pXgiyg+mclZMj58Ec1Sfs2Hk2AUfDeeyrzr+BErQfVCnlvfJZPuveA15UtQ
	 rFJXhv7G5vjO73cC2AOUEPoGtYZ3n3Ef7hPSoaT7L+tTCzJqpNZgJ11AP5qn2Cq0zlKQq
	 dOmxM35XTPXwStuSPJ7HZO191cYCdl3NkZZMVk6tPWeFmv9bQj8mwxlCDCrlf9vKZ2xHf
	 xCikdsMm/DCjvFvbWBl6IL2IL9cmT9xTpxrUiFf6nGejyYfbE5E9BuZ4tZCSfqPr/2eib
	 xjbeLaUclcSUHVN57McPbPmibHQrpqFp303aw13HMqHiF9DV/pdg7EDHxm9B1D/c8lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786532;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=S6Q5OkWW7R8j7PzxRo/f67F7iobuS0oi4ftJmC9oY4s=;
	b=mTqLDOfsLclWHtPIH7u+oZ3IgjP3aehE2kVkp6pSWABoVDOJCaLcASN8ZgGrqLDG3fC8
	 G1LRSl8XJEh5jUdAauOqhFr8Q9GhTvfA+PeGERKMerp4AP9xnF61anAKiTk6XdxR6+try
	 ehaTf128YT20wCOINDKYcGUCX8dKlsf+ae1obaO29FNhLHzec6D/T/0kY/oHRw5uPN/xt
	 4MHFJouf+gv41MEEpcbAGvc2BOS/hAUR9HPI0t6EiCk2KYNuIqaMgVP7w4WXDV+l/XKhQ
	 hTt9U7BgIlGjQ0lgJQ95nW6j+L9TXKVl0lOfqd+fVTs6O/df2t8PftRyuzYndTHUnjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cp9NIAdv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SbZTywgr;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cp9NIAdv;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SbZTywgr;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C990A606A328
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 10:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C990A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cp9NIAdv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SbZTywgr;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cp9NIAdv;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SbZTywgr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7981A1FA79;
	Wed,  4 Nov 2026 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793786529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6Q5OkWW7R8j7PzxRo/f67F7iobuS0oi4ftJmC9oY4s=;
	b=cp9NIAdvNpTcIanQVCIOdm8FqW1epvqhR0RaV74UfcF+ZEvGkfi3Ra6adNv3DINrWpXEwx
	qbdIicyQzS3pgxFXcfE3DoWCL5dXhhxBS4Q4eFFUlbSMQ2T0qNmJOy1pvQFCD1kiO2yMb6
	cd1o9zbYeT6tZZW43d9dkw9boXkoR0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793786529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6Q5OkWW7R8j7PzxRo/f67F7iobuS0oi4ftJmC9oY4s=;
	b=SbZTywgrEykqe7hCA+JIYIN+80Qq2xEv6IMsiRrOsyxijXXZnsgDJgXc0NRXJE3LDSLLHH
	wV+q9gk5Aaf98gCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793786529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6Q5OkWW7R8j7PzxRo/f67F7iobuS0oi4ftJmC9oY4s=;
	b=cp9NIAdvNpTcIanQVCIOdm8FqW1epvqhR0RaV74UfcF+ZEvGkfi3Ra6adNv3DINrWpXEwx
	qbdIicyQzS3pgxFXcfE3DoWCL5dXhhxBS4Q4eFFUlbSMQ2T0qNmJOy1pvQFCD1kiO2yMb6
	cd1o9zbYeT6tZZW43d9dkw9boXkoR0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793786529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6Q5OkWW7R8j7PzxRo/f67F7iobuS0oi4ftJmC9oY4s=;
	b=SbZTywgrEykqe7hCA+JIYIN+80Qq2xEv6IMsiRrOsyxijXXZnsgDJgXc0NRXJE3LDSLLHH
	wV+q9gk5Aaf98gCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF8D7134F0;
	Wed,  4 Nov 2026 10:02:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qZ+4K6AC62qnVwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Nov 2026 10:02:08 +0000
Message-ID: <ee6a6792-3189-4bfa-bb31-2c5bc57f9a3f@suse.de>
Date: Wed, 4 Nov 2026 11:00:47 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: synproxy: prevent unbounded recursion in
 transmit path
To: kernel test robot <lkp@intel.com>, netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 coreteam@netfilter.org, phil@nwl.cc, fw@strlen.de, pablo@netfilter.org
References: <20261103125638.4667-1-fmancera@suse.de>
 <202611040824.Zozbyqd6-lkp@intel.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <202611040824.Zozbyqd6-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/4/26 1:59 AM, kernel test robot wrote:
> Hi Fernando,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on netfilter-nf/main]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-synproxy-prevent-unbounded-recursion-in-transmit-path/20261103-135638
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
> patch link:    https://lore.kernel.org/r/20261103125638.4667-1-fmancera%40suse.de
> patch subject: [PATCH nf] netfilter: synproxy: prevent unbounded recursion in transmit path
> config: s390-defconfig (https://download.01.org/0day-ci/archive/20261104/202611040824.Zozbyqd6-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261104/202611040824.Zozbyqd6-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611040824.Zozbyqd6-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> net/netfilter/nf_synproxy_core.c:24:10: fatal error: 'net/netfilter/nf_recursion.h' file not found
>        24 | #include <net/netfilter/nf_recursion.h>
>           |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     1 error generated.
> 
> 
> vim +24 net/netfilter/nf_synproxy_core.c
> 
>      16	
>      17	#include <net/netfilter/nf_conntrack.h>
>      18	#include <net/netfilter/nf_conntrack_ecache.h>
>      19	#include <net/netfilter/nf_conntrack_extend.h>
>      20	#include <net/netfilter/nf_conntrack_seqadj.h>
>      21	#include <net/netfilter/nf_conntrack_synproxy.h>
>      22	#include <net/netfilter/nf_conntrack_zones.h>
>      23	#include <net/netfilter/nf_synproxy.h>
>    > 24	#include <net/netfilter/nf_recursion.h>
>      25	
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

The patch depends on 
https://lore.kernel.org/netfilter-devel/20261104090224.750548-2-pablo@netfilter.org/

So the robot errors are not very relevant. We can ignore them. The patch 
was tested with that commit as a base.

Thanks,
Fernando.
