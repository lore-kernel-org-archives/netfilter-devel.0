From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 14:40:19 +0100
Message-ID: <20180216134023.15536-1-daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a very rough and early proof of concept that implements bpfilter.
The basic idea of bpfilter is that it can process iptables queries and
translate them in user space into BPF programs which can then get attached
at various locations. For simplicity, in this RFC we demo attaching them
to XDP layer, but any other location would work as well (e.g. at the tc
sch_clsact ingress/egress location or any other/new hook with equivalent
semantics).

Also, as a benefit from such design, we get BPF JIT compilation on x86_64,
arm64, ppc64, sparc64, mips64, s390x and arm32, but also rule offloading
into HW for free for Netronome NFP SmartNICs that are already capable of
offloading BPF since we can reuse all existing BPF infrastructure as the
back end. The user space iptables binary issuing rule addition or dumps was
left as-is, thus at some point any binaries against iptables uapi kernel
interface could transparently be supported in such manner in long term.

As rule translation can potentially become very complex, this is performed
entirely in user space. In order to ease deployment, request_module() code
is extended to allow user mode helpers to be invoked. Idea is that user mode
helpers are built as part of the kernel build and installed as traditional
kernel modules with .ko file extension into distro specified location,
such that from a distribution point of view, they are no different than
regular kernel modules. Thus, allow request_module() logic to load such
user mode helper (umh) binaries via:

  request_module("foo") ->
    call_umh("modprobe foo") ->
      sys_finit_module(FD of /lib/modules/.../foo.ko) ->
        call_umh(struct file)

Such approach enables kernel to delegate functionality traditionally done
by kernel modules into user space processes (either root or !root) and
reduces security attack surface of such new code, meaning in case of
potential bugs only the umh would crash but not the kernel. Another
advantage coming with that would be that bpfilter.ko can be debugged and
tested out of user space as well (e.g. opening the possibility to run
all clang sanitizers, fuzzers or test suites for checking translation).
Also, such architecture makes the kernel/user boundary very precise,
meaning requests can be handled and BPF translated in control plane part
in user space with its own user memory etc, while minimal data plane
bits are in kernel. It would also allow to remove old xtables modules
at some point from the kernel while keeping functionality in place.

In the implemented proof of concept we show that simple /32 src/dst IPs
are translated in such manner. More complex rules would be added later
as well, also different BPF code generation backends that can be selected
for the various attachment points, proper encoder/decoder for the uapi
requests, etc. This just starts out very simple and basic for the sake
of an early RFC to demo the idea.

In the below example, we show that dumping, loading and offloading of
one or multiple simple rules work, we show the bpftool XDP dump of the
generated BPF instruction sequence as well as a simple functional ping
test to enforce policy in such way.

Set rebased on top of 255442c93843 ("Merge tag 'docs-4.16' of [...]").

Feedback very welcome!

Various bpfilter usage examples from the PoC code:

1) Dumping current rules:

  # iptables -t filter -L
  Chain INPUT (policy ACCEPT)
  target     prot opt source               destination

  Chain FORWARD (policy ACCEPT)
  target     prot opt source               destination

  Chain OUTPUT (policy ACCEPT)
  target     prot opt source               destination

2) ping test:

  # ping -c 1 127.0.0.1 -I 127.0.0.2
    PING 127.0.0.1 (127.0.0.1) from 127.0.0.2 : 56(84) bytes of data.
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.040 ms

    --- 127.0.0.1 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.040/0.040/0.040/0.000 ms

3) Adding & dumping a simple rule:

  # iptables -t filter -A INPUT -i lo -s 127.0.0.2/32 -d 127.0.0.1/32 -j DROP
  # iptables -t filter -L
  Chain INPUT (policy ACCEPT)
  target     prot opt source               destination
  DROP       all  --  127.0.0.2            localhost

  Chain FORWARD (policy ACCEPT)
  target     prot opt source               destination

  Chain OUTPUT (policy ACCEPT)
  target     prot opt source               destination

4) Dump BPF generated code for that rule (on lo it's XDP generic, otherwise
   native XDP for XDP supported drivers):

  # bpftool p
    18: xdp  tag 6b07f663830d5b0c
        loaded_at Feb 14/01:15  uid 0
        xlated 208B  not jited  memlock 4096B
  # bpftool p d x i 18
   0: (bf) r9 = r1
   1: (79) r2 = *(u64 *)(r9 +0)
   2: (79) r3 = *(u64 *)(r9 +8)
   3: (bf) r1 = r2
   4: (07) r1 += 14
   5: (bd) if r1 <= r3 goto pc+2
   6: (b4) (u32) r0 = (u32) 2
   7: (95) exit
   8: (bf) r1 = r2
   9: (b4) (u32) r5 = (u32) 0
  10: (69) r4 = *(u16 *)(r1 +12)
  11: (55) if r4 != 0x8 goto pc+9
  12: (07) r1 += 34
  13: (2d) if r1 > r3 goto pc+7
  14: (07) r1 += -20
  15: (61) r4 = *(u32 *)(r1 +12)
  16: (55) if r4 != 0x200007f goto pc+1
  17: (04) (u32) r5 += (u32) 1
  18: (61) r4 = *(u32 *)(r1 +16)
  19: (55) if r4 != 0x100007f goto pc+1
  20: (04) (u32) r5 += (u32) 1
  21: (55) if r5 != 0x2 goto pc+2
  22: (b4) (u32) r0 = (u32) 1
  23: (95) exit
  24: (b4) (u32) r0 = (u32) 2
  25: (95) exit

5) ping test:

  # ping -c 1 127.0.0.1 -I 127.0.0.2
    PING 127.0.0.1 (127.0.0.1) from 127.0.0.2 : 56(84) bytes of data.

    --- 127.0.0.1 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 0ms

  # ping -c 1 127.0.0.1 -I 127.0.0.1
    PING 127.0.0.1 (127.0.0.1) from 127.0.0.1 : 56(84) bytes of data.
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.018 ms

    --- 127.0.0.1 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.018/0.018/0.018/0.000 ms

  # ping -c 1 127.0.0.2 -I 127.0.0.2
    PING 127.0.0.2 (127.0.0.2) from 127.0.0.2 : 56(84) bytes of data.
    64 bytes from 127.0.0.2: icmp_seq=1 ttl=64 time=0.018 ms

    --- 127.0.0.2 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.018/0.018/0.018/0.000 ms

6) Adding & dumping a 2nd and 3rd rule:

  # iptables -t filter -A INPUT -i lo -s 127.0.0.4/32 -d 127.0.0.3/32 -j DROP
  # iptables -t filter -A INPUT -i lo -s 127.0.0.5/32 -j DROP
  # iptables -t filter -L
  Chain INPUT (policy ACCEPT)
  target     prot opt source               destination
  DROP       all  --  127.0.0.2            localhost
  DROP       all  --  127.0.0.4            127.0.0.3
  DROP       all  --  anywhere             127.0.0.5

  Chain FORWARD (policy ACCEPT)
  target     prot opt source               destination

  Chain OUTPUT (policy ACCEPT)
  target     prot opt source               destination

7) Dump BPF generated code again:

  # bpftool p
    20: xdp  tag 19519bdd253cbfe5
        loaded_at Feb 14/01:17  uid 0
        xlated 440B  not jited  memlock 4096B
  # bpftool p d x i 20
   0: (bf) r9 = r1
   1: (79) r2 = *(u64 *)(r9 +0)
   2: (79) r3 = *(u64 *)(r9 +8)
   3: (bf) r1 = r2
   4: (07) r1 += 14
   5: (bd) if r1 <= r3 goto pc+2
   6: (b4) (u32) r0 = (u32) 2
   7: (95) exit
   8: (bf) r1 = r2
   9: (b4) (u32) r5 = (u32) 0
  10: (69) r4 = *(u16 *)(r1 +12)
  11: (55) if r4 != 0x8 goto pc+9
  12: (07) r1 += 34
  13: (2d) if r1 > r3 goto pc+7
  14: (07) r1 += -20
  15: (61) r4 = *(u32 *)(r1 +12)
  16: (55) if r4 != 0x200007f goto pc+1
  17: (04) (u32) r5 += (u32) 1
  18: (61) r4 = *(u32 *)(r1 +16)
  19: (55) if r4 != 0x100007f goto pc+1
  20: (04) (u32) r5 += (u32) 1
  21: (55) if r5 != 0x2 goto pc+2
  22: (b4) (u32) r0 = (u32) 1
  23: (95) exit
  24: (bf) r1 = r2
  25: (b4) (u32) r5 = (u32) 0
  26: (69) r4 = *(u16 *)(r1 +12)
  27: (55) if r4 != 0x8 goto pc+9
  28: (07) r1 += 34
  29: (2d) if r1 > r3 goto pc+7
  30: (07) r1 += -20
  31: (61) r4 = *(u32 *)(r1 +12)
  32: (55) if r4 != 0x400007f goto pc+1
  33: (04) (u32) r5 += (u32) 1
  34: (61) r4 = *(u32 *)(r1 +16)
  35: (55) if r4 != 0x300007f goto pc+1
  36: (04) (u32) r5 += (u32) 1
  37: (55) if r5 != 0x2 goto pc+2
  38: (b4) (u32) r0 = (u32) 1
  39: (95) exit
  40: (bf) r1 = r2
  41: (b4) (u32) r5 = (u32) 0
  42: (69) r4 = *(u16 *)(r1 +12)
  43: (55) if r4 != 0x8 goto pc+6
  44: (07) r1 += 34
  45: (2d) if r1 > r3 goto pc+4
  46: (07) r1 += -20
  47: (61) r4 = *(u32 *)(r1 +12)
  48: (55) if r4 != 0x500007f goto pc+1
  49: (04) (u32) r5 += (u32) 1
  50: (55) if r5 != 0x1 goto pc+2
  51: (b4) (u32) r0 = (u32) 1
  52: (95) exit
  53: (b4) (u32) r0 = (u32) 2
  54: (95) exit

8) ping test again:

  # ping -c 1 127.0.0.4 -I 127.0.0.4
    PING 127.0.0.4 (127.0.0.4) from 127.0.0.4 : 56(84) bytes of data.
    64 bytes from 127.0.0.4: icmp_seq=1 ttl=64 time=0.032 ms

    --- 127.0.0.4 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.032/0.032/0.032/0.000 ms

  # ping -c 1 127.0.0.4 -I 127.0.0.3
    PING 127.0.0.4 (127.0.0.4) from 127.0.0.3 : 56(84) bytes of data.

    --- 127.0.0.4 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 0ms

  # ping -c 1 127.0.0.1 -I 127.0.0.2
    PING 127.0.0.1 (127.0.0.1) from 127.0.0.2 : 56(84) bytes of data.

    --- 127.0.0.1 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 0ms

  # ping -c 1 127.0.0.1 -I 127.0.0.5
    PING 127.0.0.1 (127.0.0.1) from 127.0.0.5 : 56(84) bytes of data.

    --- 127.0.0.1 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 0ms

9) Now example test with offload into nfp device:

  # ethtool -i enp2s0
    driver: nfp
    version: 4.15.0+ SMP mod_unload
    firmware-version: 0.0.5.5 0.17 bpf_xxxxxxx ebpf
    expansion-rom-version:
    bus-info: 0000:02:00.0
    supports-statistics: yes
    supports-test: no
    supports-eeprom-access: no
    supports-register-dump: yes
    supports-priv-flags: no

  # iptables -t filter -A INPUT -i enp2s0 -s 192.168.2.2/32 -j DROP

  # bpftool p
  1: xdp  tag 88896d0ae0f463a6 dev enp2s0  ( <-- offloaded into HW )
        loaded_at Feb 15/14:30  uid 0
        xlated 184B  jited 640B  memlock 4096B
  # bpftool p d x i 1
   0: (bf) r9 = r1
   1: (79) r2 = *(u64 *)(r9 +0)
   2: (79) r3 = *(u64 *)(r9 +8)
   3: (bf) r1 = r2
   4: (07) r1 += 14
   5: (bd) if r1 <= r3 goto pc+2
   6: (b4) (u32) r0 = (u32) 2
   7: (95) exit
   8: (bf) r1 = r2
   9: (b4) (u32) r5 = (u32) 0
  10: (69) r4 = *(u16 *)(r1 +12)
  11: (55) if r4 != 0x8 goto pc+6
  12: (07) r1 += 34
  13: (2d) if r1 > r3 goto pc+4
  14: (07) r1 += -20
  15: (61) r4 = *(u32 *)(r1 +12)
  16: (55) if r4 != 0x202a8c0 goto pc+1
  17: (04) (u32) r5 += (u32) 1
  18: (55) if r5 != 0x1 goto pc+2
  19: (b4) (u32) r0 = (u32) 1
  20: (95) exit
  21: (b4) (u32) r0 = (u32) 2
  22: (95) exit

Thanks!

Alexei Starovoitov (2):
  modules: allow insmod load regular elf binaries
  bpf: introduce bpfilter commands

Daniel Borkmann (1):
  bpf: rough bpfilter codegen example hack

David S. Miller (1):
  net: initial bpfilter skeleton

 fs/exec.c                     |  40 ++++-
 include/linux/binfmts.h       |   1 +
 include/linux/bpfilter.h      |  13 ++
 include/linux/umh.h           |   4 +
 include/uapi/linux/bpf.h      |  31 ++++
 include/uapi/linux/bpfilter.h | 200 ++++++++++++++++++++++
 kernel/bpf/syscall.c          |  52 ++++++
 kernel/module.c               |  33 +++-
 kernel/umh.c                  |  24 ++-
 net/Kconfig                   |   2 +
 net/Makefile                  |   1 +
 net/bpfilter/Kconfig          |   7 +
 net/bpfilter/Makefile         |   9 +
 net/bpfilter/bpfilter.c       | 106 ++++++++++++
 net/bpfilter/bpfilter_mod.h   | 373 ++++++++++++++++++++++++++++++++++++++++++
 net/bpfilter/ctor.c           |  91 +++++++++++
 net/bpfilter/gen.c            | 290 ++++++++++++++++++++++++++++++++
 net/bpfilter/init.c           |  36 ++++
 net/bpfilter/sockopt.c        | 236 ++++++++++++++++++++++++++
 net/bpfilter/tables.c         |  73 +++++++++
 net/bpfilter/targets.c        |  51 ++++++
 net/bpfilter/tgts.c           |  26 +++
 net/ipv4/Makefile             |   2 +
 net/ipv4/bpfilter/Makefile    |   2 +
 net/ipv4/bpfilter/sockopt.c   |  64 ++++++++
 net/ipv4/ip_sockglue.c        |  17 ++
 26 files changed, 1767 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/bpfilter.h
 create mode 100644 include/uapi/linux/bpfilter.h
 create mode 100644 net/bpfilter/Kconfig
 create mode 100644 net/bpfilter/Makefile
 create mode 100644 net/bpfilter/bpfilter.c
 create mode 100644 net/bpfilter/bpfilter_mod.h
 create mode 100644 net/bpfilter/ctor.c
 create mode 100644 net/bpfilter/gen.c
 create mode 100644 net/bpfilter/init.c
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/tables.c
 create mode 100644 net/bpfilter/targets.c
 create mode 100644 net/bpfilter/tgts.c
 create mode 100644 net/ipv4/bpfilter/Makefile
 create mode 100644 net/ipv4/bpfilter/sockopt.c

-- 
2.9.5
