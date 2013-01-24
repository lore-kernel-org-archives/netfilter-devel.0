From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [nf-next:master 10/20] net/netfilter/nf_conntrack_standalone.c:566:2:
 error: 'nf_ct_netfilter_header' undeclared
Date: Thu, 24 Jan 2013 08:46:53 +0800
Message-ID: <5100847D.8050303@cn.fujitsu.com>
References: <50ffea92.W3YbcwYaFKlgs8cR%fengguang.wu@intel.com> <20130123141522.GA17264@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab3AXAqT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:46:19 -0500
In-Reply-To: <20130123141522.GA17264@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013/01/23 22:15, Pablo Neira Ayuso wrote:
> On Wed, Jan 23, 2013 at 09:50:10PM +0800, kbuild test robot wrote:
>> tree:   git://150.214.188.80/nf-next master
>> head:   c296bb4d5d417d466c9bcc8afef68a3db5449a64
>> commit: f94161c1bbdf7af11729cf106b4452f2432448e0 [10/20] netfilter: nf_conntrack: move initialization out of pernet operations
>> config: x86_64-randconfig-x974 (attached as .config)
>>
>> All error/warnings:
>>
>>    net/netfilter/nf_conntrack_standalone.c: In function 'nf_conntrack_standalone_init':
>>>> net/netfilter/nf_conntrack_standalone.c:566:2: error: 'nf_ct_netfilter_header' undeclared (first use in this function)
>>    net/netfilter/nf_conntrack_standalone.c:566:2: note: each undeclared identifier is reported only once for each function it appears in
>>>> net/netfilter/nf_conntrack_standalone.c:567:41: error: 'nf_ct_netfilter_table' undeclared (first use in this function)
>>    net/netfilter/nf_conntrack_standalone.c: In function 'nf_conntrack_standalone_fini':
>>    net/netfilter/nf_conntrack_standalone.c:591:30: error: 'nf_ct_netfilter_header' undeclared (first use in this function)
> 
> Patch attached to fix this. Thanks kbuild test robot.
> 

Oops,it's my fault.

Thanks you guys!
