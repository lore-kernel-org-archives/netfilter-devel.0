From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack
Date: Mon, 01 Mar 2004 15:08:03 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403010608.PAA13782@toshiba.co.jp>
References: <200402221110.28339.tato.net@tin.it>
	<200402230527.OAA02726@toshiba.co.jp>
	<200402261320.08113.tatonet@tiscali.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Mon_Mar__1_15:08:03_2004_915)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tatonet@tiscali.it
In-Reply-To: <200402261320.08113.tatonet@tiscali.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Mon_Mar__1_15:08:03_2004_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi, Davide,

Sorry for late replying.

From: Davide <tatonet@tiscali.it>
Date: Thu, 26 Feb 2004 13:20:08 +0100

> > Sorry, I'm confusing. Which path should packets go through ? we need to
> > design so that users can filter/log packets before and/or after
> > translating. At least, translated packets should go through
> > NF_IP{6}_FORWARD, I think.
> 
> I agree with you, users should be able to filter/log NAT(P)T-PT'ed packets. 
> However there are some (bad) problems.
> At present time your conntrack code doesn't handle IPv6 fragments, but I guess  
> that when it will do, IPv6 datagrams will be defragmented as in current 
> conntrack. So I assume that NA(P)T-PT code will see only entire l3 packets.

Yes. That is missing piece. Of cause, I'll implement that. But I haven't
decide how to handle fragmented IPv6 packets yet.

ip6_conntrack, which is written by me and tracks only IPv6 packets, clone
fragmented packets and reassemble them (note: not linearize). After tracking,
reassembled packet is discard and pass original fragmented packets to next
network process. Of cause, original fragmented skbs points to same conntrack.

I adopted this way to prevent from disturbing other IPv6 codes(ex. Path MTU
Discovery.)

But I don't know this is best. Maybe NA(P)T-PT helper module wants reassembled
packet to rewrite data in payload (ex FTP).
				   
> One problem is that I should know if original datagrams had a fragment header 
> or not. NA(P)T-PT should produce IPv4 packets with DF flag set for IPv6 
> non-fragment datagrams and IPv4 packets with DF not set for IPv6 datagrams 
> with a fragment header. So, although on one hand I need conntrack, on the 
> other hand I should see original datagrams.
> A similar problem turns out on IPv4-to-IPv6 translation. When I receive IPv4 
> datagrams with DF not set, I should fragment them so that their IPv6 
> translation fits in 1280 octects. If DF flag is set, in order to allow 
> pathMTU discovery, I should preserve their size and I should translate them 
> into IPv6 datagram without a fragmentation header (except for IPv4 fragments 
> with DF set...).
> I'm trying to say (with my terrible English) that a NA(P)T-PT implementation 
> should have more control over IPv6/IPv4 packets: since conntrack 
> defragments/fragments them it's impossible to be RFC 2766 compliant.

IPv4 header has DF bit field and it's not changed. so there is no problem
even if reassembled by conntrack in the case of IPv4-to-IPv6.

There is problem in the case of IPv6-to-IPv4. I was going to implement so that
nf_conntrack removes Fragment Header in the case that payload length of
reassembled packet is > 65535 - 8 .

ok, I need to be more care about handling fragmented packet.

But in any case, original(not reassembled) IPv6 packets are needed to be
passed next network.
And I think it's natural that behavior for IPv4 and IPv6 is synchronized.
This mean that IPv4 packets isn't reassembled.

In this case, benefits are
	- all modules can process fragmented packets with any style.
	- all modules can prevent from disturbing other network code.

drawbacks are
	- User Interface will be changed. current ip_conntrack reassemble at
	  PRE_ROUTING, and refragment at POST_ROUTING. so users assume that
	  packets are reassembled when filtering.

	- if multiple module want reassembled packets, reassembling is occurred
	  many times.

The 1st drawback can be solved at ip{6}_tables in kernel.
But I don't any idea about 2nd issue in now.

> For these reasons I'm tempted to use the approach proposed by Henrik (virtual 
> network device).

I have timely news. Recently, I heard that kernel implementation of NAT-PT is
already created. Maybe this implementation doesn't use netfilter.
virtual device ???

I'll attach the message at usagi-users ML.


----Next_Part(Mon_Mar__1_15:08:03_2004_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nat-pt.txt"

Received: from mx2.toshiba.co.jp (mx2.toshiba.co.jp [133.199.160.163])
	by isl.rdc.toshiba.co.jp (8.11.7/8.11.6/1.4) with ESMTP id i1REpf128100;
	Fri, 27 Feb 2004 23:51:41 +0900 (JST)
Received: from tsb-sgw2.toshiba.co.jp by toshiba.co.jp id XAA17776; Fri, 27 Feb 2004 23:51:41 +0900 (JST)
Received: from inet-tsb5.toshiba.co.jp 
	by tsb-sgw2.toshiba.co.jp  with ESMTP id i1REpe8U014622;
	Fri, 27 Feb 2004 23:51:40 +0900 (JST)
Received: from linux6.nezu.wide.ad.jp (linux6.nezu.wide.ad.jp [203.178.142.218])
	by inet-tsb5.toshiba.co.jp  with ESMTP id i1REpd4v018298
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO);
	Fri, 27 Feb 2004 23:51:39 +0900 (JST)
Received: from nezu.linux-ipv6.org (localhost [127.0.0.1])
	by linux6.nezu.wide.ad.jp (8.12.3/8.12.3/Debian-6.6) with ESMTP id i1REEPAA016856;
	Fri, 27 Feb 2004 23:14:25 +0900
Received: from web40301.mail.yahoo.com (web40301.mail.yahoo.com [66.218.78.80])
	by linux6.nezu.wide.ad.jp (8.12.3/8.12.3/Debian-6.6) with SMTP id i1REEFAA016836
	for <usagi-users@linux-ipv6.org>; Fri, 27 Feb 2004 23:14:15 +0900
Received: from [193.220.224.6] by web40301.mail.yahoo.com via HTTP; Fri, 27 Feb 2004 04:27:28 PST
Date: Fri, 27 Feb 2004 04:27:28 -0800 (PST)
From: sunil arora <korona_lite@yahoo.com>
Reply-To: usagi-users@linux-ipv6.org
Subject: (usagi-users 02823) regarding NAT-PT implementation in linux kernel
To: yhsiung@zyxel.com, usagi-users@linux-ipv6.org
Cc: wangping@tyut.edu.cn
Message-Id: <20040227122728.59974.qmail@web40301.mail.yahoo.com>
X-ML-Name: usagi-users
X-Mail-Count: 02823
X-MLServer: fml [fml 4.0.3 release (20011202/4.0.3)]; post only (only members can post)
X-ML-Info: If you have a question, send e-mail with the body
	"help" (without quotes) to the address usagi-users-ctl@linux-ipv6.org;
	help=<mailto:usagi-users-ctl@linux-ipv6.org?body=help>
X-Spam-Status: No, hits=0.0 required=5.0 tests= version=2.20
X-Spam-Flag: No
X-Spam-Probability: 0.499972
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Lines: 29
List-Id: usagi-users.linux-ipv6.org
List-Software: fml [fml 4.0.3 release (20011202/4.0.3)]
List-Post: <mailto:usagi-users@linux-ipv6.org>
List-Owner: <mailto:usagi-users-admin@linux-ipv6.org>
List-Help: <mailto:usagi-users-ctl@linux-ipv6.org?body=help>
List-Unsubscribe: <mailto:usagi-users-ctl@linux-ipv6.org?body=unsubscribe>
X-UIDL: -DF"!+7-"!</7!!<<d!!

Hi all,
I am really sorry for late response. Actually was busy
with mid-semester exms here!

Our Nat-PT implementation in linux kernel is almost
over and we are giving it final testing. It will take
roughly 25 days to get the finally tested patch
available for kernel 2.4.22.
I hope you guys can bear with us. And We will be
releasing a floppy based version of our distribution
as well, that is also almost ready.

I apologise for not making the code available right
away.
There is also a userland application developed by some
instituition in Korea which performs NAT-PT. I read an
article in LJ discussing a NAT-PT set up ..some months
back.I will send the pointer to their link in the next
mail.

-sun



__________________________________
Do you Yahoo!?
Get better spam protection with Yahoo! Mail.
http://antispam.yahoo.com/tools




----Next_Part(Mon_Mar__1_15:08:03_2004_915)----
