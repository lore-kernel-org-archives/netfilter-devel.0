From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH nf-next 0/6] Add net namespace support for ipt_CLUSTERIP
Date: Fri, 04 Oct 2013 16:51:39 +0800
Message-ID: <524E819B.1080306@cn.fujitsu.com>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com> <20131001110505.GA7180@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27796 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3JDIuc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:50:32 -0400
In-Reply-To: <20131001110505.GA7180@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 10/01/2013 07:05 PM, Pablo Neira Ayuso wrote:
> Hi Gao,
> 
> On Wed, Sep 25, 2013 at 03:38:43PM +0800, Gao feng wrote:
>> This patchset adds net namespace support for ipt_CLUSTERIP,
>> makes clusterip_configs,clusterip_lock and clusterip_procdir
>> per net namespace, and allow users in container to operate
>> the proper pernet resource of CLUSTERIP.
>>
>> Gao feng (6):
>>   ipt_CLUSTERIP: make proc directory per net namespace
>>   ipt_CLUSTERIP: make clusterip_list per net namespace
>>   ipt_CLUSTERIP: make clusterip_lock per net namespace
>>   ipt_CLUSTERIP: add parameter net in clusterip_config_find_get
>>   ipt_CLUSTERIP: create proc entry under proper ipt_CLUSTERIP directory
>>   ipt_CLUSTERIP: use proper net namespace to operate CLUSTERIP
> 
> CLUSTERIP is a subset of the cluster match. The cluster match allows
> gateway configurations, which are not possible with CLUSTERIP.

Yes, but seems ipt_CLUSTERIP is more popular.(from the result I seach through google)

> 
> If you really need these, I can take them. But I'd be happy if you can
> check the cluster match to make sure there are no issue regarding net
> namespaces.
> 

I looked into the codes of cluster match module, and did some simple test,
it has no need to do with net namespace. works well in container :)

Thanks
