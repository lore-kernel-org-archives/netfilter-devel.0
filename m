From: Herve Eychenne <rv@wallfire.org>
Subject: Re: iptables: memory allocation problem
Date: Sat, 20 Dec 2003 13:12:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031220121218.GA1370@eychenne.org>
References: <20031216182959.GA1216@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031216182959.GA1216@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Dec 16, 2003 at 07:29:59PM +0100, Herve Eychenne wrote:

 Hi again,

> I'm currently setting up a quiet big firewall, and I experience some
> annoying problems. Here is what I get right now:
> # iptables -A INPUT -j ACCEPT
> iptables: Memory allocation problem
> Well... something is going wrong, obviously.
> [...]
> Note that the machine is still perfectly functionnal. I can log in
> (remotely) and do whatever I want without any problem. I just seem to b=
e
> running out of kernel memory for the iptables rule insertion.
> So I suspect there is a kind of memory leak somewhere.
> [...]
> The machine is a SMP (4 processors) with Xeon 2.40GHz.
> The host is running iptables-1.2.9 with 2.4.23 vanilla kernel (highmem
> 4Go activated, as there is 1.5G of RAM), and no real exotic
> patch-o-matic module added (I'll provide the list on request if you
> want) and no module support (I'll send .config on request as well).
> [...]
> I tweaked the number of buckets (based on my document
> http://www.wallfire.org/misc/netfilter_conntrack_perf.txt)
> # cat /proc/sys/net/ipv4/netfilter/ip_conntrack_max
> 3579157
> # cat /proc/sys/net/ipv4/netfilter/ip_conntrack_buckets
> 3579157
> Note: maybe it's a little too much (there's no real memory consuming
> userspace command running, so I want to reserve as much as possible for
> conntrack), but I think I can recall having an iptables memory
> allocation only one time (I was surprised, but forgot
> about it) a long time ago on the same machine before I had set these
> parameters to something else than the default.

I know... nobody dared to reply... too bad... :-(
So here's your punishment. ;-)
Well... after a reboot and 2 days without problem, another issue
showed up.

I tried another "iptables-restore <myrules", which produced no
memory outage. Then, shortly after, I came up with the strange
idea of wanting to know how many entries there was in the conntrack.
What a foolish idea... as my
# wc -l /proc/net/ip_conntrack
simply locked the machine: my remote shell freezed, no traffic could
go through the firewall, and the console itself was completely
unresponsive.
After 2 or 3 minutes, I decided I could not wait any longer, as I
had to reboot the firewall as soon as possible to get the important
traffic back.

Do you think it is possible that a wc -l on a huge conntrack (there
could have been up to 3 million entries (as you can see in the
quoted text above), but I have absolutely no idea of how many there
were here) would take so much time (more that 3 minutes on a
4*2.4 Ghz) and would get the kernel so busy that it would even
freeze the console?
Or do you think it's clearly a bug?

Well, anyway, as conntrack listing locks conntrack state, don't you
think we should definitely provide a way to read ip_conntrack_count
through /proc/sys/net/ipv4/netfilter/ip_conntrack_count ? (aka
"Yet Another Oneliner Patch For Patch-O-Matic")

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
