From: Kishore Dharmavaram <kishored@servgate.com>
Subject: RE: iptable_nat module slows/hoses my Redhat 9.0 box
Date: Fri, 12 Dec 2003 14:53:19 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B20F1@skat.sky.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Cc: netfilter@lists.netfilter.org, "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: 'Jan Kaastrup' <jka@protego.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jan & All,

Yes I want to do that for UDP & ICMP, can you tellme how to remove stateful
inspection(connection tracking) for just ICMP and UDP protocols without
removing NAT on ICMP and UDP packets.

Thanks,
Kishore

-----Original Message-----
From: Jan Kaastrup [mailto:jka@protego.dk]
Sent: Friday, December 12, 2003 2:57 AM
To: 'Kishore Dharmavaram'
Subject: RE: iptable_nat module slows/hoses my Redhat 9.0 box


Could it be a possibility to remove the statefull part from your NAT
connection.
This helps me when i do security scannings of other servers and therefor
have a lot of udp packets.
The problem is, it has to insert all connection in ip_conntract.

-----Original Message-----
From: netfilter-admin@lists.netfilter.org
[mailto:netfilter-admin@lists.netfilter.org] On Behalf Of Kishore
Dharmavaram
Sent: 12. december 2003 10:20
To: 'Harald Welte '
Cc: ''netfilter@lists.netfilter.org' ';
''netfilter-devel@lists.netfilter.org' '
Subject: RE: iptable_nat module slows/hoses my Redhat 9.0 box


Hello Harald & All,

Thanks for your reply. Eventhough I don't use NAT now, I will have to
use it
soon. 

Connection setup really sucks after 'iptable_nat' module is inserted, my
Pentium-4 RH9.0 box hangs with 7Mbps traffic using 20,000 concurrent UDP
streams.

Are there any tweaks that I can do in NAT code to increase performance
of
NAT, like: increase NAT hash-table size(I have got 1G RAM) or change
hash
algorithm etc?. 

For e.g: based on a recommendation from netfilter FAQ, I passed an
odd-number(not a power of 2) as 'hashsize' parameter value  to
'ip_conntrack' module,  session-setup performance improved a lot after
that
in my tests when UDP packet streams with incrementing source IP address
are
sent. But this 'hashsize' tweak did not improve session-setup
performance
when UDP streams with incrementing destination IP address are sent.

Is connection setup slow because of hash collisions i.e due to lot of
connections getting hashed to same hash-bucket? or it due to lot of
memcopies?. Can you please give some specific reasons for poor
performance
of NAT, it will help me in optimizing/tuning, if possible, that specifc
part
of netfilter nat functionality.

Thanks,
Kishore


-----Original Message-----
From: Harald Welte
To: Kishore Dharmavaram
Cc: 'netfilter@lists.netfilter.org';
'netfilter-devel@lists.netfilter.org'
Sent: 12/11/2003 11:13 PM
Subject: Re: iptable_nat module slows/hoses my Redhat 9.0 box

On Thu, Dec 11, 2003 at 09:47:25PM -0800, Kishore Dharmavaram wrote:
> Hi All,
> 
> I find that after inserting "iptable_nat" module on my
RH9.0(2.4.20-19.9)
> box, session-setup(ip_conntrack)  performance gets very bad. 

yes, that's true.  I think we cannot state often enogh: DO NOT load
iptable_nat if you don't need nat.  

> I am wondering why "iptable_nat" is slowing doing the box so much when
I
> don't have any NAT rules defined.

NAT is inherently complex.  and in order to support any kind of nat,
every connection (even the non-nat'ed ones) need to be placed in two
additional hash tables.  

If you just use conntrack, a single hash table is sufficient.. 

> Do you guys know of any netfilter patches made to address/fix this
issue?.

There is no way to 'address' this issue other than not using NAT.

> Thanks,
> Kishore

-- 
- Harald Welte <laforge@netfilter.org>
http://www.netfilter.org/
========================================================================
====
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
