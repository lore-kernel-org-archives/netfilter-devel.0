From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] man: update the manpage for cluster match
Date: Mon, 07 Oct 2013 17:50:01 +0800
Message-ID: <525283C9.9010106@cn.fujitsu.com>
References: <1381134176-18168-1-git-send-email-gaofeng@cn.fujitsu.com> <20131007093357.GA5755@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3809 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3JGJsx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:48:53 -0400
In-Reply-To: <20131007093357.GA5755@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/07/2013 05:33 PM, Pablo Neira Ayuso wrote:
> On Mon, Oct 07, 2013 at 04:22:56PM +0800, Gao feng wrote:
>> --h-length,--mangle-mac-s,--mangle-mac-d,--destination-mac
>> are not supported by arptables now,and the chain name is IN/OUT.
> 
> I guess you're using jf's arptables version. The syntax is correct for
> mainstream version.
> 

Yes, it comes from arptables_jf-0.0.8-32.fc19.x86_64.

> I think it's worth to add a comment in the manpage, many people may be
> confused with this and believe that arptables is broken.
> 

You can regard this patch as a notification.
I'm glad to see your patch. :)
