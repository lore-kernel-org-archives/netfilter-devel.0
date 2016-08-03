From: Fengguang Wu <lkp@intel.com>
Subject: Re: [kbuild-all] [PATCH nf-next] netfilter: use_nf_conn_expires
 helper in more places
Date: Wed, 3 Aug 2016 21:26:45 +0800
Message-ID: <20160803132645.GA31639@wfg-t540p.sh.intel.com>
References: <1470185107-17332-1-git-send-email-fw@strlen.de>
 <201608031302.wzV7WZoE%fengguang.wu@intel.com>
 <20160803125319.GB30905@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: netfilter-devel@vger.kernel.org, kbuild-all@01.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbcHCN0w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2016 09:26:52 -0400
Content-Disposition: inline
In-Reply-To: <20160803125319.GB30905@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 03, 2016 at 02:53:19PM +0200, Florian Westphal wrote:
>kbuild test robot <lkp@intel.com> wrote:
>> Hi Florian,
>>
>> [auto build test ERROR on nf-next/master]
>>
>> url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-use_nf_conn_expires-helper-in-more-places/20160803-124239
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
>> config: i386-randconfig-x018-201631 (attached as .config)
>> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=i386
>>
>> All error/warnings (new ones prefixed by >>):
>>
>>    net/netfilter/nf_conntrack_standalone.c: In function 'ct_seq_show':
>> >> net/netfilter/nf_conntrack_standalone.c:227:6: error: implicit declaration of function 'nf_ct_expires' [-Werror=implicit-function-declaration]
>>          nf_ct_expires(ct)  / HZ);
>>          ^~~~~~~~~~~~~
>
>It would be nice to see the sha1 of 'master'.

It's this SHA1:

https://github.com/0day-ci/linux/commit/4b512e1c1f8de6b9ceb796ecef8658e0a083cab7

Which you may find out by following this URL:

>> url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-use_nf_conn_expires-helper-in-more-places/20160803-124239

>Builds fine with this config for me; nf-next master is
>
>commit 6a492b0f23d28e1f946cdf08e54617484400dafb
>Merge: d85486d 354a086
>Author: Linus Torvalds <torvalds@linux-foundation.org>
>Date:   Wed Jul 27 14:48:37 2016 -0700
>
>I guess this was with an older tree...?

Yeah the tested base is the previous version and older than that one.

Thanks,
Fengguang
