From: "Gil Shai" <GilS@GoNetworks.com>
Subject: RE: Changing the Ethernet header
Date: Sun, 20 Feb 2005 08:40:33 +0200
Message-ID: <7DC268DDBA95E14D8572DF824F92789E03EEEE@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Content-class: urn:content-classes:message
To: "Kevin P. Fleming" <kpfleming@starnetworks.us>
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

That would be a nice solution but the problem is that I need to use this
for an application that will need to add different VLAN headers for
different Ips. There could be many Ips and it will be done dynamically.

Gil=20

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Kevin
P. Fleming
Sent: Friday, February 18, 2005 7:43 AM
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Changing the Ethernet header

Gil Shai wrote:

> I am trying to create a rule that causes packets going to a certain IP

> to have a certain VLAN header.

So create a VLAN interface, bind an address to it, and add a host route
for that IP to go out via that interface.
