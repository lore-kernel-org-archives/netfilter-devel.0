From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/6] Add net namespace support for ipt_CLUSTERIP
Date: Tue, 1 Oct 2013 13:05:05 +0200
Message-ID: <20131001110505.GA7180@localhost>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:59289 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752743Ab3JALFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:05:11 -0400
Content-Disposition: inline
In-Reply-To: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Gao,

On Wed, Sep 25, 2013 at 03:38:43PM +0800, Gao feng wrote:
> This patchset adds net namespace support for ipt_CLUSTERIP,
> makes clusterip_configs,clusterip_lock and clusterip_procdir
> per net namespace, and allow users in container to operate
> the proper pernet resource of CLUSTERIP.
> 
> Gao feng (6):
>   ipt_CLUSTERIP: make proc directory per net namespace
>   ipt_CLUSTERIP: make clusterip_list per net namespace
>   ipt_CLUSTERIP: make clusterip_lock per net namespace
>   ipt_CLUSTERIP: add parameter net in clusterip_config_find_get
>   ipt_CLUSTERIP: create proc entry under proper ipt_CLUSTERIP directory
>   ipt_CLUSTERIP: use proper net namespace to operate CLUSTERIP

CLUSTERIP is a subset of the cluster match. The cluster match allows
gateway configurations, which are not possible with CLUSTERIP.

If you really need these, I can take them. But I'd be happy if you can
check the cluster match to make sure there are no issue regarding net
namespaces.

Let me know.
