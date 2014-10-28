From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH v2 3/3] Make use of pr_fmt where applicable
Date: Tue, 28 Oct 2014 18:16:47 -0200
Message-ID: <544FF9AF.10105@redhat.com>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414175014.git.mleitner@redhat.com> <65a78d556ae1682fdf38f8bdb424204ee72d1ad9.1414175014.git.mleitner@redhat.com> <20141027222353.GC5998@salvia> <544F9347.6020704@redhat.com> <544FF4EF.5060509@redhat.com> <20141028201220.GA26565@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaJ1UQy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:16:54 -0400
In-Reply-To: <20141028201220.GA26565@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28-10-2014 18:12, Pablo Neira Ayuso wrote:
> On Tue, Oct 28, 2014 at 05:56:31PM -0200, Marcelo Ricardo Leitner wrote:
>> Hi Pablo,
>>
>> While we are at this, what about this one, does it really have to be a BUG() one?
>>
>> __build_packet_message()
>> ...
>>      if (data_len) {
>>          struct nlattr *nla;
>>          int size = nla_attr_size(data_len);
>>
>>          if (skb_tailroom(inst->skb) < nla_total_size(data_len))
>>              goto nla_put_failure;           <-- already changed
>>
>>          nla = (struct nlattr *)skb_put(inst->skb, nla_total_size(data_len));
>>          nla->nla_type = NFULA_PAYLOAD;
>>          nla->nla_len = size;
>>
>>          if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
>>              BUG();         <--
>>      }
>>
>> Seems we could just put a goto nla_put_failure there too instead of
>> bringing everything down. skb_copy_bits will only fail if we try to
>> copy too much from the skb.. We could leave a WARN_ONCE in there if
>> the idea is to catch nasty bugs in there. WDYT? I'm thinking in just
>> sticking with a goto in there too.
>
> I think this is most likely catching a malformed skbuff coming from
> the driver, in that case we shouldn't go further. There's similar
> handling in other part of the kernel.
>
> This may also trigger the BUG() if data_len is miscalculated as you
> said, but that seems less likely to happen to me.
>
> I would leave that one as it is.

Cool, thanks.

Marcelo

