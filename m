From: Ben Skeggs <darktama@iinet.net.au>
Subject: Re: IPv6 state match - possible bug.
Date: Wed, 15 Feb 2006 12:11:47 +1100
Message-ID: <1139965907.8973.1.camel@araqiel.keine.ath.cx>
References: <200602140403.k1E43GCu003190@toshiba.co.jp>
	<200602140416.k1E4GXbM015693@toshiba.co.jp>
	<1139891071.26079.11.camel@araqiel.keine.ath.cx>
	<200602140647.k1E6lerK011885@toshiba.co.jp>
Reply-To: darktama@iinet.net.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602140647.k1E6lerK011885@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2006-02-14 at 15:47 +0900, Yasuyuki KOZAKAI wrote:
> From: Ben Skeggs <darktama@iinet.net.au>
> Date: Tue, 14 Feb 2006 15:24:31 +1100
> 
> > On Tue, 2006-02-14 at 13:16 +0900, Yasuyuki KOZAKAI wrote:
> > > From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> > > Date: Tue, 14 Feb 2006 13:03:15 +0900 (JST)
> > > 
> > > > looks fine to me. I tested with recent kernel, same kernrel config,
> > > > and same rules, but couldn't reproduce above log.
> > > > 
> > > > Which version of kernel(or git commit id) and ip6tables ?
> > > > And could you do
> > > > 	echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid
> > > 
> > > Sorry, right sysctl is
> > > 
> > >   	echo 255 > /proc/sys/net/netfilter/nf_conntrack_log_invalid
> > Okay, seems there is an issue somewhere..  I'm using 2.6.16-rc3, and
> > also had the same issue with -rc2.  iptables is version 1.3.5.
> > 
> > nf_ct_tcp: bad TCP checksum IN= OUT=
> > SRC=2001:0200:0000:8002:0203:47ff:fea5:3085
> > DST=2001:0388:c17d:0000:020f:eaff:fe70:ebf9 LEN=80 TC=0 HOPLIMIT=56
> > FLOWLBL=525788 PROTO=TCP SPT=80 DPT=52498 SEQ=1589838125 ACK=2289866071
> > WINDOW=57344 RES=0x00 ACK SYN URGP=0 OPT
> > (020405A0010303000101080A2DA73166049359BE)
> 
> checksumming with your eth0 driver might be broken.
> I'm not sure why, but I saw some reports about checksum for a few weeks.
Thank you!  This was indeed the problem.

I swapped from my onboard Yukon (skge driver), to the nvidia card
(forcedeth driver) and everything seems to work correctly now.

Sorry for the noise!

Ben Skeggs.
> 
> > IP6-IN: IN=eth0 OUT= MAC=00:0f:ea:70:eb:f9:00:50:8d:e3:b5:89:86:dd
> > SRC=2001:0200:0000:8002:0203:47ff:fea5:3085
> > DST=2001:0388:c17d:0000:020f:eaff:fe70:ebf9 LEN=80 TC=0 HOPLIMIT=56
> > FLOWLBL=525788 PROTO=TCP SPT=80 DPT=52498 WINDOW=57344 RES=0x00 ACK SYN
> > URGP=0
> > 
> > Which is odd, without any ip6tables rules everything seems to work well.
> 
> From: Ben Skeggs <darktama@iinet.net.au>
> Date: Tue, 14 Feb 2006 16:53:01 +1100
> 
> > Just another followup with some more info.. I built 2.6.16-rc3 on my
> > other machine (x86) and it does indeed appear to work correctly there.
> > 
> > I'm wondering if there is some amd64-specific bug?
> 
> Or they have different ether card, maybe. I'm using e100 and it works fine.
> 
> -- Yasuyuki Kozakai
