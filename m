From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP window tracking patch status query for further design
 considerations
Date: Wed, 9 Oct 2002 00:16:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210090012060.24530-100000@blackhole.kfki.hu>
References: <3DA2E3D9.3000700@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <3DA2E3D9.3000700@tac.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Roberto,

On Tue, 8 Oct 2002, Roberto Nibali wrote:

> I kind of have a case here where I can reliably generate a hang. It's quite
> complex to reproduce though. So far you need multiple interfaces, some secondary
> IP addresses and a rule that only allows connections to the sshd on the packet
> filter (I think it has nothing to do with the setup though). Then you log in and
> do some work. After a while, it seems like a buffer is getting too big, it
> stalls and I start getting DENIES in the kernlog. Sorry for not being more
> specific but I will try to work out an easy test case so you can debug it.
[...]
> DENY INPUT: IN=eth0 OUT= MAC=00:01:02:96:f9:05:00:50:04:ac:5e:33:08:00
> SRC=172.27.0.1 DST=172.27.232.12 LEN=576 TOS=0x10 PREC=0xC0 TTL=255 ID=44216
> PROTO=ICMP TYPE=3 CODE=4 [SRC=172.27.232.12 DST=192.168.7.1 LEN=1500 TOS=0x10
> PREC=0x00 TTL=63 ID=42584 DF PROTO=TCP SPT=234 DPT=45835 WINDOW=9480 RES=0x00
> ACK URGP=0 ] MTU=1200

It has nothing to do with the tcp-window-tracking patch. Without the patch
you would get the same results.

You send too big packets with the DF bit set, but you block the
correspondig ICMP error messages (see the kernel log above) as well.

> Another problem is that I can work on the new session as long as the
> things I do don't generate a certain size of packets.

Exactly.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
