From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: net/netfilter/nf_log.c:373:38: error: 'struct netns_nf' has no
 member named 'proc_netfilter'
Date: Mon, 06 May 2013 11:19:49 +0800
Message-ID: <51872155.6060605@cn.fujitsu.com>
References: <517f72cc.fRNNPd+CdJx0ePvu%fengguang.wu@intel.com> <20130430140552.GA8837@localhost> <20130430175951.GA28292@localhost> <20130430180118.GA28315@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, kbuild-all@01.org,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3EFDSF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 May 2013 23:18:05 -0400
In-Reply-To: <20130430180118.GA28315@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/01/2013 02:01 AM, Pablo Neira Ayuso wrote:
> On Tue, Apr 30, 2013 at 10:05:52PM +0800, Fengguang Wu wrote:
>> > 
>> > FYI, kernel build failed on
>> > 
>> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
>> > head:   d7c35d45ce991ae01b6008abef120173fc9c3814
>> > commit: dba554cc481ab6582202dd954f927e7657ee453a Merge remote-tracking branch 'net-next/master'
>> > date:   5 hours ago
>> > config: i386-randconfig-r05-0429 (attached as .config)
>> > 
>> > All error/warnings:
>> > 
>> >    In file included from net/netfilter/nf_log.c:4:0:
>> >    include/linux/proc_fs.h:58:20: error: redefinition of 'proc_set_size'
>> >    include/linux/proc_fs.h:51:20: note: previous definition of 'proc_set_size' was here
>> >    include/linux/proc_fs.h: In function 'proc_net_mkdir':
>> >    include/linux/proc_fs.h:69:2: error: implicit declaration of function 'proc_mkdir_data' [-Werror=implicit-function-declaration]
>> >    include/linux/proc_fs.h:69:2: warning: return makes pointer from integer without a cast [enabled by default]
>> >    net/netfilter/nf_log.c: In function 'nf_log_net_init':
>>>> > >> net/netfilter/nf_log.c:373:38: error: 'struct netns_nf' has no member named 'proc_netfilter'
>> >    net/netfilter/nf_log.c: In function 'nf_log_net_exit':
>>>> > >> net/netfilter/nf_log.c:381:37: error: 'struct netns_nf' has no member named 'proc_netfilter'
>> >    cc1: some warnings being treated as errors
> I have attached a patch to resolve the issue. Thanks.
> 
> 
> 0001-netfilter-fix-compilation-without-CONFIG_PROC_FS.patch
> 
> 
>>From 4c5f54174742db8227ef117c78710a45b25368ce Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Tue, 30 Apr 2013 19:50:54 +0200
> Subject: [PATCH] netfilter: nf_{log,queue}: fix compilation without CONFIG_PROC_FS
> 
> This patch fixes the following compilation error:
> 
> net/netfilter/nf_log.c:373:38: error: 'struct netns_nf' has no member named 'proc_netfilter'
> 
> if procfs is not set.
> 
> The netns support for nf_log, nfnetlink_log and nfnetlink_queue_core
> requires CONFIG_PROC_FS in the removal path of their respective
> /proc interface since net->nf.proc_netfilter is undefined in that
> case.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Looks good to me, thanks for your report and fix.

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
