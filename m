From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] netfilter: nf_conntrack: prevent uninit-value in
 gc_worker
Date: Thu, 12 Jul 2018 05:11:38 -0700
Message-ID: <9a877bfc-67f3-2242-a681-5814dc1c1dd4@gmail.com>
References: <20180712004037.197064-1-edumazet@google.com>
 <20180712090044.lwukow7nqzzht67g@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180712090044.lwukow7nqzzht67g@breakpoint.cc>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 07/12/2018 02:00 AM, Florian Westphal wrote:
> Eric Dumazet <edumazet@google.com> wrote:
>> KMSAN reported use of uninit-value in gc_worker [1]
>>
>> We need to clear ct->timeout in __nf_conntrack_alloc()
>> otherwise __nf_conntrack_confirm() might propagate garbage when
>> adding nfct_time_stamp to ct->timeout :
>>
>> 	ct->timeout += nfct_time_stamp;
>>
>> [1]
>> BUG: KMSAN: uninit-value in gc_worker+0x89e/0x1530 net/netfilter/nf_conntrack_core.c:1028
>> CPU: 1 PID: 19 Comm: kworker/1:0 Not tainted 4.18.0-rc4+ #24
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: events_power_efficient gc_worker
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x185/0x1e0 lib/dump_stack.c:113
>>  kmsan_report+0x195/0x2c0 mm/kmsan/kmsan.c:1092
>>  __msan_warning_32+0x7d/0xe0 mm/kmsan/kmsan_instr.c:640
>>  gc_worker+0x89e/0x1530 net/netfilter/nf_conntrack_core.c:1028
> 
> I wonder how this can happen.
> 
> All trackers are supposed to set ->timeout to the correct value,
> otherwise (assuming init-to-0), we add a ct entry to global hash that
> is expired.
> 
> For instance, tcp calls
> nf_ct_refresh_acct() at end of its ->packet() callback to set
> a timeout based on the connection state.
> 
> That being said, I don't see any harm in initing to 0 of course.
> 

Yeah, unfortunately there is no repro yet, all the info I have I put it
in the changelog.
