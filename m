From: c0g <c0g@wp.pl>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error
Date: Mon, 22 Sep 2003 11:43:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6EC448.2080002@wp.pl>
References: <3F69CFF6.1060505@wp.pl> <20030921144557.GB22223@sunbeam.de.gnumonks.org> <3F6EC037.2040702@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: c0g <c0g@wp.pl>
In-Reply-To: <3F6EC037.2040702@wp.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

| I attached tcpdump to every interface with a rule to catch fragments:
| tcpdump -c 1000 -s 65000 -w ethx-frags.dump -pni eth1 ip[6:2] & 0x1fff
!= 0
|
| Then I parsed kern.log* to find out when "frag of proto" warning and
| subsequent "last message repeated x times" was appearing.

And dump files are available here:
http://c0g.webpark.pl/frags/frags.tar.gz

- --
c0g@wp.pl
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/bsRHPqmVt5WhbA8RAvNuAJ4n+ytclgMMlNeaHy6+xITiBD/nxQCfakKA
Q0uuBA5eifPfA3t3pUUNhlU=
=xDWF
-----END PGP SIGNATURE-----
