From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Mon, 27 Oct 2003 19:30:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9D6437.AF4BE894@fy.chalmers.se>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Sorry that I failed to keep everything in one mail, but here is
another observation.

> - 'lsmod' to make sure *no* iptables modules are loaded;
> - 'time ./head.pl some.host 2000' says that it takes a portion of
> elapsed second for script to complete;

tcpdump on same machine starts as following (skiping initial SYN packets):

19:16:20.768383 eth0 > me.33336 > he.www: . 1:1(0) ack 1 win 5840 (DF)
19:16:20.779070 eth0 > me.33336 > he.www: P 1:2001(2000) ack 1 win 5840 (DF)
19:16:20.780130 eth0 < he.www > me.33336: . 1:1(0) ack 1461 win 8760 (DF)
19:16:20.780158 eth0 < he.www > me.33336: . 1:1(0) ack 2001 win 11680 (DF)

Note that tcpdump shows an impossible thing, 4th packed being
larger than MTU!? I don't know how come, but that is *not* how
it looks like on server side. On server side I do get 1460 large
packet followed by 540 one, just as one would normally expect...

> - modprobe ip_conntrack;
> - 'time ./head.pl some.host 2000' now says that it takes over 3(!)
> elapsed seconds to complete;

19:19:54.361162 eth0 > me.33337 > he.www: . 1:1(0) ack 1 win 5840 (DF)
19:19:57.370629 eth0 > me.33337 > he.www: . 1:1461(1460) ack 1 win 5840 (DF)
19:19:57.371675 eth0 < he.www > me.33337: . 1:1(0) ack 1461 win 8760 (DF)
19:19:57.374550 eth0 > me.33337 > he.www: P 1461:2001(540) ack 1 win 5840 (DF)
19:19:57.375074 eth0 < he.www > me.33337: . 1:1(0) ack 2001 win 11680 (DF)

No impossible things, but first MTU-40 large packet is delayed for
3 seconds... A.
