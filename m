From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Tue, 24 Jul 2018 09:14:01 -0600
Message-ID: <5021d874-8e99-6eba-f24b-4257c62d4457@gmail.com>
References: <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
 <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
 <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
 <20180718.125938.2271502580775162784.davem@davemloft.net>
 <28c30574-391c-b4bd-c337-51d3040d901a@gmail.com>
 <CAM_iQpW4-JkZY7jXx0Q1b907hQ85UOL1eXv2YHwSukb5L=apUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        nikita.leshchenko@oracle.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpW4-JkZY7jXx0Q1b907hQ85UOL1eXv2YHwSukb5L=apUg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 7/19/18 11:12 AM, Cong Wang wrote:
> On Thu, Jul 19, 2018 at 9:16 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> Chatting with Nikolay about this and he brought up a good corollary - ip
>> fragmentation. It really is a similar problem in that memory is consumed
>> as a result of packets received from an external entity. The ipfrag
>> sysctls are per namespace with a limit that non-init_net namespaces can
>> not set high_thresh > the current value of init_net. Potential memory
>> consumed by fragments scales with the number of namespaces which is the
>> primary concern with making neighbor tables per namespace.
> 
> Nothing new, already discussed:
> https://marc.info/?l=linux-netdev&m=140391416215988&w=2
> 
> :)
> 

Neighbor tables, bridge fdbs, vxlan fdbs and ip fragments all consume
local memory resources due to received packets. bridge and vxlan fdb's
are fairly straightforward analogs to neighbor entries; they are per
device with no limits on the number of entries. Fragments have memory
limits per namespace. So neighbor tables are the only ones with this
strict limitation and concern on memory consumption.

I get the impression there is no longer a strong resistance against
moving the tables to per namespace, but deciding what is the right
approach to handle backwards compatibility. Correct? Changing the
accounting is inevitably going to be noticeable to some use case(s), but
with sysctl settings it is a simple runtime update once the user knows
to make the change.

neighbor entries round up to 512 byte allocations, so with the current
gc_thresh defaults (128/512/1024) 512k can be consumed. Using those
limits per namespace seems high which is why I suggested a per-namespace
default of (16/32/64) which amounts to 32k per namespace limit by
default. Open to other suggestions as well.
