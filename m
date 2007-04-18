From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [HEADS UP] merge of conntrack and conntrackd into conntrack-tools
Date: Thu, 19 Apr 2007 01:15:50 +0200
Message-ID: <4626A6A6.1040307@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi everyone,

I'm currently merging conntrack and conntrackd into a new package called
conntrack-tools. As soon as the process is done, I'll release the first
version. The new homepage can be reached at:

http://people.netfilter.org/pablo/conntrack-tools/

You can check out a working copy of the conntrack-tools from Netfilter
SVN with the following command:

svn co https://svn.netfilter.org/netfilter/trunk/conntrack-tools

Stay tuned,
Pablo

- --
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGJqamW42mhw+ndNkRAncNAJ9/HwAQXbtJUUVB9TWn9TcSt/8OzACcDM8V
gVT1hvwOLa69iaay6Kx6XEo=
=svt8
-----END PGP SIGNATURE-----
