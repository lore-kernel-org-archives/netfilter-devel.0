From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_nat_snmp_basic: use asn1 decoder library
Date: Sat, 18 Nov 2017 16:59:25 +0900
Message-ID: <CAMArcTVzc_rs1Ms95BxEJ78RjPgsc-bFgD7OdU1tnT7-9CmuKA@mail.gmail.com>
References: <20171107145836.29917-1-ap420073@gmail.com> <20171113135020.GA21079@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:43811 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162999AbdKRH71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Nov 2017 02:59:27 -0500
Received: by mail-qk0-f177.google.com with SMTP id j202so2100026qke.10
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2017 23:59:26 -0800 (PST)
In-Reply-To: <20171113135020.GA21079@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo

I apologize for late reply.


2017-11-13 22:50 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Hi Taehee,
>
> On Tue, Nov 07, 2017 at 11:58:36PM +0900, Taehee Yoo wrote:
>> The basic SNMP ALG parse snmp ASN.1 payload
>> however, since 2012 linux kernel provide ASN.1 decoder library.
>> If we use ASN.1 decoder in the /lib/asn1_decoder.c, we can remove
>> about 1000 line of ASN.1 parsing routine.
>>
>> To use asn1_decoder.c, we should write mib file(nf_nat_snmp_basic.asn1)
>> then /script/asn1_compiler.c makes *-asn1.c and *-asn1.h file
>> at the compiletime.(nf_nat_snmp_basic-asn1.c, nf_nat_snmp_basic-asn1.h)
>> The nf_nat_snmp_basic.asn1 is made by RFC1155, RFC1157, RFC1902, RFC1905,
>> RFC2578, RFC3416. of course that mib file supports only the basic SNMP ALG.
>>
>> Previous SNMP ALG mangles only first octet of IPv4 address.
>> but after this patch, the SNMP ALG mangles whole IPv4 Address.
>> And SNMPv3 is not supported.
>
> Was SNMPv3 supported before this patch?
>

Yes, original snmp helper do not support SNMPv3.

>> I tested with snmp commands such ans snmpd, snmpwalk, snmptrap.
>
> If you can develop a bit more how you have tested this, I'd really
> appreciate.
>

My test environment are below.

#Network
Client <-------------> Netfilter FW <-------------> SNMP Server
192.168.3.2   192.168.3.1  192.168.4.1   192.168.4.2

#FW commands
   iptables -t raw -I PREROUTING -p udp -m multiport --dports 161,162
-j CT --helper snmp
   echo 'file nf_nat_snmp_basic.c +p' > /sys/kernel/debug/dynamic_debug/control

#SNMP Server commands
   sudo ip r a 192.168.3.2 via 192.168.4.1 dev enp2s0

To test basic snmp test, I used snmpwalk command because it is easy to use
   snmpwalk -v <1 or 2c> -c public <ip address> OID
example)
   snmpwalk -v 2c -c public 192.168.4.2 .1.3.6.1.2.1.4.21

so that we can see this message from dmesg.
"snmp_helper: 192.168.3.2 to 192.168.4.1"

And, to test snmp trap test, I used snmptrap command.
   snmptrap -v 1 -c public 192.168.3.2 .1 192.168.4.2 0 0 0 .1 a 192.168.4.2
   snmptrap -v 2c -c public 192.168.3.2 .1 .1 .1 a 192.168.4.2

SNMPv1 trap includes two ip address in payload. so we can see below
message twice.
"snmp_helper: 192.168.4.2 to 192.168.3.1"

If you want to see asn1 decoder debug message, please use below command
   echo 'file asn1_decoder.c +p' > /sys/kernel/debug/dynamic_debug/control

so that you can see below message

[ 4365.722398] next_op: pc=0/100 dp=0/46 C=0 J=0
[ 4365.722530] - match? 30 30 00
[ 4365.722578] - TAG: 30 44 CONS
[ 4365.722625] next_op: pc=2/100 dp=2/46 C=1 J=0
[ 4365.722665] - match? 02 02 00
[ 4365.722704] - TAG: 02 1
[ 4365.722739] - LEAF: 1
[ 4365.722808] next_op: pc=5/100 dp=5/46 C=1 J=0
[ 4365.722874] - match? 04 04 00
[ 4365.722915] - TAG: 04 6
[ 4365.722952] - LEAF: 6
[ 4365.723008] next_op: pc=7/100 dp=13/46 C=1 J=0
[ 4365.723075] - match? a4 a0 04
[ 4365.723137] next_op: pc=10/100 dp=13/46 C=1 J=0
[ 4365.723176] - match? a4 a1 05
[ 4365.723218] next_op: pc=13/100 dp=13/46 C=1 J=0
[ 4365.723256] - match? a4 a5 01
[ 4365.723297] next_op: pc=16/100 dp=13/46 C=1 J=0
[ 4365.723334] - match? a4 a2 06
[ 4365.723376] next_op: pc=19/100 dp=13/46 C=1 J=0
[ 4365.723413] - match? a4 a4 00
[ 4365.723452] - TAG: a4 31 CONS
[ 4365.723525] - MATCH_JUMP
[ 4365.723596] next_op: pc=48/100 dp=15/46 C=2 J=1
[ 4365.723653] - match? 06 06 00
[ 4365.723691] - TAG: 06 1
[ 4365.723726] - LEAF: 1
[ 4365.723767] next_op: pc=50/100 dp=18/46 C=2 J=1
[ 4365.723805] - match? 40 40 00
[ 4365.723842] - TAG: 40 4
[ 4365.723906] snmp_helper: 192.168.3.2 to 192.168.4.1
[ 4365.723944] - LEAF: 4
[ 4365.723988] next_op: pc=53/100 dp=24/46 C=2 J=1
[ 4365.724063] - match? 02 02 00
[ 4365.724127] - TAG: 02 1
[ 4365.724180] - LEAF: 1
[ 4365.724222] next_op: pc=55/100 dp=27/46 C=2 J=1
[ 4365.724259] - match? 02 02 00
[ 4365.724296] - TAG: 02 1
[ 4365.724330] - LEAF: 1
[ 4365.724372] next_op: pc=57/100 dp=30/46 C=2 J=1
[ 4365.724449] - match? 43 43 00
[ 4365.724505] - TAG: 43 1
[ 4365.724541] - LEAF: 1
[ 4365.724582] next_op: pc=59/100 dp=33/46 C=2 J=1
[ 4365.724621] - match? 30 30 00
[ 4365.724658] - TAG: 30 11 CONS
[ 4365.724703] - MATCH_JUMP
[ 4365.724774] next_op: pc=64/100 dp=35/46 C=3 J=2
[ 4365.724831] - match? 30 30 00
[ 4365.724870] - TAG: 30 9 CONS
[ 4365.724913] next_op: pc=66/100 dp=37/46 C=4 J=2
[ 4365.724951] - match? 06 06 00
[ 4365.724988] - TAG: 06 1
[ 4365.725023] - LEAF: 1
[ 4365.725065] next_op: pc=68/100 dp=40/46 C=4 J=2
[ 4365.725104] - match? 40 02 42
[ 4365.725146] next_op: pc=70/100 dp=40/46 C=4 J=2
[ 4365.725183] - match? 40 04 44
[ 4365.725224] next_op: pc=72/100 dp=40/46 C=4 J=2
[ 4365.725262] - match? 40 06 46
[ 4365.725347] next_op: pc=74/100 dp=40/46 C=4 J=2
[ 4365.725413] - match? 40 40 00
[ 4365.725478] - TAG: 40 4
[ 4365.725538] snmp_helper: 192.168.3.2 to 192.168.4.1
[ 4365.725575] - LEAF: 4
[ 4365.725617] next_op: pc=77/100 dp=46/46 C=4 J=2
[ 4365.725659] next_op: pc=79/100 dp=46/46 C=4 J=2
[ 4365.725702] next_op: pc=81/100 dp=46/46 C=4 J=2
[ 4365.725744] next_op: pc=83/100 dp=46/46 C=4 J=2
[ 4365.725804] next_op: pc=85/100 dp=46/46 C=4 J=2
[ 4365.725877] next_op: pc=87/100 dp=46/46 C=4 J=2
[ 4365.725920] next_op: pc=89/100 dp=46/46 C=4 J=2
[ 4365.725963] next_op: pc=91/100 dp=46/46 C=4 J=2
[ 4365.726005] next_op: pc=93/100 dp=46/46 C=4 J=2
[ 4365.726047] next_op: pc=95/100 dp=46/46 C=4 J=2
[ 4365.726128] next_op: pc=96/100 dp=46/46 C=4 J=2
[ 4365.726189] - end cons t=37 dp=46 l=46/46
[ 4365.726226] - cons len l=9 d=9
[ 4365.726267] next_op: pc=97/100 dp=46/46 C=3 J=2
[ 4365.726305] - end cons t=35 dp=46 l=46/46
[ 4365.726341] - cons len l=11 d=11
[ 4365.726382] next_op: pc=99/100 dp=46/46 C=2 J=2
[ 4365.726440] next_op: pc=62/100 dp=46/46 C=2 J=1
[ 4365.726510] - end cons t=15 dp=46 l=46/46
[ 4365.726567] - cons len l=31 d=31
[ 4365.726610] next_op: pc=63/100 dp=46/46 C=1 J=1
[ 4365.726652] next_op: pc=22/100 dp=46/46 C=1 J=0
[ 4365.726694] next_op: pc=25/100 dp=46/46 C=1 J=0
[ 4365.726737] next_op: pc=28/100 dp=46/46 C=1 J=0
[ 4365.726799] next_op: pc=31/100 dp=46/46 C=1 J=0
[ 4365.726872] next_op: pc=34/100 dp=46/46 C=1 J=0
[ 4365.726924] next_op: pc=35/100 dp=46/46 C=1 J=0
[ 4365.726964] - end cons t=2 dp=46 l=46/46
[ 4365.727002] - cons len l=44 d=44
[ 4365.727045] next_op: pc=36/100 dp=46/46 C=0 J=0



> This is removing quite a lot of code, which as I said is great since
> it's way less code to maintain.
>
> My concern is that this patch is doing way many things in one go, and
> the lack of tests also make me feel concerned about regressions. If
> you could provide a more comprehensive description of what you have
> tested, I'd really appreciate.
>
> Just to mention a few things that got introduced here in one go, that
> probably can be done incrementally:
>
>> @@ -1232,14 +185,17 @@ static int help(struct sk_buff *skb, unsigned int protoff,
>>       if (ntohs(udph->len) != skb->len - (iph->ihl << 2)) {
>>               net_warn_ratelimited("SNMP: dropping malformed packet src=%pI4 dst=%pI4\n",
>>                                    &iph->saddr, &iph->daddr);
>> -              return NF_DROP;
>> +             nf_ct_helper_log(skb, ct, "too short packet");
>> +             return NF_DROP;
>>       }
>>
>> -     if (!skb_make_writable(skb, skb->len))
>> +     if (!skb_make_writable(skb, skb->len)) {
>> +             nf_ct_helper_log(skb, ct, "cannot mangle packet");
>
> This log line is new, probably good to add this in a separated initial patch.
>
>>               return NF_DROP;
>> +     }
>>
>>       spin_lock_bh(&snmp_lock);
>> -     ret = snmp_translate(ct, ctinfo, skb);
>> +     ret = snmp_translate(ct, dir, skb);
>
> Conversion to use 'dir' could be done in a initial patch too I think.
>
>>       spin_unlock_bh(&snmp_lock);
>>       return ret;
>>  }
>> @@ -1259,12 +215,6 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
>>       .tuple.dst.protonum     = IPPROTO_UDP,
>>  };
>>
>> -/*****************************************************************************
>> - *
>> - * Module stuff.
>> - *
>> - *****************************************************************************/
>> -
>
> This useless comment can also go away in an initial patch.
>
>>  static int __init nf_nat_snmp_basic_init(void)
>>  {
>>       BUG_ON(nf_nat_snmp_hook != NULL);
>> @@ -1282,5 +232,3 @@ static void __exit nf_nat_snmp_basic_fini(void)
>>
>>  module_init(nf_nat_snmp_basic_init);
>>  module_exit(nf_nat_snmp_basic_fini);
>> -
>> -module_param(debug, int, 0600);
>
> I'm fine with killing this old debug parameter, but better in an
> initial patch.
>
> Thanks for your work!

I will resend v3 patch that are split several part.

Thank you so much for your review!
