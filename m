From: "Trevor Paskett" <tpaskett@cymphonix.com>
Subject: RE: HELP! Transparent Proxy using bridging 2.6.9 and REDIRECT on
	different subnet
Date: Wed, 23 Mar 2005 12:18:54 -0700
Message-ID: <2F413D5F33545D4A8465BBEE900238CC3FA763@cymmail.cymphonix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
content-class: urn:content-classes:message
To: "Nguyen Dinh Nam" <64vn@cardvn.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Yes it is on. It works great when the test machine is on the same subnet
as the Linux box. When it is on a different subnet, then the clients
gets packets back like it should but the port number on the packet is 1
instead of 80 like it is when they are on the same subnet.

Then if I bring up an alias br0:0 with an IP on that subnet everything
works great again. Thanks!!

Trevor Paskett
Cymphonix Programmer - CCNA, CWNA
P: 801-938-1500 F: 801-938-1501
=20

-----Original Message-----
From: Nguyen Dinh Nam [mailto:64vn@cardvn.net]=20
Sent: Wednesday, March 23, 2005 11:01 AM
To: Trevor Paskett
Subject: Re: HELP! Transparent Proxy using bridging 2.6.9 and REDIRECT
on different subnet

on  the Linux machine (the one with squid), is=20
/proc/sys/net/ipv4/ip_forward turned on?

Trevor Paskett wrote:

>So no takers on this? Nobody has the same issue, or can re-create it?
We
>are desperate for a solution to this, and are willing to pay for a fix
>if necessary. Please help!!
>
>Trevor Paskett
>Cymphonix Programmer - CCNA, CWNA
>P: 801-938-1500 F: 801-938-1501
> =20
>
