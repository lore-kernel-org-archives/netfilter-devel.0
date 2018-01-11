From: Wei Wang <weiwan@google.com>
Subject: Re: [bisected] Forwarded packets occasionally has loopback output
 interface in Netfilter
Date: Thu, 11 Jan 2018 10:18:08 -0800
Message-ID: <CAEA6p_B68G+-tBfrv9c6hqvXnhPYQFwFcuZjedtfU8HozEcCSQ@mail.gmail.com>
References: <1514286320.12738.1.camel@cohaesio.com> <1515691504.1318.9.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1515691504.1318.9.camel@cohaesio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 11, 2018 at 9:25 AM, Anders K. Pedersen | Cohaesio
<akp@cohaesio.com> wrote:
> On tir, 2017-12-26 at 12:05 +0100, Anders K. Pedersen | Cohaesio wrote:
>> Hello,
>>
>> On one of our border routers, Netfilter is occasionally logging packets
>> with "OUT=3Dlo" (output interface lo) even though the packet should be
>> going out via a regular interface. This behavior is present on Linux
>> 4.13.0 to 4.14.9, and a bisection of the problem points to
>>
>> [95c47f9cf5e028d1ae77dc6c767c1edc8a18025b] ipv4: call dst_dev_put() prop=
erly
>>
>> as the first bad commit. This commit adds dst_dev_put() calls before
>> some dst_release() calls, and dst_dev_put() does
>>
>>     dst->dev =3D dev_net(dst->dev)->loopback_dev;
>>
>> (among other things), which fits the problem we're seeing.
>>
>> The essential part of our nftables rule set that shows this behavior is
>>
>> chain forward {
>>                 type filter hook forward priority 0;
>>
>>                 meta oif { $internal_interfaces } accept
>>
>>                 meta oif lo ip daddr !=3D 127.0.0.0/8 \
>>                         log group 0 snaplen 80 prefix "oif-lo" counter
>>
>>                 ip saddr { $our_ip_series } \
>>                         flow table acct_out \
>>                         { meta oif . rt nexthop . ip saddr timeout 12m c=
ounter } \
>>                         accept
>>
>>                 log group 0 snaplen 80 prefix "DROP" counter drop
>> }
>>
>> The router only does stateless packet filtering and no redirection or
>> rewriting of the packets (connection tracking, NAT, ipvs etc. are not
>> even compiled for this kernel).
>>
>> As a result of this problem we see packets that should be going to an
>> internal interface (and thus accepted by the first rule above) being
>> logged and dropped by the last rule. Some examples:
>>
>> Dec 22 11:57:02 cix4 oif-lo IN=3Deth10 OUT=3Dlo MAC=3D90:e2:ba:5c:b6:95:=
10:f3:11:38:06:77:08:00 SRC=3D81.170.163.118 DST=3D212.97.158.33 LEN=3D1500=
 TOS=3D00 PREC=3D0x00 TTL=3D116 ID=3D25932 DF PROTO=3DTCP SPT=3D35118 DPT=
=3D8443 SEQ=3D604358330 ACK=3D1182278705 WINDOW=3D3295 ACK URGP=3D0 MARK=3D=
0
>> Dec 22 11:57:02 cix4 DROP IN=3Deth10 OUT=3Dlo MAC=3D90:e2:ba:5c:b6:95:10=
:f3:11:38:06:77:08:00 SRC=3D81.170.163.118 DST=3D212.97.158.33 LEN=3D1500 T=
OS=3D00 PREC=3D0x00 TTL=3D116 ID=3D25932 DF PROTO=3DTCP SPT=3D35118 DPT=3D8=
443 SEQ=3D604358330 ACK=3D1182278705 WINDOW=3D3295 ACK URGP=3D0 MARK=3D0
>>
>> Dec 22 12:47:07 cix4 oif-lo IN=3Deth10 OUT=3Dlo MAC=3D90:e2:ba:5c:b6:95:=
0e:86:10:27:99:f3:08:00 SRC=3D40.101.30.18 DST=3D212.97.130.32 LEN=3D245 TO=
S=3D00 PREC=3D0x00 TTL=3D118 ID=3D10370 DF PROTO=3DTCP SPT=3D443 DPT=3D4498=
8 SEQ=3D1141545913 ACK=3D3844573103 WINDOW=3D65535 ACK PSH URGP=3D0 MARK=3D=
0
>> Dec 22 12:47:07 cix4 DROP IN=3Deth10 OUT=3Dlo MAC=3D90:e2:ba:5c:b6:95:0e=
:86:10:27:99:f3:08:00 SRC=3D40.101.30.18 DST=3D212.97.130.32 LEN=3D245 TOS=
=3D00 PREC=3D0x00 TTL=3D118 ID=3D10370 DF PROTO=3DTCP SPT=3D443 DPT=3D44988=
 SEQ=3D1141545913 ACK=3D3844573103 WINDOW=3D65535 ACK PSH URGP=3D0 MARK=3D0
>>
>> Dec 22 12:53:56 cix4 oif-lo IN=3Deth10 OUT=3Dlo MAC=3D90:e2:ba:5c:b6:95:=
0e:86:10:27:99:f3:08:00 SRC=3D40.101.12.34 DST=3D212.97.130.32 LEN=3D245 TO=
S=3D00 PREC=3D0x00 TTL=3D115 ID=3D27728 DF PROTO=3DTCP SPT=3D443 DPT=3D3972=
4 SEQ=3D3797156404 ACK=3D3944234612 WINDOW=3D65535 ACK PSH URGP=3D0 MARK=3D=
0
>> Dec 22 12:53:56 cix4 DROP IN=3Deth10 OUT=3Dlo MAC=3D90:e2:ba:5c:b6:95:0e=
:86:10:27:99:f3:08:00 SRC=3D40.101.12.34 DST=3D212.97.130.32 LEN=3D245 TOS=
=3D00 PREC=3D0x00 TTL=3D115 ID=3D27728 DF PROTO=3DTCP SPT=3D443 DPT=3D39724=
 SEQ=3D3797156404 ACK=3D3944234612 WINDOW=3D65535 ACK PSH URGP=3D0 MARK=3D0
>>
>> It also happens for outbound traffic, where the packets are logged and
>> counted in the acct_out flow table with "meta oif" =3D "lo", but a
>> correct "rt nexthop" - an example:
>>
>> Dec 22 12:29:13 cix4 oif-lo IN=3Dteam0.20 OUT=3Dlo MAC=3D3c:fd:fe:15:db:=
a8:00:24:a8:ff:f0:00:08:00 SRC=3D212.97.129.25 DST=3D95.166.119.129 LEN=3D4=
0 TOS=3D00 PREC=3D0x00 TTL=3D62 ID=3D19481 DF PROTO=3DTCP SPT=3D443 DPT=3D5=
2560 SEQ=3D3034827396 ACK=3D2862814901 WINDOW=3D12618 ACK URGP=3D0 MARK=3D0
>>
>> # nft list flow table filter acct_out|tr ',' '\n'|grep lo
>>         flow table acct_out {
>>  "lo" . 94.101.208.217 . 212.97.129.25 expires 3m17s : counter packets 1=
 bytes 40
>>
>> I don't know if these packets are actually sent out on the correct
>> outbound interface thanks to the proper nexthop (the MAC=3D information
>> in the Netfilter log is from the received packet and thus not useful
>> here).
>>
>> I tried running a tcpdump on the lo interface to see if these packets
>> would show up there, but during the three days I had it running, it
>> only logged one such packet, while Netfilter logs 20+ outbound packets
>> every day, and the one packet logged by tcpdump was *not* logged by
>> Netfilter.
>
> Further testing of the individual parts of the first bad commit shows
> that the five first additions of the dst_dev_put() call doesn't trigger
> the problem, while the last one does (also without the first five), so
> the problematic part is:
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 3dee004..d986d80 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1369,6 +1372,7 @@ static bool rt_cache_route(struct fib_nh *nh, struc=
t rtable *rt)
>         prev =3D cmpxchg(p, orig, rt);
>         if (prev =3D=3D orig) {
>                 if (orig) {
> +                       dst_dev_put(&orig->dst);
>                         dst_release(&orig->dst);
>                         rt_free(orig);
>                 }
>

Hi Anders,

First of all, the bad commit you pointed to is part of the effort to
remove dst garbage collector. And it is expected that certain routing
behavior will change after this whole patch set.
In your specific case:
Specifically for the one line change you pointed above,
rt_cache_route() is called to replace an existing cached route with a
new one because the existing cached route is already invalid. And the
criteria to determine if it is valid is in rt_cache_valid(). If a
route becomes invalid, it means the route is either being deleted, or
a new route is being inserted to the same table, or there is certain
netdev event happening that could make this route unusable. In all
cases, a route re-lookup is required. dst_dev_put() here does cleanup
work to free up the device refcount and all packets using this route
will be dropped. And as you said, you don't really see the packets
going out of lo.


> Any help with fixing this would be much appreciated. If there's
> anything I should try to debug this further, please let me know.
>
> Regards,
> Anders K. Pedersen
