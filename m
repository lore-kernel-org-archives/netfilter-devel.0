From: "Robert Iakobashvili" <roberti@Go-WLAN.com>
Subject: 64-bit versus 32-bit kernel performance
Date: Mon, 25 Oct 2004 09:19:49 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <699F7BBB368A10479166148511F524174CBA6B@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

With reference to the nf-workshop-2004-summary.pdf,=20
section 13.3 "Netfilter benchmarking by HW",
"building as 64-bit kernel hurts performance,=20
this is assumed because skb grows another cache line because of
large pointers".

Could somebody elaborate on this issue?=20
Does it mean that the bottleneck is CPU and broadband throughput
to the board makes just nothing?

Any pointers to the exact setup description would be appreciated.

Sincerely,
Robert Iakobashvili

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
netfilter-devel-request@lists.netfilter.org
Sent: Monday, October 25, 2004 2:57 AM
To: netfilter-devel@lists.netfilter.org
Subject: netfilter-devel Digest, Vol 3, Issue 33

Send netfilter-devel mailing list submissions to
	netfilter-devel@lists.netfilter.org

To subscribe or unsubscribe via the World Wide Web, visit
	https://lists.netfilter.org/mailman/listinfo/netfilter-devel
or, via email, send a message with subject or body 'help' to
	netfilter-devel-request@lists.netfilter.org

You can reach the person managing the list at
	netfilter-devel-owner@lists.netfilter.org

When replying, please edit your Subject line so it is more specific
than "Re: Contents of netfilter-devel digest..."


Today's Topics:

   1. [PATCH 2.6 12/19]: Enable ip6t_multiport.c to work without
      skb_linearize() (Patrick McHardy)
   2. [PATCH 2.6 14/19]: Fix warning in CONNMARK (Patrick McHardy)
   3. [PATCH 2.6 5/19]: Enable ip6t_ah.c to work without
      skb_linearize() (Patrick McHardy)
   4. [PATCH 2.6 15/19]: Fix multiple bugs in dst match
      (Patrick McHardy)
   5. [PATCH 2.6 16/19]: Fix multiple bugs in hbh match
      (Patrick McHardy)
   6. [PATCH 2.6 19/19]: fix stats in __ip_conntrack_confirm
      (Patrick McHardy)


----------------------------------------------------------------------

Message: 1
Date: Mon, 25 Oct 2004 02:49:45 +0200
From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 12/19]: Enable ip6t_multiport.c to work without
	skb_linearize()
To: "David S. Miller" <davem@redhat.com>
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Message-ID: <417C4DA9.3090901@trash.net>
Content-Type: text/plain; charset=3D"us-ascii"

Convert ip6t_multiport to skb_header_pointer.


-------------- next part --------------
A non-text attachment was scrubbed...
Name: 12.diff
Type: text/x-patch
Size: 2192 bytes
Desc: not available
Url :
/pipermail/netfilter-devel/attachments/20041025/e5075569/12-0001.bin

------------------------------

Message: 2
Date: Mon, 25 Oct 2004 02:49:52 +0200
From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 14/19]: Fix warning in CONNMARK
To: "David S. Miller" <davem@redhat.com>
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Message-ID: <417C4DB0.3090206@trash.net>
Content-Type: text/plain; charset=3D"us-ascii"

Fix warning in CONNMARK:
net/ipv4/netfilter/ipt_CONNMARK.c:63: warning: suggest parentheses=20
around arithmetic in operand of ^


-------------- next part --------------
A non-text attachment was scrubbed...
Name: 14.diff
Type: text/x-patch
Size: 1000 bytes
Desc: not available
Url :
/pipermail/netfilter-devel/attachments/20041025/66c3bed9/14-0001.bin

------------------------------

Message: 3
Date: Mon, 25 Oct 2004 02:49:05 +0200
From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/19]: Enable ip6t_ah.c to work without
	skb_linearize()
To: "David S. Miller" <davem@redhat.com>
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Message-ID: <417C4D81.70500@trash.net>
Content-Type: text/plain; charset=3D"us-ascii"

Convert ip6t_ah to skb_header_pointer.


-------------- next part --------------
A non-text attachment was scrubbed...
Name: 05.diff
Type: text/x-patch
Size: 2572 bytes
Desc: not available
Url :
/pipermail/netfilter-devel/attachments/20041025/01812945/05-0001.bin

------------------------------

Message: 4
Date: Mon, 25 Oct 2004 02:49:57 +0200
From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 15/19]: Fix multiple bugs in dst match
To: "David S. Miller" <davem@redhat.com>
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Message-ID: <417C4DB5.8040108@trash.net>
Content-Type: text/plain; charset=3D"iso-8859-15"

Fix multiple bugs in dst match:

- ".me =3D THIS_MODULE" is missing
- The cast of the pointer to the next IPv6 extension header is wrong.
- hdrlen may underflow.
- (u16)*optdesc causes to alignment problem.
- The calculation of the offset to next option is wrong. In the case
  that the type isn't 0, it should be "Opt Data Len" field + 2
  (see RFC2460).


-------------- next part --------------
A non-text attachment was scrubbed...
Name: 15.diff
Type: text/x-patch
Size: 5637 bytes
Desc: not available
Url :
/pipermail/netfilter-devel/attachments/20041025/1b345c34/15-0001.bin

------------------------------

Message: 5
Date: Mon, 25 Oct 2004 02:50:01 +0200
From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 16/19]: Fix multiple bugs in hbh match
To: "David S. Miller" <davem@redhat.com>
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Message-ID: <417C4DB9.3080502@trash.net>
Content-Type: text/plain; charset=3D"iso-8859-15"

Fix multiple bugs in hbh match:

- The cast of the pointer to the next IPv6 extension header is wrong.
- hdrlen may underflow.
- (u16)*optdesc causes to alignment problem.
- The calculation of the offset to next option is wrong. In the case
  that the type isn't 0, it should be "Opt Data Len" field + 2
  (see RFC2460).


-------------- next part --------------
A non-text attachment was scrubbed...
Name: 16.diff
Type: text/x-patch
Size: 5261 bytes
Desc: not available
Url :
/pipermail/netfilter-devel/attachments/20041025/5b0d3915/16-0001.bin

------------------------------

Message: 6
Date: Mon, 25 Oct 2004 02:50:11 +0200
From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 19/19]: fix stats in __ip_conntrack_confirm
To: "David S. Miller" <davem@redhat.com>
Cc: Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Message-ID: <417C4DC3.3060604@trash.net>
Content-Type: text/plain; charset=3D"us-ascii"

net_rx_softirq can preempt the calling process while incrementing the
stats,
call CONNTRACK_STAT_INC within the locked section.


-------------- next part --------------
A non-text attachment was scrubbed...
Name: 19.diff
Type: text/x-patch
Size: 1543 bytes
Desc: not available
Url : /pipermail/netfilter-devel/attachments/20041025/9cc40ad3/19.bin

------------------------------

_______________________________________________
netfilter-devel mailing list
netfilter-devel@lists.netfilter.org
https://lists.netfilter.org/mailman/listinfo/netfilter-devel


End of netfilter-devel Digest, Vol 3, Issue 33
**********************************************
