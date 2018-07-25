From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Wed, 25 Jul 2018 08:06:10 -0600
Message-ID: <4b03b5f6-87ce-9ff2-7c14-598beebd8fb8@gmail.com>
References: <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
 <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
 <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
 <20180718.125938.2271502580775162784.davem@davemloft.net>
 <28c30574-391c-b4bd-c337-51d3040d901a@gmail.com>
 <CAM_iQpW4-JkZY7jXx0Q1b907hQ85UOL1eXv2YHwSukb5L=apUg@mail.gmail.com>
 <5021d874-8e99-6eba-f24b-4257c62d4457@gmail.com>
 <CAM_iQpUc-H2kZCBevePs6g-8qKyJkUhdd1ZDSQgYsCG0ChfC2w@mail.gmail.com>
 <87muufze8w.fsf@xmission.com>
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
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87muufze8w.fsf@xmission.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 7/25/18 6:33 AM, Eric W. Biederman wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> 
>> On Tue, Jul 24, 2018 at 8:14 AM David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 7/19/18 11:12 AM, Cong Wang wrote:
>>>> On Thu, Jul 19, 2018 at 9:16 AM David Ahern <dsahern@gmail.com> wrote:
>>>>>
>>>>> Chatting with Nikolay about this and he brought up a good corollary - ip
>>>>> fragmentation. It really is a similar problem in that memory is consumed
>>>>> as a result of packets received from an external entity. The ipfrag
>>>>> sysctls are per namespace with a limit that non-init_net namespaces can
>>>>> not set high_thresh > the current value of init_net. Potential memory
>>>>> consumed by fragments scales with the number of namespaces which is the
>>>>> primary concern with making neighbor tables per namespace.
>>>>
>>>> Nothing new, already discussed:
>>>> https://marc.info/?l=linux-netdev&m=140391416215988&w=2
>>>>
>>>> :)
>>>>
>>>
>>> Neighbor tables, bridge fdbs, vxlan fdbs and ip fragments all consume
>>> local memory resources due to received packets. bridge and vxlan fdb's
>>> are fairly straightforward analogs to neighbor entries; they are per
>>> device with no limits on the number of entries. Fragments have memory
>>> limits per namespace. So neighbor tables are the only ones with this
>>> strict limitation and concern on memory consumption.
>>>
>>> I get the impression there is no longer a strong resistance against
>>> moving the tables to per namespace, but deciding what is the right
>>> approach to handle backwards compatibility. Correct? Changing the
>>> accounting is inevitably going to be noticeable to some use case(s), but
>>> with sysctl settings it is a simple runtime update once the user knows
>>> to make the change.
>>
>> This question definitely should go to Eric Biederman who was against
>> my proposal.
>>
>> Let's add Eric into CC.
> 
> Given that the entries are per device and the devices are per-namespace,
> semantically neighbours are already kept in a per-namespace manner.  So
> this is all about making the code not honoring global resource limits.
> Making the code not honor gc_thresh3.
> 
> Skimming through the code today the default for gc_thresh3 is 1024.
> Which means that we limit the neighbour tables to 1024 entries per
> protocol type.
> 
> There are some pretty compelling reasons especially with ipv4 to keep
> the subnet size down.  Arp storms are a real thing.
> 
> I don't know off the top of my head what the reasons for limiting the
> neighbour table sizes.  I would be much more comfortable with a patchset
> like this if we did some research and figured out the reasons why
> we have a global limit.  Then changed the code to remove those limits.
> 
> When the limits are gone.  When the code can support large subnets
> without tuning.  We we don't have to worry about someone scanning an all
> addresses in an ipv6 subnet and causing a DOS on working machines.
> I think it is completely appropriate to look to see if something per
> network namespace needs to happen.
> 
> So please let's address the limits, not the fact that some specific
> corner case ran into them.
> 
> If we are going to neuter gc_thresh3 let's go as far as removing it
> entirely.  If we are going to make the neighbour table per something
> let's make it per network device.  If we can afford the multiple hash
> tables then a hash table per device is better.   Perhaps we want to move
> to rhash tables while we look at this, instead of an old hand grown
> version of resizable hash table.

Given the uses cases with increasing number of devices (> 10,000),
per-device tables will have more problems than per namespace - in
reference to your concern in the last paragraph below.

> 
> Unless I misread something all your patchset did is reshuffle code and
> data structures so that gc_thresh3 does not apply accross namespaces.
> That does not feel like it really fixes anything.  That just lies to
> people.

This patch set fixes the lie that network namespaces provide complete
isolation when in fact one namespace can evict neighbor entries from
another. An arp storm you are concerned about in one namespace impacts
all containers.

It starts by removing the proliferation of open coded references to
arp_tbl and nd_tbl, moving them behind the existing neigh_find_table.
>From there (patches 14-16) it makes the tables per-namespace and hence
makes the gc_thresh parameters which are per-table now
per-table-per-namespace.

So it removes the global thresholds because the global ones are just
wrong given the meaning of a network namespace and provides the more
appropriate per-namespace limits.

> 
> Further unless I misread something you are increasing the number of
> timers to 3 per namespace.  If I create create a thousand network
> namespaces that feels like it will hurt system performance overall.

It seems to me the timers are per neighbor entry not table. The per
table ones are for proxies.
