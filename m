From: Andy Polyakov <appro@fy.chalmers.se>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Thu, 23 Oct 2003 13:26:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F97BAF4.45CA6D@fy.chalmers.se>
References: <3F964F9D.D5C69498@fy.chalmers.se> <20031023090238.GE1418@sunbeam.de.gnumonks.org> <3F97A4C5.982725B0@fy.chalmers.se> <3F97B874.CB12C184@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, coreteam@netfilter.org,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> - collect attached console.dump;
> Unable to handle kernel paging request at virtual address 00100108
> EIP is at find_appropriate_src+0x3d/0xa0 [ipchains]

Just as in my original report. It was TCP translation which has expired,
therefore +0x3d, 0x100100 is address "i" itself from
"i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum ==
tuple->dst.protonum" line in src_cmp. A.
