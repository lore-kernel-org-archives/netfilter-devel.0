From: Oskar Andreasson <oan@frozentux.net>
Subject: Re: CLUSTERIP and UML crash, was [Re: --dport in uml crash]
Date: Tue, 24 Oct 2006 17:33:58 +0200
Message-ID: <1161704038.8705.51.camel@LAPTOP4.MSHOME>
References: <1161644625.8705.16.camel@LAPTOP4.MSHOME>
	<453D4D6C.5050508@trash.net> <1161680257.8705.31.camel@LAPTOP4.MSHOME>
	<453E2220.3090506@trash.net>
Reply-To: oan@frozentux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-9pyEvJqpeBBM5h8rhqIN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <453E2220.3090506@trash.net>
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


--=-9pyEvJqpeBBM5h8rhqIN
Content-Type: multipart/mixed; boundary="=-EGpeTc6SNp1YvxOd0ayi"


--=-EGpeTc6SNp1YvxOd0ayi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

You seem to be right yes, regarding module loading/handling. I don't
dare say anything more, but a non-qualified guess is that it feels like
some kind of bug between how the UML kernel handles modules and how
iptables interact?

I've attached 3 more scenarios.=20

1. just restarted, issuing=20
iptables -t nat -A PREROUTING -j DNAT --to 192.168.10.2
lsmod
result: kernel panic from lsmod

2. just restarted, issuing
iptables -t nat -A POSTROUTING -j MASQUERADE
lsmod
result: kernel panic, exactly the same as first scenario (except for a
couple of addresses).=20

3. just restarted, issuing
modprobe ipt_MASQUERADE
modprobe ip_tables
lsmod
iptables -t nat -A POSTROUTING -j MASQUERADE
lsmod
result: the last lsmod results in a kernel panic.=20

All modules loaded with modprobe seems to work just fine, until iptables
touches them.=20

I just tried starting an nfs kernel server also, which didn't seem to
work either, so it seems mostly like an UML bug. It crashed at lsmod as
well.=20

Would you know which way is the best to get in touch with the
uml-people, and how to debug this? My experience with gdb is ...
somewhat limited. I guess now is as bad a time as any to finally sit
down with it :(. Suggestions on what to read are welcome.

On Tue, 2006-10-24 at 16:24 +0200, Patrick McHardy wrote:
> Oskar Andreasson wrote:
> > Hi Patrick,
> >=20
> > I'm sorry for the delayed reply, I had to get some sleep. The original
> > problem seems to have been caused by compiling iptables-1.3.6 against
> > libc6 and then running against an old libc5. It works flawless now that
> > they are both the correct version.
> >=20
> > However, I got another kernel panic from the CLUSTERIP target
> > (possibly?). If not, please let me know where to get this info to:)
> >=20
> > server1:~# iptables -A INPUT -d 192.168.0.5 -p tcp --dport 4444 -j
> > CLUSTERIP --new --hashmode sourceip --clustermac 01:00:00:00:00:20
> > --total-nodes 1 --local-node 1
> > ip_tables: (C) 2000-2006 Netfilter Core Team
> > Kernel panic - not syncing: Kernel mode fault at addr 0xa0be74, ip
> > 0x400d8cbe
> > =20
> > EIP: 0073:[<400d8cbe>] CPU: 0 Not tainted ESP: 007b:bfb31118 EFLAGS:
> > 00200246
> >     Not tainted
> > EAX: ffffffda EBX: 00000000 ECX: 40019000 EDX: 00000400
> > ESI: 08050ef0 EDI: 4014e6c0 EBP: bfb3112c DS: 007b ES: 007b
> > a0bc3728:  [<a0045cf8>] notifier_call_chain+0x28/0x50
> > a0bc3744:  [<a0034620>] panic+0x50/0x100
> > a0bc375c:  [<a0013433>] segv+0x203/0x2d0
> > a0bc3804:  [<a00131b2>] segv_handler+0x92/0x110
> > a0bc3828:  [<a0013120>] segv_handler+0x0/0x110
> > a0bc382c:  [<a002a328>] sig_handler_common_skas+0xa8/0xe0
> > a0bc3854:  [<a002619a>] sig_handler+0x4a/0x60
> > a0bc38ac:  [<a012ac26>] vsnprintf+0x396/0x590
> > a0bc38dc:  [<a00172a0>] maybe_map+0x70/0xb0
> > a0bc38e4:  [<a0017259>] maybe_map+0x29/0xb0
> > a0bc3908:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> > a0bc390c:  [<a00172fe>] do_op_one_page+0x1e/0x60
> > a0bc3924:  [<a0017496>] do_buffer_op+0x156/0x1b0
> > a0bc3934:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> > a0bc3948:  [<a00260e5>] set_signals+0x25/0x30
> > a0bc3954:  [<a007596e>] kmem_cache_alloc+0x2e/0x50
> > a0bc3968:  [<a00abe11>] proc_alloc_inode+0x41/0x80
> > a0bc3984:  [<a0093615>] get_new_inode_fast+0x25/0xe0
> > a0bc39c0:  [<a00abf9d>] proc_get_inode+0xfd/0x180
> > a0bc39c8:  [<a00923eb>] d_rehash+0x3b/0x40
> > a0bc39d8:  [<a00aed07>] proc_lookup+0x97/0xa0
> > a0bc3a00:  [<a0017259>] maybe_map+0x29/0xb0
> > a0bc3a24:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> > a0bc3a28:  [<a00172fe>] do_op_one_page+0x1e/0x60
> > a0bc3a40:  [<a00173d2>] do_buffer_op+0x92/0x1b0
> > a0bc3a50:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> > a0bc3a5c:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> > a0bc3a7c:  [<a0027a64>] setjmp_wrapper+0x34/0x40
> > a0bc3a9c:  [<a0027a48>] setjmp_wrapper+0x18/0x40
> > a0bc3aac:  [<a0087954>] link_path_walk+0x64/0xe0
> > a0bc3ac8:  [<a001791d>] strncpy_from_user_skas+0x9d/0x120
> > a0bc3ad8:  [<a0017820>] strncpy_chunk_from_user+0x0/0x60
> > a0bc3b28:  [<a012abe1>] vsnprintf+0x351/0x590
> > a0bc3b74:  [<a009a5f8>] seq_printf+0x28/0x50
> > a0bc3b90:  [<a0055172>] print_unload_info+0x52/0xd0
> > a0bc3bb0:  [<a0057321>] m_show+0x31/0xa0
> > a0bc3bd8:  [<a0099f23>] seq_read+0xc3/0x340
> > a0bc3c0c:  [<a00789d2>] vfs_read+0xf2/0x1e0
> > a0bc3c38:  [<a0078e18>] sys_read+0x38/0x80
> > a0bc3c60:  [<a0016f07>] handle_syscall+0xf7/0x1d0
> > a0bc3c7c:  [<a0078de0>] sys_read+0x0/0x80
> > a0bc3cb4:  [<a002a168>] userspace+0x1c8/0x2e0
> > a0bc3cec:  [<a0048d10>] ____call_usermodehelper+0x0/0xc0
> > a0bc3cfc:  [<a0048d10>] ____call_usermodehelper+0x0/0xc0
> > a0bc3d04:  [<a0016a5a>] new_thread_handler+0x9a/0xb0
> > a0bc3d48:  [<a00169c0>] new_thread_handler+0x0/0xb0
> > a0bc3d5c:  [<a01e4c41>] kill+0x11/0x20
>=20
> This looks UML module-load related. The command works fine here
> (with -i interface, otherwise it complains about a missing device).
> Does it also happen with other auto-loaded modules or when
> manually loading ipt_CLUSTERIP?

--=-EGpeTc6SNp1YvxOd0ayi
Content-Disposition: attachment; filename=uml-iptables-panics.txt
Content-Type: text/plain; name=uml-iptables-panics.txt; charset=us-ascii
Content-Transfer-Encoding: base64

c2VydmVyMTp+IyBpcHRhYmxlcyAtdCBuYXQgLUEgUFJFUk9VVElORyAtaiBETkFUIC0tdG8gMTky
LjE2OC4xMC4yDQppcF90YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0ZmlsdGVyIENvcmUgVGVhbQ0K
TmV0ZmlsdGVyIG1lc3NhZ2VzIHZpYSBORVRMSU5LIHYwLjMwLg0KaXBfY29ubnRyYWNrIHZlcnNp
b24gMi40ICgxNTkgYnVja2V0cywgMTI3MiBtYXgpIC0gMjI4IGJ5dGVzIHBlciBjb25udHJhY2sN
CnNlcnZlcjE6fiMgbHNtb2QNCk1vZHVsZSAgICAgICAgICAgICAgICAgIFNpemUgIFVzZWQgYnkN
Cktlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBLZXJuZWwgbW9kZSBmYXVsdCBhdCBhZGRyIDB4
YTA4OTkyLCBpcCAweDQwMGQ4Y2JlDQogDQpFSVA6IDAwNzM6Wzw0MDBkOGNiZT5dIENQVTogMCBO
b3QgdGFpbnRlZCBFU1A6IDAwN2I6YmY3MGNkMzggRUZMQUdTOiAwMDIwMDI0Ng0KICAgICBOb3Qg
dGFpbnRlZA0KRUFYOiBmZmZmZmZkYSBFQlg6IDAwMDAwMDAzIEVDWDogNDAwMWEwMDAgRURYOiAw
MDAwMDQwMA0KRVNJOiAwODA0YTAwOCBFREk6IDAwMDAwMDAwIEVCUDogYmY3MGNkNGMgRFM6IDAw
N2IgRVM6IDAwN2INCmExMDRmNzI4OiAgWzxhMDA0NWNmOD5dIG5vdGlmaWVyX2NhbGxfY2hhaW4r
MHgyOC8weDUwDQphMTA0Zjc0NDogIFs8YTAwMzQ2MjA+XSBwYW5pYysweDUwLzB4MTAwDQphMTA0
Zjc1YzogIFs8YTAwMTM0MzM+XSBzZWd2KzB4MjAzLzB4MmQwDQphMTA0Zjc4MDogIFs8YTAwMjkz
ODI+XSBtYXArMHgxMTIvMHgxNjANCmExMDRmODA0OiAgWzxhMDAxMzFiMj5dIHNlZ3ZfaGFuZGxl
cisweDkyLzB4MTEwDQphMTA0ZjgyODogIFs8YTAwMTMxMjA+XSBzZWd2X2hhbmRsZXIrMHgwLzB4
MTEwDQphMTA0ZjgyYzogIFs8YTAwMmEzMjg+XSBzaWdfaGFuZGxlcl9jb21tb25fc2thcysweGE4
LzB4ZTANCmExMDRmODU0OiAgWzxhMDAyNjE5YT5dIHNpZ19oYW5kbGVyKzB4NGEvMHg2MA0KYTEw
NGY4YWM6ICBbPGEwMTJhYzI2Pl0gdnNucHJpbnRmKzB4Mzk2LzB4NTkwDQphMTA0ZjhlMDogIFs8
YTAwMTcyNTk+XSBtYXliZV9tYXArMHgyOS8weGIwDQphMTA0ZjkwNDogIFs8YTAwMjk0NjI+XSB3
YWl0X3N0dWJfZG9uZSsweDUyLzB4MTUwDQphMTA0ZjkyMDogIFs8YTAwMTczZDI+XSBkb19idWZm
ZXJfb3ArMHg5Mi8weDFiMA0KYTEwNGY5MzA6ICBbPGEwMDE3NmMwPl0gY29weV9jaHVua190b191
c2VyKzB4MC8weDMwDQphMTA0Zjk0NDogIFs8YTAwMjYwZTU+XSBzZXRfc2lnbmFscysweDI1LzB4
MzANCmExMDRmOTYwOiAgWzxhMDAyOTQ2Mj5dIHdhaXRfc3R1Yl9kb25lKzB4NTIvMHgxNTANCmEx
MDRmOTgwOiAgWzxhMDA5MzYxNT5dIGdldF9uZXdfaW5vZGVfZmFzdCsweDI1LzB4ZTANCmExMDRm
OWFjOiAgWzxhMDAyYzYxND5dIHB0cmFjZV9zZXRyZWdzKzB4MTQvMHgzMA0KYTEwNGY5Yzg6ICBb
PGEwMDI4ZTg0Pl0gcnVuX3N5c2NhbGxfc3R1YisweGQ0LzB4MmQwDQphMTA0ZjlmYzogIFs8YTAw
MTcyNTk+XSBtYXliZV9tYXArMHgyOS8weGIwDQphMTA0ZmEyMDogIFs8YTAwMTc2YzA+XSBjb3B5
X2NodW5rX3RvX3VzZXIrMHgwLzB4MzANCmExMDRmYTI0OiAgWzxhMDAxNzJmZT5dIGRvX29wX29u
ZV9wYWdlKzB4MWUvMHg2MA0KYTEwNGZhM2M6ICBbPGEwMDE3M2QyPl0gZG9fYnVmZmVyX29wKzB4
OTIvMHgxYjANCmExMDRmYTRjOiAgWzxhMDAxNzZjMD5dIGNvcHlfY2h1bmtfdG9fdXNlcisweDAv
MHgzMA0KYTEwNGZhNTg6ICBbPGEwMDE3NmMwPl0gY29weV9jaHVua190b191c2VyKzB4MC8weDMw
DQphMTA0ZmE3ODogIFs8YTAwMjdhNjQ+XSBzZXRqbXBfd3JhcHBlcisweDM0LzB4NDANCmExMDRm
YTk4OiAgWzxhMDAyN2E0OD5dIHNldGptcF93cmFwcGVyKzB4MTgvMHg0MA0KYTEwNGZhYmM6ICBb
PGEwMDE3MGQ4Pl0gZG9fb3BzKzB4ZjgvMHgxMTANCmExMDRmYjI0OiAgWzxhMDEyYWJlMT5dIHZz
bnByaW50ZisweDM1MS8weDU5MA0KYTEwNGZiNzA6ICBbPGEwMDlhNWY4Pl0gc2VxX3ByaW50Zisw
eDI4LzB4NTANCmExMDRmYjhjOiAgWzxhMDA1NTE3Mj5dIHByaW50X3VubG9hZF9pbmZvKzB4NTIv
MHhkMA0KYTEwNGZiYWM6ICBbPGEwMDU3MzIxPl0gbV9zaG93KzB4MzEvMHhhMA0KYTEwNGZiZDQ6
ICBbPGEwMDk5ZjIzPl0gc2VxX3JlYWQrMHhjMy8weDM0MA0KYTEwNGZjMDg6ICBbPGEwMDc4OWQy
Pl0gdmZzX3JlYWQrMHhmMi8weDFlMA0KYTEwNGZjMzQ6ICBbPGEwMDc4ZTE4Pl0gc3lzX3JlYWQr
MHgzOC8weDgwDQphMTA0ZmM1YzogIFs8YTAwMTZmMDc+XSBoYW5kbGVfc3lzY2FsbCsweGY3LzB4
MWQwDQphMTA0ZmM3ODogIFs8YTAwNzhkZTA+XSBzeXNfcmVhZCsweDAvMHg4MA0KYTEwNGZjYjA6
ICBbPGEwMDJhMTY4Pl0gdXNlcnNwYWNlKzB4MWM4LzB4MmUwDQphMTA0ZmQwMDogIFs8YTAwMTZi
MzE+XSBmb3JrX2hhbmRsZXIrMHg5MS8weGEwDQphMTA0ZmQ0ODogIFs8YTAwMTZhYTA+XSBmb3Jr
X2hhbmRsZXIrMHgwLzB4YTANCmExMDRmZDVjOiAgWzxhMDFlNGM0MT5dIGtpbGwrMHgxMS8weDIw
DQoNCiAgICAgIA0KYmx1ZWZsdXhAbGFwdG9wNDp+L25ldGtpdDIva2VybmVsJCAgDQoNCi0tLS0t
LS0tLS0tLS0tLQ0KDQpzZXJ2ZXIxOn4jIGlwdGFibGVzIC10IG5hdCAtQSBQT1NUUk9VVElORyAt
aiBNQVNRVUVSQURFDQppcF90YWJsZXM6IChDKSAyMDAwLTIwMDYgTmV0ZmlsdGVyIENvcmUgVGVh
bQ0KTmV0ZmlsdGVyIG1lc3NhZ2VzIHZpYSBORVRMSU5LIHYwLjMwLg0KaXBfY29ubnRyYWNrIHZl
cnNpb24gMi40ICgxNTkgYnVja2V0cywgMTI3MiBtYXgpIC0gMjI4IGJ5dGVzIHBlciBjb25udHJh
Y2sNCnNlcnZlcjE6fiMgbHNtb2QNCk1vZHVsZSAgICAgICAgICAgICAgICAgIFNpemUgIFVzZWQg
YnkNCktlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBLZXJuZWwgbW9kZSBmYXVsdCBhdCBhZGRy
IDB4YTE3NWY0LCBpcCAweDQwMGQ4Y2JlDQogDQpFSVA6IDAwNzM6Wzw0MDBkOGNiZT5dIENQVTog
MCBOb3QgdGFpbnRlZCBFU1A6IDAwN2I6YmY3ZDc2MDggRUZMQUdTOiAwMDIwMDI0Ng0KICAgICBO
b3QgdGFpbnRlZA0KRUFYOiBmZmZmZmZkYSBFQlg6IDAwMDAwMDAzIEVDWDogNDAwMWEwMDAgRURY
OiAwMDAwMDQwMA0KRVNJOiAwODA0YTAwOCBFREk6IDAwMDAwMDAwIEVCUDogYmY3ZDc2MWMgRFM6
IDAwN2IgRVM6IDAwN2INCmExNzA3NzI4OiAgWzxhMDA0NWNmOD5dIG5vdGlmaWVyX2NhbGxfY2hh
aW4rMHgyOC8weDUwDQphMTcwNzc0NDogIFs8YTAwMzQ2MjA+XSBwYW5pYysweDUwLzB4MTAwDQph
MTcwNzc1YzogIFs8YTAwMTM0MzM+XSBzZWd2KzB4MjAzLzB4MmQwDQphMTcwNzc4MDogIFs8YTAw
MjkzODI+XSBtYXArMHgxMTIvMHgxNjANCmExNzA3ODA0OiAgWzxhMDAxMzFiMj5dIHNlZ3ZfaGFu
ZGxlcisweDkyLzB4MTEwDQphMTcwNzgyODogIFs8YTAwMTMxMjA+XSBzZWd2X2hhbmRsZXIrMHgw
LzB4MTEwDQphMTcwNzgyYzogIFs8YTAwMmEzMjg+XSBzaWdfaGFuZGxlcl9jb21tb25fc2thcysw
eGE4LzB4ZTANCmExNzA3ODU0OiAgWzxhMDAyNjE5YT5dIHNpZ19oYW5kbGVyKzB4NGEvMHg2MA0K
YTE3MDc4YWM6ICBbPGEwMTJhYzI2Pl0gdnNucHJpbnRmKzB4Mzk2LzB4NTkwDQphMTcwNzhlMDog
IFs8YTAwMTcyNTk+XSBtYXliZV9tYXArMHgyOS8weGIwDQphMTcwNzkwNDogIFs8YTAwMjk0NjI+
XSB3YWl0X3N0dWJfZG9uZSsweDUyLzB4MTUwDQphMTcwNzkyMDogIFs8YTAwMTc0Mzg+XSBkb19i
dWZmZXJfb3ArMHhmOC8weDFiMA0KYTE3MDc5MzA6ICBbPGEwMDE3NmMwPl0gY29weV9jaHVua190
b191c2VyKzB4MC8weDMwDQphMTcwNzk0NDogIFs8YTAwMjYwZTU+XSBzZXRfc2lnbmFscysweDI1
LzB4MzANCmExNzA3OTYwOiAgWzxhMDAyOTQ2Mj5dIHdhaXRfc3R1Yl9kb25lKzB4NTIvMHgxNTAN
CmExNzA3OTgwOiAgWzxhMDA5MzYxNT5dIGdldF9uZXdfaW5vZGVfZmFzdCsweDI1LzB4ZTANCmEx
NzA3OWFjOiAgWzxhMDAyYzYxND5dIHB0cmFjZV9zZXRyZWdzKzB4MTQvMHgzMA0KYTE3MDc5Yzg6
ICBbPGEwMDI4ZTg0Pl0gcnVuX3N5c2NhbGxfc3R1YisweGQ0LzB4MmQwDQphMTcwNzlmYzogIFs8
YTAwMTcyNTk+XSBtYXliZV9tYXArMHgyOS8weGIwDQphMTcwN2EyMDogIFs8YTAwMTc2YzA+XSBj
b3B5X2NodW5rX3RvX3VzZXIrMHgwLzB4MzANCmExNzA3YTI0OiAgWzxhMDAxNzJmZT5dIGRvX29w
X29uZV9wYWdlKzB4MWUvMHg2MA0KYTE3MDdhM2M6ICBbPGEwMDE3M2QyPl0gZG9fYnVmZmVyX29w
KzB4OTIvMHgxYjANCmExNzA3YTRjOiAgWzxhMDAxNzZjMD5dIGNvcHlfY2h1bmtfdG9fdXNlcisw
eDAvMHgzMA0KYTE3MDdhNTg6ICBbPGEwMDE3NmMwPl0gY29weV9jaHVua190b191c2VyKzB4MC8w
eDMwDQphMTcwN2E3ODogIFs8YTAwMjdhNjQ+XSBzZXRqbXBfd3JhcHBlcisweDM0LzB4NDANCmEx
NzA3YTk4OiAgWzxhMDAyN2E0OD5dIHNldGptcF93cmFwcGVyKzB4MTgvMHg0MA0KYTE3MDdhYmM6
ICBbPGEwMDE3MGQ4Pl0gZG9fb3BzKzB4ZjgvMHgxMTANCmExNzA3YjI0OiAgWzxhMDEyYWJlMT5d
IHZzbnByaW50ZisweDM1MS8weDU5MA0KYTE3MDdiNzA6ICBbPGEwMDlhNWY4Pl0gc2VxX3ByaW50
ZisweDI4LzB4NTANCmExNzA3YjhjOiAgWzxhMDA1NTE3Mj5dIHByaW50X3VubG9hZF9pbmZvKzB4
NTIvMHhkMA0KYTE3MDdiYWM6ICBbPGEwMDU3MzIxPl0gbV9zaG93KzB4MzEvMHhhMA0KYTE3MDdi
ZDQ6ICBbPGEwMDk5ZjIzPl0gc2VxX3JlYWQrMHhjMy8weDM0MA0KYTE3MDdjMDg6ICBbPGEwMDc4
OWQyPl0gdmZzX3JlYWQrMHhmMi8weDFlMA0KYTE3MDdjMzQ6ICBbPGEwMDc4ZTE4Pl0gc3lzX3Jl
YWQrMHgzOC8weDgwDQphMTcwN2M1YzogIFs8YTAwMTZmMDc+XSBoYW5kbGVfc3lzY2FsbCsweGY3
LzB4MWQwDQphMTcwN2M3ODogIFs8YTAwNzhkZTA+XSBzeXNfcmVhZCsweDAvMHg4MA0KYTE3MDdj
YjA6ICBbPGEwMDJhMTY4Pl0gdXNlcnNwYWNlKzB4MWM4LzB4MmUwDQphMTcwN2QwMDogIFs8YTAw
MTZiMzE+XSBmb3JrX2hhbmRsZXIrMHg5MS8weGEwDQphMTcwN2Q0ODogIFs8YTAwMTZhYTA+XSBm
b3JrX2hhbmRsZXIrMHgwLzB4YTANCmExNzA3ZDVjOiAgWzxhMDFlNGM0MT5dIGtpbGwrMHgxMS8w
eDIwDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCnNlcnZlcjE6fiMgbW9kcHJvYmUgaXB0X01B
U1FVRVJBREUNCk5ldGZpbHRlciBtZXNzYWdlcyB2aWEgTkVUTElOSyB2MC4zMC4NCmlwX2Nvbm50
cmFjayB2ZXJzaW9uIDIuNCAoMTU5IGJ1Y2tldHMsIDEyNzIgbWF4KSAtIDIyOCBieXRlcyBwZXIg
Y29ubnRyYWNrDQpzZXJ2ZXIxOn4jIG1vZHByb2JlIGlwX3RhYmxlcw0KaXBfdGFibGVzOiAoQykg
MjAwMC0yMDA2IE5ldGZpbHRlciBDb3JlIFRlYW0NCnNlcnZlcjE6fiMgbHNtb2QgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCk1vZHVsZSAgICAgICAgICAgICAgICAgIFNp
emUgIFVzZWQgYnkNCmlwX3RhYmxlcyAgICAgICAgICAgICAgMTIwNTYgIDAgW3Blcm1hbmVudF0N
CmlwdF9NQVNRVUVSQURFICAgICAgICAgIDI1MjggIDAgW3Blcm1hbmVudF0NCmlwX25hdCAgICAg
ICAgICAgICAgICAgMTUzNzIgIDEgaXB0X01BU1FVRVJBREUsW3Blcm1hbmVudF0NCnhfdGFibGVz
ICAgICAgICAgICAgICAgMTA4MjAgIDIgaXBfdGFibGVzLGlwdF9NQVNRVUVSQURFLFtwZXJtYW5l
bnRdDQppcF9jb25udHJhY2sgICAgICAgICAgIDQ1OTE2ICAyIGlwdF9NQVNRVUVSQURFLGlwX25h
dCxbcGVybWFuZW50XQ0KbmZuZXRsaW5rICAgICAgICAgICAgICAgNTM2OCAgMiBpcF9uYXQsaXBf
Y29ubnRyYWNrLFtwZXJtYW5lbnRdDQpzZXJ2ZXIxOn4jIGlwdGFibGVzIC10IG5hdCAtQSBQT1NU
Uk9VVElORyAtaiBNQVNRVUVSQURFDQpzZXJ2ZXIxOn4jIGxzbW9kDQpNb2R1bGUgICAgICAgICAg
ICAgICAgICBTaXplICBVc2VkIGJ5DQpLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogS2VybmVs
IG1vZGUgZmF1bHQgYXQgYWRkciAweGEwOGQzNSwgaXAgMHg0MDBkOGNiZQ0KIA0KRUlQOiAwMDcz
Ols8NDAwZDhjYmU+XSBDUFU6IDAgTm90IHRhaW50ZWQgRVNQOiAwMDdiOmJmN2FiNWQ4IEVGTEFH
UzogMDAyMDAyNDYNCiAgICBOb3QgdGFpbnRlZA0KRUFYOiBmZmZmZmZkYSBFQlg6IDAwMDAwMDAz
IEVDWDogNDAwMWEwMDAgRURYOiAwMDAwMDQwMA0KRVNJOiAwODA0YTAwOCBFREk6IDAwMDAwMDAw
IEVCUDogYmY3YWI1ZWMgRFM6IDAwN2IgRVM6IDAwN2INCmExNTk3NzI4OiAgWzxhMDA0NWNmOD5d
IG5vdGlmaWVyX2NhbGxfY2hhaW4rMHgyOC8weDUwDQphMTU5Nzc0NDogIFs8YTAwMzQ2MjA+XSBw
YW5pYysweDUwLzB4MTAwDQphMTU5Nzc1YzogIFs8YTAwMTM0MzM+XSBzZWd2KzB4MjAzLzB4MmQw
DQphMTU5Nzc4NDogIFs8YTAwMjhlODQ+XSBydW5fc3lzY2FsbF9zdHViKzB4ZDQvMHgyZDANCmEx
NTk3ODA0OiAgWzxhMDAxMzFiMj5dIHNlZ3ZfaGFuZGxlcisweDkyLzB4MTEwDQphMTU5NzgyODog
IFs8YTAwMTMxMjA+XSBzZWd2X2hhbmRsZXIrMHgwLzB4MTEwDQphMTU5NzgyYzogIFs8YTAwMmEz
Mjg+XSBzaWdfaGFuZGxlcl9jb21tb25fc2thcysweGE4LzB4ZTANCmExNTk3ODU0OiAgWzxhMDAy
NjE5YT5dIHNpZ19oYW5kbGVyKzB4NGEvMHg2MA0KYTE1OTc4YWM6ICBbPGEwMTJhYzI2Pl0gdnNu
cHJpbnRmKzB4Mzk2LzB4NTkwDQphMTU5NzhlMDogIFs8YTAwMTcyNTk+XSBtYXliZV9tYXArMHgy
OS8weGIwDQphMTU5NzkwNDogIFs8YTAwMjk0NjI+XSB3YWl0X3N0dWJfZG9uZSsweDUyLzB4MTUw
DQphMTU5NzkyMDogIFs8YTAwMTc0Mzg+XSBkb19idWZmZXJfb3ArMHhmOC8weDFiMA0KYTE1OTc5
MzA6ICBbPGEwMDE3NmMwPl0gY29weV9jaHVua190b191c2VyKzB4MC8weDMwDQphMTU5Nzk0NDog
IFs8YTAwMjYwZTU+XSBzZXRfc2lnbmFscysweDI1LzB4MzANCmExNTk3OTYwOiAgWzxhMDAyOTQ2
Mj5dIHdhaXRfc3R1Yl9kb25lKzB4NTIvMHgxNTANCmExNTk3OTgwOiAgWzxhMDA5MzYxNT5dIGdl
dF9uZXdfaW5vZGVfZmFzdCsweDI1LzB4ZTANCmExNTk3OWFjOiAgWzxhMDAyYzYxND5dIHB0cmFj
ZV9zZXRyZWdzKzB4MTQvMHgzMA0KYTE1OTc5Yzg6ICBbPGEwMDI4ZTg0Pl0gcnVuX3N5c2NhbGxf
c3R1YisweGQ0LzB4MmQwDQphMTU5NzlmYzogIFs8YTAwMTcyNTk+XSBtYXliZV9tYXArMHgyOS8w
eGIwDQphMTU5N2EyMDogIFs8YTAwMTc2YzA+XSBjb3B5X2NodW5rX3RvX3VzZXIrMHgwLzB4MzAN
CmExNTk3YTI0OiAgWzxhMDAxNzJmZT5dIGRvX29wX29uZV9wYWdlKzB4MWUvMHg2MA0KYTE1OTdh
M2M6ICBbPGEwMDE3M2QyPl0gZG9fYnVmZmVyX29wKzB4OTIvMHgxYjANCmExNTk3YTRjOiAgWzxh
MDAxNzZjMD5dIGNvcHlfY2h1bmtfdG9fdXNlcisweDAvMHgzMA0KYTE1OTdhNTg6ICBbPGEwMDE3
NmMwPl0gY29weV9jaHVua190b191c2VyKzB4MC8weDMwDQphMTU5N2E3ODogIFs8YTAwMjdhNjQ+
XSBzZXRqbXBfd3JhcHBlcisweDM0LzB4NDANCmExNTk3YTk4OiAgWzxhMDAyN2E0OD5dIHNldGpt
cF93cmFwcGVyKzB4MTgvMHg0MA0KYTE1OTdhYmM6ICBbPGEwMDE3MGQ4Pl0gZG9fb3BzKzB4Zjgv
MHgxMTANCmExNTk3YjI0OiAgWzxhMDEyYWJlMT5dIHZzbnByaW50ZisweDM1MS8weDU5MA0KYTE1
OTdiNzA6ICBbPGEwMDlhNWY4Pl0gc2VxX3ByaW50ZisweDI4LzB4NTANCmExNTk3YjhjOiAgWzxh
MDA1NTE3Mj5dIHByaW50X3VubG9hZF9pbmZvKzB4NTIvMHhkMA0KYTE1OTdiYWM6ICBbPGEwMDU3
MzIxPl0gbV9zaG93KzB4MzEvMHhhMA0KYTE1OTdiZDQ6ICBbPGEwMDk5ZjIzPl0gc2VxX3JlYWQr
MHhjMy8weDM0MA0KYTE1OTdjMDg6ICBbPGEwMDc4OWQyPl0gdmZzX3JlYWQrMHhmMi8weDFlMA0K
YTE1OTdjMzQ6ICBbPGEwMDc4ZTE4Pl0gc3lzX3JlYWQrMHgzOC8weDgwDQphMTU5N2M1YzogIFs8
YTAwMTZmMDc+XSBoYW5kbGVfc3lzY2FsbCsweGY3LzB4MWQwDQphMTU5N2M3ODogIFs8YTAwNzhk
ZTA+XSBzeXNfcmVhZCsweDAvMHg4MA0KYTE1OTdjYjA6ICBbPGEwMDJhMTY4Pl0gdXNlcnNwYWNl
KzB4MWM4LzB4MmUwDQphMTU5N2QwMDogIFs8YTAwMTZiMzE+XSBmb3JrX2hhbmRsZXIrMHg5MS8w
eGEwDQphMTU5N2Q0ODogIFs8YTAwMTZhYTA+XSBmb3JrX2hhbmRsZXIrMHgwLzB4YTANCmExNTk3
ZDVjOiAgWzxhMDFlNGM0MT5dIGtpbGwrMHgxMS8weDIwDQoNCj==


--=-EGpeTc6SNp1YvxOd0ayi--

--=-9pyEvJqpeBBM5h8rhqIN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFPjJmGadwPDPpB60RAk6sAJ0XqU2Kco6wHIYaopbtSuQFbUQ1GwCdGeqY
VAQwIWuAYMt06uC6rVEfaRs=
=DP8A
-----END PGP SIGNATURE-----

--=-9pyEvJqpeBBM5h8rhqIN--
