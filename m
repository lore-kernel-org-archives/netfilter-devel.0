From: Jens Hektor <hektor@rz.rwth-aachen.de>
Subject: System with really big statetable crashing while doing
 "cat /proc/net/ip_conntrack | wc -l"
Date: Thu, 22 Apr 2004 07:57:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40875ECE.1000405@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

we are running a production packetfilter based on Fedora Core-1
actual vanilla  2.4.22-1.2179.nptl-smp.

This packetfilter is in front of two class-B's and it has a big
statetable, really. We guess that it's about 200k entries.

So we only can guess for if doing

	cat /proc/net/ip_conntrack | wc -l

the system reproducably crashes.

We had the same effect on non-smp and 2.6 version of Fedora kernels
and I guess that the same might happen with the vanilla kernel.

Here is what the kernel oops tells:

- ------------------------------------------------------------------------
EIP is at print_expect [ip_conntrack] 0x14 (kernel-name)
[two lines with registers: varying values]
ds: 0068    es:0068     ss:0068
[Process is always "cat", pid, stackpage & stack varying]
Calltrace:  [<f8a3c442>] list_conntracks [ip_conntrack] 0x122 (varying_#)
[<varying_#>] proc_file_read [kernel] varying_#
[<varying_#>] sys_read [kernel] varying_#
[<varying_#>] system_call [kernel] varying_#
- ------------------------------------------------------------------------

Is this known, has anyone ever seen this?

Best regards, Jens Hektor


- --
Jens Hektor, RWTH Aachen, Rechenzentrum, Seffenter Weg 23, 52074 Aachen
Center for Computing and Communication, RWTH Aachen University, Germany
mailto:hektor@RZ.RWTH-Aachen.DE, Tel.: +49 241 80 29206, Raum: 2.35
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEVAwUBQIdezhsVN+J7zzuXAQGHJgf9FYr4wtTh6vQwg7uZuxkzb18Nfv4kPTbw
WhLO8vGQQrFSYuHvQ4zt/PokGGMyhjbALesiRFZmYT6Rhg3HEkf2Pmax+FC75NcQ
SMityI8CPE9JsnGKQGlei3/jQY8SFevjfa5GrFKVwv5GQIEqq97xKP2s6Lnv1zsG
LlkIUDcg55uiKQ+r3N8O0cMTPahuvUh5EbzG6IeD8oPzEgO+FfEoocdUkF1Hkj8Z
bPoA2DEnAXNXUwHCniBwdMZBpW4krWnV7JOG8m8bhARwuUvXC6JlsRx5InAA6XMh
+FHVnU0dQKef7nple7MUXlWx8dgxMW0t3vvhkv+EPXR1rMWvFjzYPw==
=vJ/G
-----END PGP SIGNATURE-----
