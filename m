From: Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net] nftables: use list_for_each_entry_safe_reverse to
 traversal commit_list in nf_tables_abort
Date: Thu, 10 Dec 2015 00:24:21 +0800
Message-ID: <CADvbK_dmqu4aFhQa2FVu=_RAVrSZ6qSixfGN9EM2dZ20CeQqUA@mail.gmail.com>
References: <15bcb964221e1a9498e901417d020609cd5aac65.1449485287.git.lucien.xin@gmail.com>
	<20151209140330.GA1695@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: network dev <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>,
	fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:32800 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbbLIQYW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 11:24:22 -0500
In-Reply-To: <20151209140330.GA1695@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 9, 2015 at 10:03 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Dec 07, 2015 at 06:48:07PM +0800, Xin Long wrote:
>> when we use 'nft -f' to sumbit rules, it will build multiple rules into
>> one netlink skb to send to kernel, kernel will process them one by one.
>> meanwhile, it add the trans into commit_list to record every commit.
>> if one of them's return value is -EAGAIN, status |= NFNL_BATCH_REPLAY
>> will be marked. after all the process is done. it will roll back all the
>> commits.
>>
>> now kernel use list_add_tail to add trans to commit, and use
>> list_for_each_entry_safe to roll back. which means the order of adding
>> and rollback is the same. that will cause some cases cannot work well,
>> even trigger call trace, like:
>>
>> 1. add a set into table foo  [return -EAGAIN]:
>>    commit_list = 'add set trans'
>> 2. del foo:
>>    commit_list = 'add set trans' -> 'del set trans' -> 'del tab trans'
>> then nf_tables_abort will be called to roll back:
>> firstly process 'add set trans':
>>                    case NFT_MSG_NEWSET:
>>                         trans->ctx.table->use--;
>>                         list_del_rcu(&nft_trans_set(trans)->list);
>>
>>   it will del the set from the table foo, but it has removed when del
>>   table foo [step 2], then the kernel will panic.
>>
>> the right order of rollback should be:
>>   'del tab trans' -> 'del set trans' -> 'add set trans'.
>> which is opposite with commit_list order.
>>
>> so fix it by rolling back commits with reverse order in nf_tables_abort.
>
>
> You're reporting a kernel panic.
>
> Could you please provide a sequence of commands to reproduce it with
> the existing code?
>
> Thanks.

the reproduce is a kind of long, do i need to repost this patch with
the reproduce?
