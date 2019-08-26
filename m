Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF91C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 07:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89E0A206BA
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 07:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfHZH25 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 03:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbfHZH2y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 03:28:54 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF0858125C
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2019 07:28:53 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id f11so9079003edn.9
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2019 00:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DdSO2USv64eYSC6HI4qZiTe/SEXLb6QkOZq2LP5/MRk=;
        b=htZ7HZI16KIy23AiiFUkLbnfYiHse/LoT2PDonTxsna1nrsHn8oZ10yPrnIFNyav90
         Slfg5UGTFeVU1sXzIwiDnh/fj8YmGwPflmklUQAaVmrcyMBbmzfxsUmJtEE1ZlNAw3X6
         eLyCktlu6ac5tFXX5EZ1VDWf68uOdbNsUoaC07YBebZKiozd1OiaG0DWNRHbQR45BHu1
         Y4RVxxE4trB0V7gp6zGcwpupiRrVtM6ioCei/IZnpz+1fg9wf77cOJQU0j9IaW53NV79
         gJ/T5aQtM/81NF/W1TRA8e4zFsEh7Z1iZ2Xihv7HWrMFvQY59W2+1EpJoNDNEdwuo0dC
         UnOg==
X-Gm-Message-State: APjAAAVOSx9NZAkHQnKuCQ3xBN/BzCKtVY53TczhIIIKnIzBH9wHlLnt
        vsHsHDvED/d3TPtv5alcgfdO62XzynV04aTDPFg9bpzkvHQByN3ifHl36pCX1Sh72rJw0t/FhC6
        dVP+/nXxSo5a++XBxBihL1qo1wrDs
X-Received: by 2002:a17:907:2091:: with SMTP id pv17mr15213655ejb.157.1566804532537;
        Mon, 26 Aug 2019 00:28:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPC3UtB1fTuC+zIQDOCT/LnBU0/COuV+1NpIGhJAtgp0DT5clXX0I5di7qIrxh7bEfrcJb4g==
X-Received: by 2002:a17:907:2091:: with SMTP id pv17mr15213645ejb.157.1566804532320;
        Mon, 26 Aug 2019 00:28:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id d3sm2729144ejp.77.2019.08.26.00.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 00:28:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D5DC4181C2E; Mon, 26 Aug 2019 09:28:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Akshat Kakkar <akshat.1984@gmail.com>
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: Unable to create htb tc classes more than 64K
In-Reply-To: <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com> <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com> <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com> <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com> <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com> <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com> <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com> <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com> <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 26 Aug 2019 09:28:50 +0200
Message-ID: <87k1b0l70t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 8/25/19 7:52 PM, Cong Wang wrote:
>> On Wed, Aug 21, 2019 at 11:00 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>>>
>>> On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>> I am using ipset +  iptables to classify and not filters. Besides, if
>>>>> tc is allowing me to define qdisc -> classes -> qdsic -> classes
>>>>> (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
>>>>> then how can those lowest child classes be actually used or consumed?
>>>>
>>>> Just install tc filters on the lower level too.
>>>
>>> If I understand correctly, you are saying,
>>> instead of :
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000001 fw flowid 1:10
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000002 fw flowid 1:20
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000003 fw flowid 2:10
>>> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
>>> 0x00000004 fw flowid 2:20
>>>
>>>
>>> I should do this: (i.e. changing parent to just immediate qdisc)
>>> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
>>> fw flowid 1:10
>>> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
>>> fw flowid 1:20
>>> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
>>> fw flowid 2:10
>>> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
>>> fw flowid 2:20
>> 
>> 
>> Yes, this is what I meant.
>> 
>> 
>>>
>>> I tried this previously. But there is not change in the result.
>>> Behaviour is exactly same, i.e. I am still getting 100Mbps and not
>>> 100kbps or 300kbps
>>>
>>> Besides, as I mentioned previously I am using ipset + skbprio and not
>>> filters stuff. Filters I used just to test.
>>>
>>> ipset  -N foo hash:ip,mark skbinfo
>>>
>>> ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
>>> ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
>>> ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
>>> ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20
>>>
>>> iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio
>> 
>> Hmm..
>> 
>> I am not familiar with ipset, but it seems to save the skbprio into
>> skb->priority, so it doesn't need TC filter to classify it again.
>> 
>> I guess your packets might go to the direct queue of HTB, which
>> bypasses the token bucket. Can you dump the stats and check?
>
> With more than 64K 'classes' I suggest to use a single FQ qdisc [1], and
> an eBPF program using EDT model (Earliest Departure Time)
>
> The BPF program would perform the classification, then find a data structure
> based on the 'class', and then update/maintain class virtual times and skb->tstamp
>
> TBF = bpf_map_lookup_elem(&map, &classid);
>
> uint64_t now = bpf_ktime_get_ns();
> uint64_t time_to_send = max(TBF->time_to_send, now);
>
> time_to_send += (u64)qdisc_pkt_len(skb) * NSEC_PER_SEC / TBF->rate;
> if (time_to_send > TBF->max_horizon) {
>     return TC_ACT_SHOT;
> }
> TBF->time_to_send = time_to_send;
> skb->tstamp = max(time_to_send, skb->tstamp);
> if (time_to_send - now > TBF->ecn_horizon)
>     bpf_skb_ecn_set_ce(skb);
> return TC_ACT_OK;
>
> tools/testing/selftests/bpf/progs/test_tc_edt.c shows something similar.
>
>
> [1]  MQ + FQ if the device is multi-queues.
>
>    Note that this setup scales very well on SMP, since we no longer are forced
>  to use a single HTB hierarchy (protected by a single spinlock)

Wow, this is very cool! Thanks for that walk-through, Eric :)

-Toke
