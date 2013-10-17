From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/6] Add net namespace support for ipt_CLUSTERIP
Date: Thu, 17 Oct 2013 10:46:45 +0200
Message-ID: <20131017084645.GA8791@localhost>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
 <20131001110505.GA7180@localhost>
 <524E819B.1080306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58512 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab3JQIqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:46:50 -0400
Content-Disposition: inline
In-Reply-To: <524E819B.1080306@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 04, 2013 at 04:51:39PM +0800, Gao feng wrote:
> Hi Pablo,
> 
> On 10/01/2013 07:05 PM, Pablo Neira Ayuso wrote:
> > Hi Gao,
> > 
> > On Wed, Sep 25, 2013 at 03:38:43PM +0800, Gao feng wrote:
> >> This patchset adds net namespace support for ipt_CLUSTERIP,
> >> makes clusterip_configs,clusterip_lock and clusterip_procdir
> >> per net namespace, and allow users in container to operate
> >> the proper pernet resource of CLUSTERIP.
> >>
> >> Gao feng (6):
> >>   ipt_CLUSTERIP: make proc directory per net namespace
> >>   ipt_CLUSTERIP: make clusterip_list per net namespace
> >>   ipt_CLUSTERIP: make clusterip_lock per net namespace
> >>   ipt_CLUSTERIP: add parameter net in clusterip_config_find_get
> >>   ipt_CLUSTERIP: create proc entry under proper ipt_CLUSTERIP directory
> >>   ipt_CLUSTERIP: use proper net namespace to operate CLUSTERIP
> > 
> > CLUSTERIP is a subset of the cluster match. The cluster match allows
> > gateway configurations, which are not possible with CLUSTERIP.
> 
> Yes, but seems ipt_CLUSTERIP is more popular.(from the result I seach through google)

Fair enough, applied to nf-next.
 
> > If you really need these, I can take them. But I'd be happy if you can
> > check the cluster match to make sure there are no issue regarding net
> > namespaces.
> > 
> 
> I looked into the codes of cluster match module, and did some simple test,
> it has no need to do with net namespace. works well in container :)

thanks a lot of checking Gao.
