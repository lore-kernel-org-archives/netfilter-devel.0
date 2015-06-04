From: Paul Aitken <paitken@brocade.com>
Subject: Re: [PATCH] Optimise nfq_queue_cb
Date: Thu, 4 Jun 2015 10:13:01 +0100
Message-ID: <5570169D.2030708@brocade.com>
References: <md5:KJl5IfCAjtPWb+o93HAjWA==> <556C2438.3060203@brocade.com> <20150601110359.GB4002@salvia> <556C3FB8.6070608@brocade.com> <20150601173403.GA25171@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:51679 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbbFDJOE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2015 05:14:04 -0400
In-Reply-To: <20150601173403.GA25171@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo, somehow tabs had been converted to spaces.

Let me try again...

P.


On 01/06/15 18:34, Pablo Neira Ayuso wrote:
> On Mon, Jun 01, 2015 at 12:19:20PM +0100, Paul Aitken wrote:
>> Pablo,
>>
>>> On Mon, Jun 01, 2015 at 10:22:00AM +0100, Paul Aitken wrote:
>>>> ct and myct have both already been checked for non-NULL,
>>>> so there's no need to check either of them again later.
>>>>
>>>> Signed-off-by: Paul Aitken <paitken@brocade.com>
>>>> ---
>>>>   src/cthelper.c | 8 +++-----
>>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/src/cthelper.c b/src/cthelper.c
>>>> index 15d5126..6537515 100644
>>>> --- a/src/cthelper.c
>>>> +++ b/src/cthelper.c
>>>> @@ -325,14 +325,12 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
>>>>   	if (pkt_verdict_issue(helper, myct, queue_num, id, verdict, pktb) < 0)
>>>>   		goto err_pktb;
>>>> -	if (ct != NULL)
>>>> -		nfct_destroy(ct);
>>>> +	nfct_destroy(ct);
>>> void nfct_destroy(struct nf_conntrack *ct)
>>> {
>>>          assert(ct != NULL);
>>>          ...
>>>
>>> the library doesn't allow NULL pointers.
>> ct was already checked for non-NULL when it was assigned around line 297:
>>
>>          ct = nfct_new();
>>          if (ct == NULL)
>>                  goto err;
>>
>> - so ct cannot be NULL at line 325.
> Right, makes sense. However, your patch doesn't apply here for some
> reason:
>
> $ git am Optimise-nfq_queue_cb.patch
> Applying: Optimise nfq_queue_cb
> error: patch failed: src/cthelper.c:325
> error: src/cthelper.c: patch does not apply
> Patch failed at 0001 Optimise nfq_queue_cb
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort"

