From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: compiling libipq example
Date: Thu, 03 Mar 2005 15:17:29 +0200
Message-ID: <42270E69.5020008@outerspace.dyndns.org>
References: <421EE3A0.7000804@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Essien Ita Essien <essiene@datavibe.net>
In-Reply-To: <421EE3A0.7000804@datavibe.net>
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

Essien Ita Essien wrote:

| Any ideas what i'm doing wrong?

Found it! :)

| first.c:47: error: dereferencing pointer to incomplete type

The error is on line 46:

|                 struct ipq_packet_msg_t *m = ipq_get_packet(buf);

it should be either

struct ipq_packet_msg *m

or

ipq_packet_msg_t *m

but not

struct ipq_packet_msg_t *m

:)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCJw5lxyF48ZTvn+4RAppkAKC+vJ6OOMUWvYwibvBLbo1xWIfj+QCgjk+l
Chu0AEhgZHffTyUNtC2JlDo=
=WRhi
-----END PGP SIGNATURE-----
