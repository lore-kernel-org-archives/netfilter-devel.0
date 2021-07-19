Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8201FC07E9B
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jul 2021 11:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6132D6115B
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jul 2021 11:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhGSLPj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jul 2021 07:15:39 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:42158 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236543AbhGSLPe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jul 2021 07:15:34 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 16JBtbhL019272;
        Mon, 19 Jul 2021 13:55:42 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 923511228F4;
        Mon, 19 Jul 2021 13:55:33 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1626695733; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fs1KZ7aWLSpUdLbGk+YOmz62YIfLF7l9l6PY8jXIspw=;
        b=o5par60wlzBVWkD/0MTcazoOBk2z7fScwktqvDQbWqIKuE6xXUe2bt3nVf12WrinhPH2hJ
        stz4xtyo4Jj0nzDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1626695733; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fs1KZ7aWLSpUdLbGk+YOmz62YIfLF7l9l6PY8jXIspw=;
        b=YPe0UFM07up+xVaxuUewy8VEgOJxdbkDTiHyCurIMCXY4XET/C7hujuIqinwi+5XIEGFCs
        /zUvD+IGKvTXco2r54k23aPtzg4mnpSfVIcN9ar3v85MnBy1DdY9mk/Vi6Sc5RY7izG1nS
        euJ5WZ1oHGMkpnF5wd06DCa4WCqbRAZJ9nbczUOqfGBtTFwz4KMNeCv+GTt8CfDhWPNRfU
        cyWpIRvuIr/fn+rqO0J39zj6yCFwBemGYFySetKphhYxEeROHkvXnp/8C0yJUD9KdsSt5x
        jx5heapOT1gFSpxsQdCC0kBypYgvntJ4xEuMOXNPbWd1OngcFeQS3ZEBDnYWvQ==
Date:   Mon, 19 Jul 2021 13:55:33 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ryoga Saito <proelbtn@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated
 flows
Message-Id: <20210719135533.dac7fc756d64204869a74603@uniroma2.it>
In-Reply-To: <20210715221342.GA19921@salvia>
References: <20210706052548.5440-1-proelbtn@gmail.com>
        <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
        <20210708133859.GA6745@salvia>
        <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
        <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
        <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
        <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
        <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
        <20210713013116.441cc6015af001c4df4f16b0@uniroma2.it>
        <20210715221342.GA19921@salvia>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,
Please see my answers below.

On Fri, 16 Jul 2021 00:13:42 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Andrea,
>
> On Tue, Jul 13, 2021 at 01:31:16AM +0200, Andrea Mayer wrote:
> [...]
> > > On Sun, 11 Jul 2021 16:12:48 +0900
> > > Ryoga Saito <proelbtn@gmail.com> wrote:
> >
> > > >
> > >
> > >
> > > If there are 100 SIDs, but these SIDs are for the same node, the locators
> > > of these SIDs also should be same. so, you can allow SRv6 flows by adding
> > > only single rule.
> >
> > No, you cannot rely on this assumption.
> > Operators can choose to assign different locators to the same node.
> > The document you mention does not prescribe how the SIDs should be allocated on
> > the nodes, nor whether they should be part of one or more locators.
> > Consequently, no one imposes on us that those 100 SIDs must belong all to the
> > same locator.
>
> It is possible to filter 100 SIDs with one single rule and one set,
> even if they are different SIDs.
>

Yes, with ipset you can avoid to increase the cost linearly with the number of
SIDs (at the prize of increased configuration complexity IMO, because the
network administrator should learn to use ipset).

Anyway, our concern is valid for the case in which you have only a single SID
and you are forced to add a single rule to explicitly allow that SID. In fact,
the measurement results we have discussed only consider one SID.


> > > > Have you set the traffic to flow through INPUT to confirm a connection (for
> > > > conntrack)? If this is the only reason, before changing the srv6local
> > > > processing model in such a disruptive way, you can investigate different ways
> > > > to do connection confirmation without going directly through nfhook with INPUT.
> > > > I can help with some hints if you are interested.
> > >
> > > You stated this patch isn't acceptable because NF_HOOK is called even when
> > > End behavior is processing, aren't you?
> >
> > Yes, since the SRv6 processing (seg6_local) is applied to traffic with DAs not
> > necessarily associated with local addresses, it should not pass through INPUT.
>
> See below.
>
> > > So, do you think it’s natural that
> > > NF_HOOK is called *only* when SRv6 behavior is encap/decap operation. The
> > > problem I stated first is that netfilter couldn't track inner flows of
> > > SRv6-encapsulated packets regardless of the status of IPv6 conntrack. If
> > > yes, I will fix and resubmit patch.
> > >
> >
> > Let's consider encap/decap operation. The first important consideration is that
> > encap and decap are two different beasts.
> >
> > Encap (T.Encap) is done in seg6_input (seg6_iptunnel) when a packet is
> > received on the IPv6 receive path and in seg6_output if the packet to be
> > encapsulated is locally generated.
> > Then you will have decap operations that are performed in seg6_local, according
> > to several different decap behaviors.
> >
> > For the moment, let's consider the encap operation applied to a packet received
> > on the IPv6 receive path. If your plan is to call NF_HOOK set on OUTPUT, you
> > will have a similar problem to what I have already described for
> > seg6_local_input (seg6_local). However, this time the OUTPUT is involved rather
> > than the INPUT.
>
> If this is a real concern, then it should be to possible to add new
> hooks such as NF_INET_LWT_LOCAL_IN and NF_INET_LWT_LOCAL_OUT, and extend
> conntrack to also register handlers for those new hooks.

That seems to be a promising approach to be explored; I'm looking forward to
receiving more details on how you will design the packet processing paths for
the various scenarios considering these new hooks.

> > The SRv6 encap operation (seg6_input) for packets received on the IPv6 receive
> > path has been designed and implemented so that packets are not steered through
> > the OUTPUT. For this reason, if you change this design you will cause:
> >
> >  1) possible traffic loss due to some already existing policies in OUTPUT.
> >     In other words you will break existing working configuration;
> >
> >  2) a performance drop in SRv6 encapsulation, which I have measured below.
> >
> > ---
> >
> > I set up a testbed with the purpose of quickly and preliminarily testing the
> > performance (throughput) of a couple of patched processing functions you
> > proposed:
> >
> >   i) SRv6 End (since the seg6_local_input function was patched);
> >
> >  ii) SRv6 T.Encap (seg6_iptunnel).
> >
> >
> > The following scenarios were tested:
> >
> >  1.a) vanilla kernel with a single SRv6 End Behavior and only 1 ip6tables
> >       (filter) rule to fill the INPUT (although not necessary, see below);
> >  
> >  1.b) vanilla kernel with a single SRv6 T.Encap and 0 ip6tables (filter)
> >       rules on OUTPUT;
> >
> >  2.a) patched kernel with a single SRv6 End Behavior and only 1 ip6tables
> >       (filter) rule in INPUT to do accept (necessary to accept the SID);
> >  
> >  2.b) patched kernel with a single SRv6 T.Encap and 0 ip6tables (filter)
> >       rules on OUTPUT.
>
> This is not correct, you are evaluating here the cost of the
> filtering, not the cost of the new hooks. If your concern that the new
> hooks might slow down the IPv6 SRv6 datapath, then you should repeat
> your experiment with and without the patch that adds the hooks.
>

The problem is that the patch forces us to add an explicit accept rule when the
default policy is set to DROP. So, we are measuring the performance penalty for
an existing and typical scenario when filtering is a requirement.

We could also measure as you suggest the performance penalty due to the simple
addition of the hooks. This is an interesting test to be performed that we can
definitely consider. However this gives us the penalty for the "best case" not
even for the "average" one.

> And you should also provide more information on how you're collecting
> any performance number to allow us to scrutinize that your performance
> evaluation is correct.

You are right.
Sorry for not having included details about the test earlier.
Please see below, thanks.

---

Details on Testbed and measurements
===================================

We set up a testbed using the SRPerf framework as discussed in [1]. 
Figure 1 depicts the testbed architecture that we used: it comprises two nodes
denoted as Traffic Generator and Receiver (TGR) and System Under Test (SUT)
respectively. 


+--------------+                           +--------------+
|              |(Sender port)     (IN port)|              |
|     enp6s0f0 +-------------------------->| enp6s0f0     |
|   12:1::1/64 |          10 Gbps          | 12:1::2/64   |
|              |                           |              |
|     TGR      |                           |     SUT      |
|              |          10 Gbps          |              |
|     enp6s0f1 |<--------------------------+ enp6s0f1     |
|   12:2::1/64 |(Receiver port)  (OUT port)| 12:2::2/64   |
|              |                           |              |
+--------------+                           +--------------+

Figure 1: Testbed architecture

The packets are generated by the TGR on the Sender port, enter the SUT from the
IN port, exit the SUT from the OUT port and then they are received back by the
TGR on the Receiver port.

SRPerf measures the maximum throughput, defined as the maximum packet rate in
Packet Per Seconds (pps) for which the packet drop ratio is smaller than or
equal to a given threshold (in our case we chose 0.5%). This is also referred
to as Partial Drop Rate (PDR) at a 0.5% drop ratio (in short PDR@0.5%). Further
details on PDR can be found in [1].

SRPerf uses the TRex [2] generator in order to evaluate the maximum throughput
that can be processed by the SUT Node. The source code of SRPerf is available
at [3].

The testbed is deployed on the CloudLab facilities [4], a flexible
infrastructure dedicated to scientific research on the future of Cloud
Computing. Both the TGR and the SUT are two identical bare metal servers whose
hardware characteristics are shown below:

-----------------------------------------------------------
 CPU:   2x Intel E5-2630 (8 Core 16 Thread) at 2.40 GHz
 RAM:   128 GB of ECC RAM
 Disks: 2x 1.2 TB HDD SAS 6Gbps 10K rpm
        1x 480 GB SSD SAS 6Gbps
 NICs:  Intel Corporation 82599ES 10-Gigabit SFI/SFP
        Intel I350 1Gb Dual Port
-----------------------------------------------------------

Each bare metal server uses the two Intel 82599ES 10-Gigabit network interface
cards to provide back-to-back connectivity between testbed nodes like described
in Figure 1.

On the SUT Node we deploy and execute experiments for studying the proposed
scenarios.
Here we run:
  i) a vanilla Linux kernel 5.13.0, for scenarios 1.a and 2.a;
 ii) the same kernel release of (i) with the patch under discussion
     applied to, for scenarios 1.b and 2.b.

In any case, the SUT Node is configured as an SRv6 Node in an SRv6 Network.


SUT Node and experiment parameters
==================================

On the SUT Node we compiled both the vanilla kernel 5.13.0 and the patched
kernel 5.13.0 using the same config file. In particular, we enabled the
SR-related options as well as the Netfilter support. 

We disabled GRO, GSO and the hardware transmitting and receiving offloading
capabilities on the 82599ES 10-Gigabit network interfaces that are used to
connect the two testbed servers. We changed the IRQ settings so that all the
queues of the 10-Gigabit NICs were served by a single CPU and Hyper-Threading
was disabled. 


Scenarios 1.a, 2.a (SRv6 End behavior)
-------------------------------------

Two experiments have been carried out respectively for scenario 1.a and 2.a.
Either way, they both make use of the same SUT configuration and process the
same kind of traffic generated by the TGR.

TGR generates IPv6+SRH traffic which is sent directly to the SUT IN port. Every
single packet sent by the TGR is has the same format:


+-----------+------------+-----+------------+-----+-----------+
|           |            |     |            |     |           |
| MAC Layer | IPv6 Outer | SRH | IPv6 Inner | UDP | Raw bytes |
|           |            |     |            |     |           |
+-----------+------------+-----+------------+-----+-----------+

/-------------------------- 162 bytes ------------------------/

Where:
 - IPv6 Outer SA: 1:2:1::1, DA: f1::
 - SRH SID List: f1::,f2::
 - IPv6 Inner SA: 1:2:1::1, IPv6 DA: b::2 
 - UDP sport: 50701, dport: 5001 | Raw bytes (16 Bytes)

In the SUT Node, a single SRv6 End Behavior is set for the SID f1::

On SUT Node, incoming traffic at enp6s0f0 (IN port) matches the IPv6 DA with
the SID f1:: and the SRv6 End Behavior is executed. After that, processed
packets are then sent back to the TGR through the enp6s0f1 (OUT port).

Please note that SIDs f1:: and f2:: are *not* assigned to any interface of the
SUT.

The SUT Node is also configured with some firewall policies. The default rule
for IPv6 INPUT is set as DROP and an explicit ACCEPT rule for SID f1:: is also
configured.


Scenarios 1.b, 2.b (SRv6 T.Encap Behavior)
------------------------------------------

Two experiments have been carried out respectively for scenario 1.b and 2.b.
Either way, they both make use of the same SUT configuration and process the
same kind of traffic generated by the TGR.

TGR generates plain IPv6 traffic which is sent directly to the SUT IN port.
Every single packet sent by the TGR follows the same format:

+-----------+------------+-----+-----------+
|           |            |     |           |
| MAC Layer |    IPv6    | UDP | Raw bytes |
|           |            |     |           |
+-----------+------------+-----+-----------+

/----------------- 82 bytes ---------------/

Where:
 - IPv6 SA: 1:2:1::1, IPv6 DA: b::2 
 - UDP sport: 39892, dport: 5001 | Raw bytes (16 Bytes)


In the SUT Node, a single SRv6 T.Encap Behavior is set for the IPv6 DA b::2.

On SUT Node, incoming traffic at enp6s0f0 (IN port) matches the IPv6 DA with
b::2 and the SRv6 T.Encap Behavior is executed. Then, the whole
IPv6+SRH packet (SID List [f1::]) is sent back to the TGR through the
enp6s0f1 (OUT Port).

Please note that b::2 and SID f1:: are *not* assigned to any interface of the
SUT.

The SUT Node does not restrict the locally generated traffic.
The default OUTPUT policy for IPv6 is set to ACCEPT.

---

[1] A. Abdelsalam et al. "SRPerf: a Performance Evaluation Framework for
    IPv6 Segment Routing", IEEE Transactions on Network and Service
    Management (Volume: 18, Issue: 2, June 2021). 
    Available: https://arxiv.org/pdf/2001.06182.pdf

[2] TRex realistic traffic generator. https://trex-tgn.cisco.com/

[3] SRPerf - Performance Evaluation Framework for Segment Routing.
    Available: https://github.com/SRouting/SRPerf

[4] CloudLab home page. Available: https://www.cloudlab.us/
