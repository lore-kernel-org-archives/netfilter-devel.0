From: Florian Weimer <fweimer@bfk.de>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Thu, 08 Apr 2010 14:55:55 +0000
Message-ID: <82k4singck.fsf@mid.bfk.de>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	linux-net@vger.kernel.org
To: Roman Tsisyk <roman@tsisyk.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com> (Roman Tsisyk's message of "Tue\, 30 Mar 2010 21\:06\:57 +0700")
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Roman Tsisyk:

> 2. Correctly and fully fill all fields in a packet
> As I pointed above, pcap-based tools can't correctly fill all fields,
> e.g. output interface, nexthop, and AS (but I don't know where get AS
> information in the kernel yet).

(Older) IOS populates those fields from route tags found in the FIB.
Quagga etc. would have to be taught to set these tags.  The advantage
is that no additional route lookups are required (at least when
rp_filter is active).

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
