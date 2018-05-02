From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Thu, 3 May 2018 01:54:34 +0200
Message-ID: <CAKfDRXiO7qKHGLf5faSy7g_f1p9budJLXS9-uZWLPgyx3OAJbA@mail.gmail.com>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
 <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc> <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="00000000000027519d056b41cf07"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--00000000000027519d056b41cf07
Content-Type: text/plain; charset="UTF-8"

Hello,

On Wed, May 2, 2018 at 12:42 AM, Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> My knowledge of the conntrack/nat subsystem is not that great, and I
> don't know the implications of what I am about to suggest. However,
> considering that the two packets represent the same flow, wouldn't it
> be possible to apply the existing nat-mapping to the second packet,
> and then let the second packet pass?

I have spent the day today trying to solve my problem and I think I am
almost there. I have attached my work in progress patch to this email
if anyone wants to take a look (for kernel 4.14).

I went for the early-insert approached and have patched
nfnetlink_queue to perform an insert if no conntrack entry is found
when the verdict is passed from user-space. If a conntrack entry is
found, then I replace the ct attached to the skb with the existing
conntrack entry. I have verified that my approach works by
artificially delaying the verdict from my application for the second
packet (so that the first packet has passed all netfilter hooks).
After replacing the ct, the second packet is handled correctly and
sent over the wire.

However, something goes wrong after the conntrack entry has been
inserted (using nf_conntrack_hash_check_insert()). At some random (but
very short) time after I see a couple of "early insert ..."/"early
insert confirmed", I get an RCU-stall. The trace for the stall looks
as follows:

[  105.420024] INFO: rcu_sched self-detected stall on CPU
[  105.425191]  2-...: (5999 ticks this GP) idle=12a/140000000000001/0
softirq=2674/2674 fqs=2543
[  105.433845]   (t=6001 jiffies g=587 c=586 q=5896)
[  105.438545] CPU: 2 PID: 3632 Comm: dlb Not tainted 4.14.36 #0
[  105.444261] Stack : 00000000 00000000 00000000 00000000 805c7ada
00000031 00000000 8052c588
[  105.452610]         8fd48ff4 805668e7 804f5a2c 00000002 00000e30
00000001 8fc11d20 00000007
[  105.460957]         00000000 00000000 805c0000 00007448 00000000
0000016e 00000007 00000000
[  105.469303]         00000000 80570000 0006b111 00000000 80000000
00000000 80590000 804608e4
[  105.477650]         8056c2c0 8056408c 000000e0 80560000 00000000
8027c418 00000008 805c0008
[  105.485996]         ...
[  105.488437] Call Trace:
[  105.490909] [<800103f8>] show_stack+0x58/0x100
[  105.495363] [<8043c1dc>] dump_stack+0x9c/0xe0
[  105.499707] [<8000d938>] arch_trigger_cpumask_backtrace+0x50/0x78
[  105.505785] [<80083540>] rcu_dump_cpu_stacks+0xc4/0x134
[  105.510991] [<800829c4>] rcu_check_callbacks+0x310/0x814
[  105.516295] [<80085f04>] update_process_times+0x34/0x70
[  105.521522] [<8009691c>] tick_handle_periodic+0x34/0xd0
[  105.526749] [<802f6e98>] gic_compare_interrupt+0x48/0x58
[  105.532047] [<80076450>] handle_percpu_devid_irq+0xbc/0x1a8
[  105.537619] [<800707c0>] generic_handle_irq+0x40/0x58
[  105.542679] [<8023a274>] gic_handle_local_int+0x84/0xd0
[  105.547886] [<8023a434>] gic_irq_dispatch+0x10/0x20
[  105.552747] [<800707c0>] generic_handle_irq+0x40/0x58
[  105.557806] [<804591b4>] do_IRQ+0x1c/0x2c
[  105.561805] [<802394bc>] plat_irq_dispatch+0xfc/0x138
[  105.566839] [<8000b508>] except_vec_vi_end+0xb8/0xc4
[  105.571904] [<8f200ca4>] nf_conntrack_lock+0x28c/0x440 [nf_conntrack]
[  105.578341] ------------[ cut here ]------------
[  105.582948] WARNING: CPU: 2 PID: 3632 at kernel/smp.c:416
smp_call_function_many+0xc8/0x3bc
[  105.591257] Modules linked in: rt2800pci rt2800mmio rt2800lib
qcserial ppp_async option usb_wwan rt2x00pci rt2x00mmio rt2x00lib
rndis_host qmi_wwan ppp_generic nf_nat_pptp nf_conntrack_pptp
nf_conntrack_ipv6p
[  105.662308]  nf_nat_snmp_basic nf_nat_sip nf_nat_redirect
nf_nat_proto_gre nf_nat_masquerade_ipv4 nf_nat_irc nf_conntrack_ipv4
nf_nat_ipv4 nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_nat nf_log_ipv4
nf_flow_tablt
[  105.733288]  ip_set_hash_netiface ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_net ip_set_hash_netportnet
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmarm
[  105.804724]  ohci_hcd ehci_platform sd_mod scsi_mod ehci_hcd
gpio_button_hotplug usbcore nls_base usb_common mii
[  105.814899] CPU: 2 PID: 3632 Comm: dlb Not tainted 4.14.36 #0
[  105.820615] Stack : 00000000 00000000 00000000 00000000 805c7ada
00000031 00000000 8052c588
[  105.828961]         8fd48ff4 805668e7 804f5a2c 00000002 00000e30
00000001 8fc11c88 00000007
[  105.837308]         00000000 00000000 805c0000 00008590 00000000
0000018d 00000007 00000000
[  105.845654]         00000000 80570000 000c6f33 00000000 80000000
00000000 80590000 8009e304
[  105.854001]         00000009 000001a0 8000d0fc 00000000 00000000
8027c418 00000008 805c0008
[  105.862348]         ...
[  105.864786] Call Trace:
[  105.867230] [<800103f8>] show_stack+0x58/0x100
[  105.871662] [<8043c1dc>] dump_stack+0x9c/0xe0
[  105.876009] [<8002e190>] __warn+0xe0/0x114
[  105.880091] [<8002e254>] warn_slowpath_null+0x1c/0x28
[  105.885124] [<8009e304>] smp_call_function_many+0xc8/0x3bc
[  105.890591] [<8000d950>] arch_trigger_cpumask_backtrace+0x68/0x78
[  105.896663] [<80083540>] rcu_dump_cpu_stacks+0xc4/0x134
[  105.901869] [<800829c4>] rcu_check_callbacks+0x310/0x814
[  105.907164] [<80085f04>] update_process_times+0x34/0x70
[  105.912374] [<8009691c>] tick_handle_periodic+0x34/0xd0
[  105.917585] [<802f6e98>] gic_compare_interrupt+0x48/0x58
[  105.922878] [<80076450>] handle_percpu_devid_irq+0xbc/0x1a8
[  105.928434] [<800707c0>] generic_handle_irq+0x40/0x58
[  105.933474] [<8023a274>] gic_handle_local_int+0x84/0xd0
[  105.938681] [<8023a434>] gic_irq_dispatch+0x10/0x20
[  105.943542] [<800707c0>] generic_handle_irq+0x40/0x58
[  105.948581] [<804591b4>] do_IRQ+0x1c/0x2c
[  105.952580] [<802394bc>] plat_irq_dispatch+0xfc/0x138
[  105.957613] [<8000b508>] except_vec_vi_end+0xb8/0xc4
[  105.962602] [<8f200ca4>] nf_conntrack_lock+0x28c/0x440 [nf_conntrack]
[  105.969038] ---[ end trace 0b9e3b8a6909a0fb ]---
[  105.973638] INFO: rcu_sched detected stalls on CPUs/tasks:
[  105.979149]  2-...: (6054 ticks this GP) idle=12a/140000000000000/0
softirq=2674/2674 fqs=2544
[  105.987818]  (detected by 3, t=6056 jiffies, g=587, c=586, q=5896)
[  105.993996] ------------[ cut here ]------------
[  105.998615] WARNING: CPU: 3 PID: 0 at kernel/smp.c:291
smp_call_function_single+0xc0/0x18c
[  106.006841] Modules linked in: rt2800pci rt2800mmio rt2800lib
qcserial ppp_async option usb_wwan rt2x00pci rt2x00mmio rt2x00lib
rndis_host qmi_wwan ppp_generic nf_nat_pptp nf_conntrack_pptp
nf_conntrack_ipv6p
[  106.077960]  nf_nat_snmp_basic nf_nat_sip nf_nat_redirect
nf_nat_proto_gre nf_nat_masquerade_ipv4 nf_nat_irc nf_conntrack_ipv4
nf_nat_ipv4 nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_nat nf_log_ipv4
nf_flow_tablt
[  106.148997]  ip_set_hash_netiface ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_net ip_set_hash_netportnet
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmarm
[  106.220489]  ohci_hcd ehci_platform sd_mod scsi_mod ehci_hcd
gpio_button_hotplug usbcore nls_base usb_common mii
[  106.230686] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W
4.14.36 #0
[  106.237876] Stack : 00000000 00000000 00000000 00000000 805c7ada
00000042 00000000 8052c588
[  106.246232]         8fc44e74 805668e7 804f5a2c 00000003 00000000
00000001 8fc15c80 00000007
[  106.254587]         00000000 00000000 805c0000 000098c0 00000000
000001b3 00000007 00000000
[  106.262942]         00000000 80570000 0003851e 00000000 00000000
00000000 80590000 8009dfb0
[  106.271299]         00000009 00000123 000000e0 80560000 00000001
8027c418 0000000c 805c000c
[  106.279653]         ...
[  106.282097] Call Trace:
[  106.284563] [<800103f8>] show_stack+0x58/0x100
[  106.289026] [<8043c1dc>] dump_stack+0x9c/0xe0
[  106.293380] [<8002e190>] __warn+0xe0/0x114
[  106.297467] [<8002e254>] warn_slowpath_null+0x1c/0x28
[  106.302506] [<8009dfb0>] smp_call_function_single+0xc0/0x18c
[  106.308150] [<8000d950>] arch_trigger_cpumask_backtrace+0x68/0x78
[  106.314235] [<80083540>] rcu_dump_cpu_stacks+0xc4/0x134
[  106.319445] [<80082c8c>] rcu_check_callbacks+0x5d8/0x814
[  106.324757] [<80085f04>] update_process_times+0x34/0x70
[  106.329992] [<8009691c>] tick_handle_periodic+0x34/0xd0
[  106.335230] [<802f6e98>] gic_compare_interrupt+0x48/0x58
[  106.340537] [<80076450>] handle_percpu_devid_irq+0xbc/0x1a8
[  106.346118] [<800707c0>] generic_handle_irq+0x40/0x58
[  106.351190] [<8023a274>] gic_handle_local_int+0x84/0xd0
[  106.356402] [<8023a434>] gic_irq_dispatch+0x10/0x20
[  106.361270] [<800707c0>] generic_handle_irq+0x40/0x58
[  106.366339] [<804591b4>] do_IRQ+0x1c/0x2c
[  106.370344] [<802394bc>] plat_irq_dispatch+0xfc/0x138
[  106.375383] [<8000b508>] except_vec_vi_end+0xb8/0xc4
[  106.380336] [<8000ced0>] r4k_wait_irqoff+0x1c/0x24
[  106.385146] [<80065f6c>] do_idle+0xe4/0x168
[  106.389322] [<800661e8>] cpu_startup_entry+0x24/0x2c
[  106.394275] ---[ end trace 0b9e3b8a6909a0fc ]---
[  106.398888] CPU: 2 PID: 3632 Comm: dlb Tainted: G        W       4.14.36 #0
[  106.405819] task: 8fd48c80 task.stack: 8e274000
[  106.410324] $ 0   : 00000000 00000001 814b7588 00000001
[  106.415544] $ 4   : 09036633 80564198 71804fce d0db5a72
[  106.420763] $ 8   : 00000000 8aee9400 814bee18 00157558
[  106.425982] $12   : 00000000 00000000 fffffffe 00000114
[  106.431201] $16   : 00005b78 8e275998 8e874540 80560000
[  106.436421] $20   : 00000001 8f210000 00005a31 8f210000
[  106.441639] $24   : 00000000 80015e5c
[  106.446857] $28   : 8e274000 8e275940 8f210000 8f201634
[  106.452078] Hi    : 00005a31
[  106.454942] Lo    : 6e620000
[  106.457912] epc   : 8f2017f4 nf_conntrack_tuple_taken+0x258/0x308
[nf_conntrack]
[  106.465299] ra    : 8f201634 nf_conntrack_tuple_taken+0x98/0x308
[nf_conntrack]
[  106.472571] Status: 11007c03 KERNEL EXL IE
[  106.476748] Cause : 50800400 (ExcCode 00)
[  106.480738] PrId  : 0001992f (MIPS 1004Kc)
[  106.484819] CPU: 2 PID: 3632 Comm: dlb Tainted: G        W       4.14.36 #0
[  106.491742] Stack : 00000000 00000000 00000000 00000000 805c7ada
0000003f 00000000 8052c588
[  106.500088]         8fd48ff4 805668e7 804f5a2c 00000002 00000e30
00000001 8fc11d68 00000007
[  106.508435]         00000000 00000000 805c0000 0000a498 00000000
000001e3 00000007 00000000
[  106.516779]         00000000 80570000 000765d3 00000000 80000000
00000000 80590000 8000d0fc
[  106.525126]         804fce50 805574e0 804faa5c 80570000 00000002
8027c418 00000008 805c0008
[  106.533473]         ...
[  106.535911] Call Trace:
[  106.538356] [<800103f8>] show_stack+0x58/0x100
[  106.542788] [<8043c1dc>] dump_stack+0x9c/0xe0
[  106.547130] [<8009dccc>] flush_smp_call_function_queue+0x144/0x1d8
[  106.553294] [<80015830>] ipi_call_interrupt+0x10/0x20
[  106.558336] [<80071380>] __handle_irq_event_percpu+0x78/0x18c
[  106.564061] [<800714b4>] handle_irq_event_percpu+0x20/0x64
[  106.569528] [<80071558>] handle_irq_event+0x60/0xa8
[  106.574388] [<800757d0>] handle_edge_irq+0x204/0x25c
[  106.579337] [<800707c0>] generic_handle_irq+0x40/0x58
[  106.584377] [<8023a3c8>] gic_handle_shared_int+0x108/0x164
[  106.589844] [<800707c0>] generic_handle_irq+0x40/0x58
[  106.594883] [<804591b4>] do_IRQ+0x1c/0x2c
[  106.598880] [<802394bc>] plat_irq_dispatch+0xfc/0x138
[  106.603913] [<8000b508>] except_vec_vi_end+0xb8/0xc4
[  106.608901] [<8f2017f4>] nf_conntrack_tuple_taken+0x258/0x308 [nf_conntrack]
[  106.615963] [<8f1fcd88>] nf_ct_nat_ext_add+0x7ac/0x908 [nf_nat]

I instrumented nf_conntrack_tuple_taken() and it seems that what
happens, is that tuple_taken() spins on the "goto begin"-part. I am
probably doing something wrong with my insert, but I am not able to
see what. Is anyone able to see what is wrong, or can provide me with
pointers on where to look? When looking at the syslog, I also noticed
the following:

[   45.394817] early insert: tuple 17 192.168.6.2:36376 -> 1.1.1.1:53
[   45.401056] early insert confirmed
[   45.405468] early insert: tuple 17 192.168.6.2:36376 -> 1.1.1.1:53
[   45.411996] early insert confirmed

I.e., the entry created by the first packet is not found when the
second packet is handled. Could it be some synchronization step that I
am missing?

Thanks in advance for any help,
Kristian

--00000000000027519d056b41cf07
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-NFQUEUE-early-insert.patch"
Content-Disposition: attachment; filename="0001-NFQUEUE-early-insert.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jgppvygj0

RnJvbSBjZmI0ZTgxODc5NDBiODlhY2YxNjNhN2Y0MTgxYmYwNGFiZDMzM2QwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLcmlzdGlhbiBFdmVuc2VuIDxrcmlzdGlhbi5ldmVuc2VuQGdt
YWlsLmNvbT4KRGF0ZTogVHVlLCAxIE1heSAyMDE4IDIyOjQ0OjE2ICswMjAwClN1YmplY3Q6IFtQ
QVRDSF0gTkZRVUVVRSBlYXJseSBpbnNlcnQKCi0tLQogbmV0L25ldGZpbHRlci9uZm5ldGxpbmtf
cXVldWUuYyB8IDY5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiAx
IGZpbGUgY2hhbmdlZCwgNjkgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0
ZXIvbmZuZXRsaW5rX3F1ZXVlLmMgYi9uZXQvbmV0ZmlsdGVyL25mbmV0bGlua19xdWV1ZS5jCmlu
ZGV4IGM5Nzk2NjI5OC4uMjU0ODY2ZDVjIDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mbmV0
bGlua19xdWV1ZS5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX3F1ZXVlLmMKQEAgLTQz
LDYgKzQzLDkgQEAKIAogI2lmIElTX0VOQUJMRUQoQ09ORklHX05GX0NPTk5UUkFDSykKICNpbmNs
dWRlIDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFjay5oPgorI2luY2x1ZGUgPG5ldC9uZXRmaWx0
ZXIvbmZfY29ubnRyYWNrX2NvcmUuaD4KKyNpbmNsdWRlIDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19sM3Byb3RvLmg+CisjaW5jbHVkZSA8bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbDRw
cm90by5oPgogI2VuZGlmCiAKICNkZWZpbmUgTkZRTkxfUU1BWF9ERUZBVUxUIDEwMjQKQEAgLTEx
NTEsNiArMTE1NCw2NCBAQCBzdGF0aWMgaW50IG5mcWFfcGFyc2VfYnJpZGdlKHN0cnVjdCBuZl9x
dWV1ZV9lbnRyeSAqZW50cnksCiAJcmV0dXJuIDA7CiB9CiAKKyNpZiBJU19FTkFCTEVEKENPTkZJ
R19ORl9DT05OVFJBQ0spCitzdGF0aWMgdm9pZCBuZnFubF91cGRhdGVfY3Qoc3RydWN0IG5ldCAq
bmV0LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQoreworCXN0cnVjdCBuZl9jb25uICpjdCA9IE5VTEw7
CisJZW51bSBpcF9jb25udHJhY2tfaW5mbyBjdGluZm87CisJY29uc3Qgc3RydWN0IG5mX2Nvbm50
cmFja19sM3Byb3RvICpsM3Byb3RvOworCWNvbnN0IHN0cnVjdCBuZl9jb25udHJhY2tfbDRwcm90
byAqbDRwcm90bzsKKwl1X2ludDE2X3QgbDNudW07CisJdW5zaWduZWQgaW50IGRhdGFvZmY7CisJ
dV9pbnQ4X3QgbDRudW07CisJc3RydWN0IG5mX2Nvbm50cmFja190dXBsZSB0dXBsZTsKKwlzdHJ1
Y3QgbmZfY29ubnRyYWNrX3R1cGxlX2hhc2ggKmg7CisKKwljdCA9IG5mX2N0X2dldChza2IsICZj
dGluZm8pOworCWwzbnVtID0gbmZfY3RfbDNudW0oY3QpOworCWwzcHJvdG8gPSBuZl9jdF9sM3By
b3RvX2ZpbmRfZ2V0KGwzbnVtKTsKKworCWlmIChsM3Byb3RvLT5nZXRfbDRwcm90byhza2IsIHNr
Yl9uZXR3b3JrX29mZnNldChza2IpLCAmZGF0YW9mZiwKKwkJCQkgJmw0bnVtKSA8PSAwKSB7CisJ
CXByX2luZm8oIkZhaWxlZCB0byBnZXQgbDQgcHJvdG9udW1cbiIpOworCQlyZXR1cm47CisJfQor
CisJbDRwcm90byA9IG5mX2N0X2w0cHJvdG9fZmluZF9nZXQobDNudW0sIGw0bnVtKTsKKworCWlm
ICghbmZfY3RfZ2V0X3R1cGxlKHNrYiwgc2tiX25ldHdvcmtfb2Zmc2V0KHNrYiksIGRhdGFvZmYs
IGwzbnVtLAorCQkJICAgICBsNG51bSwgbmV0LCAmdHVwbGUsIGwzcHJvdG8sIGw0cHJvdG8pKSB7
CisJCXByX2luZm8oIkZhaWxlZCB0byBnZXQgdHVwbGVcbiIpOworCQlyZXR1cm47CisJfQorCisj
aWYgSVNfRU5BQkxFRChDT05GSUdfTkZfQ09OTlRSQUNLX1pPTkVTKQorCWggPSBuZl9jb25udHJh
Y2tfZmluZF9nZXQobmV0LCAmKGN0LT56b25lKSwgJnR1cGxlKTsKKyNlbHNlCisJaCA9IG5mX2Nv
bm50cmFja19maW5kX2dldChuZXQsIE5VTEwsICZ0dXBsZSk7CisjZW5kaWYKKworCWlmICghaCkg
eworCQlwcl9pbmZvKCJlYXJseSBpbnNlcnQ6IHR1cGxlICV1ICVwSTQ6JWh1IC0+ICVwSTQ6JWh1
XG4iLAorCQkgICAgICAgdHVwbGUuZHN0LnByb3RvbnVtLCAmKHR1cGxlLnNyYy51My5pcCksIG50
b2hzKHR1cGxlLnNyYy51LmFsbCksCisJICAgICAgIAkgICAgICAgJih0dXBsZS5kc3QudTMuaXAp
LCBudG9ocyh0dXBsZS5kc3QudS5hbGwpKTsKKworCQlyY3VfcmVhZF9sb2NrKCk7CisJCWlmICgh
bmZfY29ubnRyYWNrX2hhc2hfY2hlY2tfaW5zZXJ0KGN0KSkgeworCQkJcHJfaW5mbygiZWFybHkg
aW5zZXJ0IGNvbmZpcm1lZFxuIik7CisJCX0KKwkJcmN1X3JlYWRfdW5sb2NrKCk7CisJfSBlbHNl
IHsKKwkJcHJfaW5mbygicmVwbGFjZTogdHVwbGUgJXUgJXBJNDolaHUgLT4gJXBJNDolaHVcbiIs
CisJCSAgICAgICB0dXBsZS5kc3QucHJvdG9udW0sICYodHVwbGUuc3JjLnUzLmlwKSwgbnRvaHMo
dHVwbGUuc3JjLnUuYWxsKSwKKwkgICAgICAgCSAgICAgICAmKHR1cGxlLmRzdC51My5pcCksIG50
b2hzKHR1cGxlLmRzdC51LmFsbCkpOworCQluZl9jdF9wdXQoY3QpOworCQljdCA9IG5mX2N0X3R1
cGxlaGFzaF90b19jdHJhY2soaCk7CisJCW5mX2N0X3NldChza2IsIGN0LCBJUF9DVF9ORVcpOwor
CX0KK30KKyNlbmRpZgorCiBzdGF0aWMgaW50IG5mcW5sX3JlY3ZfdmVyZGljdChzdHJ1Y3QgbmV0
ICpuZXQsIHN0cnVjdCBzb2NrICpjdG5sLAogCQkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiwK
IAkJCSAgICAgIGNvbnN0IHN0cnVjdCBubG1zZ2hkciAqbmxoLApAQCAtMTIxMyw2ICsxMjc0LDE0
IEBAIHN0YXRpYyBpbnQgbmZxbmxfcmVjdl92ZXJkaWN0KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0
IHNvY2sgKmN0bmwsCiAJaWYgKG5mcWFbTkZRQV9NQVJLXSkKIAkJZW50cnktPnNrYi0+bWFyayA9
IG50b2hsKG5sYV9nZXRfYmUzMihuZnFhW05GUUFfTUFSS10pKTsKIAorI2lmIElTX0VOQUJMRUQo
Q09ORklHX05GX0NPTk5UUkFDSykKKwluZl9jdF9nZXQoZW50cnktPnNrYiwgJmN0aW5mbyk7CisK
KwlpZiAoY3RpbmZvID09IElQX0NUX05FVyAmJiB2ZXJkaWN0ICE9IE5GX1NUT0xFTiAmJiB2ZXJk
aWN0ICE9IE5GX0RST1ApIHsKKwkJbmZxbmxfdXBkYXRlX2N0KG5ldCwgZW50cnktPnNrYik7CisJ
fQorI2VuZGlmCisKIAluZl9yZWluamVjdChlbnRyeSwgdmVyZGljdCk7CiAJcmV0dXJuIDA7CiB9
Ci0tIAoyLjE0LjEKCg==
--00000000000027519d056b41cf07--
