From: "Robert Iakobashvili" <roberti@GoNetworks.com>
Subject: ip_nat|conntrack_h323.c on 2.6
Date: Wed, 5 Jan 2005 14:05:48 +0200
Message-ID: <699F7BBB368A10479166148511F524177A016D@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>,
	<max@duempel.org>
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

Dear Max,

In about a month we are planning to deal with H323 traversal via NAT.
If not in development, we can assist you in debugging on SMP (dual AMD
opteron).
Please, keep us informed as well.

Sincerely,
Robert Iakobashvili
roberti@gonetworks.com


<I'd like to announce, I am working on the 2.6 port of the CT/NAT H323
<module. It's already working, only the NAT part is fragile, mainly
<because I havn't understood everything of the CT/NAT API yet.

<I'll send a patch as soon as I'm able to tell whether my code is
<correct (and as soon as I think it is)...

<The "brute force" algorithm is still the same in my port; eventually,
<I will improve that later.

<Max
<
