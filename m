From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 15:50:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725135020.GA6433@balabit.hu>
References: <20030725085731.GA5776@balabit.hu> <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 25, 2003 at 11:08:16AM +0200, Martin Josefsson wrote:
> On Fri, 25 Jul 2003, Balazs Scheidler wrote:
> 
> > Hi,
> 
> Hi
> 
> > I've stumbled into a similar oops in replace_in_hashes  that somebody else
> > has already reported. It was suggested to move to 2.4.21 but it still
> > Oopses. It was also suggested to use the latest netfilter patches from
> > patch-o-matic, because a refcounting bug was introduced in 2.4.21.
> >
> > I checked out those patches and it seemed to me that they are only relevant
> > if conntrack and/or nat helpers are in use.
> 
> Yes the refcounting stuff is just when helpers are used.
> 
> > In our situation we do not have _any_ helpers loaded, only TPROXY generates
> > dynamic NAT mappings as they are needed. Is it possible that the reference
> > counting problem affects us?
> 
> Shouldn't be. This problem exists in 2.4.19 and 2.4.21 with
> submitted/pending patches from pom.
> 
> And it shouldn't be the TPROXY stuff either since it's seen without that
> stuff as well.
> 
> I'm a bit short on time but I hope I'll be able to look at it next week.
> Maybe someone else feels like going on a bughunt during the weekend?


Here are my first findings about the issue. I'm writing these down as it
makes it easier for me to rethink things. Please note that I was not very
much involved in core netfilter development until now and I hope my findings
are not completely insane.

I currently have two Oops traces, one posted to this list, which happens in
the forwarding path, probably when an SNAT rule is to be applied. The other
was not posted to this list, it happens on a transparent proxy box, when a
proxy initiates a connection and requests an implicit NAT mapping. I started
my work on our Oops, as I know the environment better. For a reference, the
backtrace can be found at the end of my mail.

So in our environment the Ooops happens when a proxy initiates a connection
which is SNATed by a tproxy assignment. This assignment works similarly to
an SNAT rule, the key difference is that instead of traversing the NAT
table, an internal hashtable is used to decide how the connection is to be
NATed. The tproxy functions register themselves at priority -130, e.g. this
happens after 'mangle' and prior to 'nat'.

The crash happens while the NAT mapping is prepared using
ip_nat_setup_info(), the NAT lock is correctly grabbed (write lock is
acquired). The conntrack associated with the current SKB contains bogus
values in its ip_nat_info structure, e.g. the hash chain pointers point into
space, and info->initialized is not 0.

This is definitely not a valid state, as the conntrack entry has just been
initialized, which memset()s these fields to zero.

The only hooks called earlier are CONNTRACK (which initializes this
conntrack), and MANGLE (which contains DROP and MARK targets in our case). I
don't think MANGLE influences anything as the rules in the mangle table do
not match (as the packet would have been forwarded instead of TPROXYed, or
would have been dropped if any rules were matching)

It is important to note that the packet is not yet confirmed, as the
confirmation hooks are called at the very end of the priority chain. This
means that our current CONNTRACK entry (which contains invalid data) has no
timer and also it may not be dropped because of early_drop().

This means that the memory area occupied by our conntrack entry is
overwritten sometime between the initialization of our CONNTRACK entry and
the time when the NAT mapping is being set up. We are using SMP boxes, thus
the other processor might cause this damage.

At the time of the oops, eax contains nat_info->bysource.list.next, and
eax->prev is being changed to nat_info->bysource.list.prev (edx).

%eax contains an odd number (0x010d6fc3), which is definitely not a pointer.
The value in %edx is a valid pointer, however it points into code space
(0xc022dab4 == pneigh_lookup + 0x148)

%ebp register contains the ipsprotohash value, and %edi the srchash value.
So everything seems to be normal, except the value of the memory area. I
suspect somebody is using an already freed memory area. 

As I see it is quite unlikely that the same memory area is used for
different purposes when a kmem_cache is used, as kmem_cache tries to reuse
blocks. I therefore think that we face a use-after-free conntrack scenario.

Any other thoughts, hints?

Finally the oops:

In interrupt handler - not syncing
Oops:   0002
CPU:    0
EIP:    0010:[<f8922478>]       not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
eax: 010d6fc3   ebx: c280a980   ecx: c280aa6c   edx: c022dab4
esi: c280aa18   edi: 00000fbb   ebp: 0000108a   esp: c3ac7c20
ds: 0018        es: 0018        ss: 0018
Process zorp (pid: 10472, stackpage=c3ac7000)
Stack:  c280aa18 00000004 00000003 00000001 f892255e c280a980 c280aa18 f8946509
        c280a980 c280aa18 00000003 de010140 00000004 de010140 db4dc278 c280aa18
        f89466c2 c280a980 00000004 de010140 c5b55980 c3ac7c80 00000002 db4dc264
Call Trace:     [<f892255e>] [<f8946509>] [<f89466c2>] [<f89468b1>] [<c0240bb0>]
        [<f8908654>] [<f894c081>] [<f894c800>] [<c0231310>] [<c0240bb0>] [<c0240bb0>]
        [<c023165f>] [<c0240bb0>] [<f89485bc>] [<c023f752>] [<c0240bb0>] [<c0240dd2>]
        [<c0240cb0>] [<c0231698>] [<c023fbf9>] [<c0240cb0>] [<f8947d21>] [<c024f61e>]
        [<c024f6ca>] [<c0251962>] [<c0254039>] [<c026168d>] [<c0224727>] [<c0260ab6>]
        [<c0224ae1>] [<c0224af0>] [<c0225064>] [<c0108943>]
Code: 89 50 04 89 02 c7 46 54 00 00 00 00 c7 41 04 00 00 00 00 8d


>>EIP; f8922478 <[iptable_nat]replace_in_hashes+40/a0>   <=====

>>eax; 010d6fc3 Before first symbol
>>ebx; c280a980 <_end+244d20c/3854888c>
>>ecx; c280aa6c <_end+244d2f8/3854888c>
>>edx; c022dab4 <pneigh_lookup+148/21c>
>>esi; c280aa18 <_end+244d2a4/3854888c>
>>edi; 00000fbb Before first symbol
>>ebp; 0000108a Before first symbol
>>esp; c3ac7c20 <_end+370a4ac/3854888c>

Trace; f892255e <[iptable_nat]ip_nat_update_hashes+16/28>
Trace; f8946509 <[iptable_tproxy]ip_tproxy_setup_nat_bidir+fd/144>
Trace; f89466c2 <[iptable_tproxy]ip_tproxy_setup_nat+32/50>
Trace; f89468b1 <[iptable_tproxy]ip_tproxy_fn+1d1/2d8>
Trace; c0240bb0 <ip_finish_output2+0/100>
Trace; f8908654 <[ip_tables]nulldevname.1644+0/ab>
Trace; f894c081 <[iptable_mangle]ipt_route_hook+21/28>
Trace; f894c800 <[iptable_mangle]packet_mangler+0/3c>
Trace; c0231310 <nf_iterate+30/80>
Trace; c0240bb0 <ip_finish_output2+0/100>
Trace; c0240bb0 <ip_finish_output2+0/100>
Trace; c023165f <nf_hook_slow+d7/194>
Trace; c0240bb0 <ip_finish_output2+0/100>
Trace; f89485bc <[iptable_tproxy]ip_tproxy_post_ops+0/18>
Trace; c023f752 <ip_output+166/170>
Trace; c0240bb0 <ip_finish_output2+0/100>
Trace; c0240dd2 <ip_queue_xmit2+122/20c>
Trace; c0240cb0 <ip_queue_xmit2+0/20c>
Trace; c0231698 <nf_hook_slow+110/194>
Trace; c023fbf9 <ip_queue_xmit+49d/4f4>
Trace; c0240cb0 <ip_queue_xmit2+0/20c>
Trace; f8947d21 <[iptable_tproxy].rodata.start+2a1/51f>
Trace; c024f61e <tcp_transmit_skb+43a/59c>
Trace; c024f6ca <tcp_transmit_skb+4e6/59c>
Trace; c0251962 <tcp_connect+39e/440>
Trace; c0254039 <tcp_v4_connect+325/3fc>
Trace; c026168d <inet_stream_connect+10d/268>
Trace; c0224727 <sys_connect+5b/78>
Trace; c0260ab6 <inet_setsockopt+2a/34>
Trace; c0224ae1 <sys_setsockopt+61/7c>
Trace; c0224af0 <sys_setsockopt+70/7c>
Trace; c0225064 <sys_socketccall+8c/200>
Trace; c0108943 <system_call+33/38>

Code;  f8922478 <[iptable_nat]replace_in_hashes+40/a0>
00000000 <_EIP>:
Code;  f8922478 <[iptable_nat]replace_in_hashes+40/a0>   <=====
   0:   89 50 04                  mov    %edx,0x4(%eax)   <=====
Code;  f892247b <[iptable_nat]replace_in_hashes+43/a0>
   3:   89 02                     mov    %eax,(%edx)
Code;  f892247d <[iptable_nat]replace_in_hashes+45/a0>
   5:   c7 46 54 00 00 00 00      movl   $0x0,0x54(%esi)
Code;  f8922484 <[iptable_nat]replace_in_hashes+4c/a0>
   c:   c7 41 04 00 00 00 00      movl   $0x0,0x4(%ecx)
Code;  f892248b <[iptable_nat]replace_in_hashes+53/a0>
  13:   8d 00                     lea    (%eax),%eax

 <0>Kernel panic: Aiee, killing interrupt handler!


-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
