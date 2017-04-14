From: Jarno Rajahalme <jarno@ovn.org>
Subject: Re: [PATCH nf v2] net/openvswitch: Delete conntrack entry clashing with an expectation.
Date: Fri, 14 Apr 2017 09:49:21 -0700
Message-ID: <1FF3ABD3-9D31-4A6A-B906-0A6308E06D1E@ovn.org>
References: <1492124719-123107-1-git-send-email-jarno@ovn.org> <CAML_gOeTJoEZPtzMdd0oBg5EES6T5PRZKVjxpmf9X6u7ba0ngA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, joe@ovn.org
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:59056 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752897AbdDNQtf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2017 12:49:35 -0400
In-Reply-To: <CAML_gOeTJoEZPtzMdd0oBg5EES6T5PRZKVjxpmf9X6u7ba0ngA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> On Apr 13, 2017, at 21:18, Liping Zhang <zlpnobody@gmail.com> wrote:
> 
> Hi Jarno,
> 
> 2017-04-14 7:05 GMT+08:00 Jarno Rajahalme <jarno@ovn.org>:
> [...]
>> +               h = nf_conntrack_find_get(net, zone, &tuple);
>> +               if (h) {
>> +                       struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
>> +
>> +                       if (nf_ct_is_confirmed(ct))
> 
> If the _ct_ could be got by nf_conntrack_find_get(),  it means that
> the _ct_ have
> been confirmed already, so the judgement "if (nf_ct_is_confirmed(ct))" seems
> unnecessary.
> 

You are right, thanks for pointing this out! Will send v3 later today,

  Jarno

>> +                               nf_ct_delete(ct, 0, 0);
>> +                       nf_conntrack_put(&ct->ct_general);
>> +               }
>> +       }

