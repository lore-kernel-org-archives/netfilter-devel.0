From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: promiscuous mode
Date: Sat, 04 Jun 2005 08:49:08 +0000
Message-ID: <42A16B04.5050807@outerspace.dyndns.org>
References: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: knash@cs.tcd.ie
In-Reply-To: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting knash@cs.tcd.ie on 2005-06-03 09:09 UTC:
> Hello,

Hi :)

> I set up my wireless card in promiscuous mode. I want to capture all
> unicast packets using the hook NF_IP_PRE_ROUTING but packets other then
> the ones destined for my machine are been dropped.

Could it be that you have rp_filter turned on?

Try doing this:

  echo 0 > /proc/sys/net/ipv4/conf/eth1/rp_filter

(replace eth1 with whatever your wlan interface is)

Here's some more info (chapter 13.1):

  http://www.linuxguruz.com/iptables/howto/2.4routing-13.html

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCoWsCxyF48ZTvn+4RAui4AJ4422QWePo6mfZ1AixtXjDGKAdvSQCgx2jR
gbBwczPHtnuIDrePPyaq/6k=
=+Kry
-----END PGP SIGNATURE-----
