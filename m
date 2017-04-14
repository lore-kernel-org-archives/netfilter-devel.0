From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf v2] net/openvswitch: Delete conntrack entry clashing
 with an expectation.
Date: Fri, 14 Apr 2017 12:18:19 +0800
Message-ID: <CAML_gOeTJoEZPtzMdd0oBg5EES6T5PRZKVjxpmf9X6u7ba0ngA@mail.gmail.com>
References: <1492124719-123107-1-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, joe@ovn.org
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34280 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdDNESV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2017 00:18:21 -0400
Received: by mail-vk0-f50.google.com with SMTP id z204so35996460vkd.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 21:18:20 -0700 (PDT)
In-Reply-To: <1492124719-123107-1-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jarno,

2017-04-14 7:05 GMT+08:00 Jarno Rajahalme <jarno@ovn.org>:
[...]
> +               h = nf_conntrack_find_get(net, zone, &tuple);
> +               if (h) {
> +                       struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
> +
> +                       if (nf_ct_is_confirmed(ct))

If the _ct_ could be got by nf_conntrack_find_get(),  it means that
the _ct_ have
been confirmed already, so the judgement "if (nf_ct_is_confirmed(ct))" seems
unnecessary.

> +                               nf_ct_delete(ct, 0, 0);
> +                       nf_conntrack_put(&ct->ct_general);
> +               }
> +       }
