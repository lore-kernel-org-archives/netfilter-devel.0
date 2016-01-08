From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?Q?H_3=2F3_nf-next=5D_netfilter?= =?utf-8?Q?=3A?= nf_ct_helper: Add
 nf_conntrack_helpers_register()
Date: Fri, 8 Jan 2016 13:22:27 +0100
Message-ID: <20160108122227.GA3384@salvia>
References: <1451908093-3754-3-git-send-email-pablo@netfilter.org>
 <201601041946.QoN8MveC%fengguang.wu@intel.com>
 <BAY403-EAS25258E748DF4B612DF8D4AF95F20@phx.gbl>
 <20160104161550.GB1303@salvia>
 <20160104164656.GA2135@salvia>
 <BAY403-EAS3732A77CAF9E1DCE79ED89395F20@phx.gbl>
 <BAY403-EAS181F9CE879F779A8E160FD195F50@phx.gbl>
 <BAY403-EAS167CF4DCA9B031F6AEFDF7F95F60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57828 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbcAHMWf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 07:22:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 60706B5A620
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:22:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 51497DA7E0
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:22:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 761A3DA795
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:22:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <BAY403-EAS167CF4DCA9B031F6AEFDF7F95F60@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 08, 2016 at 08:18:02AM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> I know how to enhance it now, and it must be converted.
> Because there is one bug in the codes when using
> nf_conntrack_helpers_register.
> 
> Take the following codes as an example
>     for (i = 0; i < ports_c; i++) {
>         nf_ct_helper_init(&ftp[i][0], AF_INET, IPPROTO_TCP, "ftp",
>                   FTP_PORT, ports[i], &ftp_exp_policy, 0,
>                   sizeof(struct nf_ct_ftp_master), help,
>                   nf_ct_ftp_from_nlattr, THIS_MODULE);
>         nf_ct_helper_init(&ftp[i][1], AF_INET6, IPPROTO_TCP, "ftp",
>                   FTP_PORT, ports[i], &ftp_exp_policy, 0,
>                   sizeof(struct nf_ct_ftp_master), help,
>                   nf_ct_ftp_from_nlattr, THIS_MODULE);
>     }   
>     ret = nf_conntrack_helpers_register(&ftp[0][0], ports_c * 2);
> 
> When init the helper, we initialized the ftp[i][0], ftp[i][1], they are not
> continuous.
> So it bring one bug when use nf_conntrack_helpers_register(&ftp[0][0],
> ports_c * 2);
> 
> I will fix it later

Then, I going to keep these patchset back in this round, sorry.

Please, take over my 2/3 and 3/3 iteration, fix them and resubmit.

Thanks.
