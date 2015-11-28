From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] null pointer exception
Date: Sat, 28 Nov 2015 12:20:05 +0000
Message-ID: <20151128122004.GA17106@macbook.localdomain>
References: <0A900C78B9F2324AB7F4F7A51D1A2F857797855C@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Linmujia <linmujia@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58014 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbK1MUO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 07:20:14 -0500
Content-Disposition: inline
In-Reply-To: <0A900C78B9F2324AB7F4F7A51D1A2F857797855C@szxema505-mbs.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28.11, Linmujia wrote:
> Hi,I think I find out why my last patch stoped the execution of the tool,
> If "stmt_reject_gen_dependency" do not get any payload (payload=null) , it can not call "payload_gen_dependency ",it will cause null pointer exception.
> 

It is really unclear what you're trying to do. You've sent multiple patches
of which every single one was competely wrong and randomly changing return
values.

How about you start by explaining what you're trying to do?
