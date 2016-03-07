From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [BUG] kernel crash in br_netfilter
Date: Mon, 7 Mar 2016 18:43:41 +0100
Message-ID: <56DDBDCD.8000004@neratec.com>
References: <56D43A9E.2070504@neratec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Felix Fietkau <nbd@openwrt.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:59480 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbcCGRno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 12:43:44 -0500
In-Reply-To: <56D43A9E.2070504@neratec.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/29/2016 01:33 PM, Zefir Kurtisi wrote:
> I've been fighting a kernel bug that is producing random crashes around network /
> skb_layer for a long time and was able to isolate it (or one of its components) to
> the br_netfilter module.
> 
> I am reproducing the bug with PowerPC (TL-WDR4900v1.3) and MIPS (DB120, ar71xx)
> based systems. Florian Westphal did not see it on kvm/x86, it is unclear whether
> this requires a physical system or is CPU specific. This bug is in the latest
> OpenWRT (tested HEAD is 03b15ae9), as it happens with firmwares built 2+ years
> ago, so it is no current regression but something that was there for a long time.
> 
> 
> Reproducing the crash
> 1. build the firmware for the system to test
>    * use default configuration
>    * ensure to select CONFIG_BRIDGE_NETFILTER in kernel_menuconfig
> 2. boot the device and access it over serial
> 3. ensure br-lan bridge has at least two active ports
>    * tested with ath9k + Ethernet (gianfar and ag71xx)
>    * if not enabled, enable radio0 and ensure wlan0 is in bridge
> 4. run: sysctl -w net.bridge.bridge-nf-call-iptables=1
> 5. from your host, continuously ping the device over Ethernet
> 6. run: ifconfig br-lan down
> 
> The next ingress packet causes a fatal crash.
> 
> Trace logs for MIPS and PPC are attached and hint to __nf_conntrack_confirm
> 
> 
> Let me know if I could provide more information to further isolate the problem.
> 
> 
Got forward with that issue and after wondering why the netfilter folks were
unable to reproduce, it finally turned out the problematic code is OWRT private in
target/linux/generic/patches-X/120-bridge_allow_receiption_on_disabled_port.patch

This is causing reproducible kernel crashes under the conditions given before. In
essence, it leads to a double-free (de-reference of poisoned list) or
use-after-destruction. For more details please check the manually collected
execution trace below. The tldr; version is this: an ingress packet to the
Ethernet port of a disabled bridge
1. gets passed to br_handle_frame()
2. enters the BR_STATE_DISABLED case in the mentioned patch
3. gets passed to the related NF_HOOK
   a) in br_nf_pre_routing() a conntrack context ct is created
   b) that in the same nf_iterate() is destroyed in br_nf_pre_routing_finish()
4. in the br_pass_frame_up() following the NF_HOOK
   a) ipv4_confirm() runs __nf_conntrack_confirm(ct) with invalid ct
   b) which attempts to nf_ct_del_from_dying_or_unconfirmed_list(ct)
   c) and with that de-references and writes to LIST_POISON2 in pprev

This is reproducible with different kernels (tested: 3.18 and 4.4), both with PPC
and MIPS systems (should basically do on any platform).

My hot-fix to prevent the crash is to instead of passing the skb to NF_HOOK
directly pass it to br_handle_local_finish(). But having insufficient insight into
what is going on there, this is fighting the symptoms rather than solving the root
cause. Maybe it is even better to drop patch 120 (not tested yet)?



Cheers,
Zefir

---

br_handle_frame() with p->state = BR_STATE_DISABLED {
  NF_HOOK(br_handle_local_finish) {
    br_nf_pre_routing() {
      NF_HOOK(br_nf_pre_routing_finish) {
        ipv4_conntrack_in() {
          nf_conntrack_in()
            init_conntrack()
              ct = __nf_conntrack_alloc()
        }
        br_nf_pre_routing_finish() [=okfn] {
          NF_HOOK(br_handle_frame_finish) {
            br_handle_frame_finish() { frees skb and returns 0 }
            nf_conntrack_destroy(ct) {
              destroy_conntrack(ct) {
                nf_ct_del_from_dying_or_unconfirmed_list(ct) {
                  ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode.pprev = LIST_POISON2
                }
                nf_conntrack_free(ct)
              }
            }
          }
        }
      }
      return NF_STOLEN
    }
    /* nf_iterate() returns NF_STOLEN, but nf_hook_slow() does not
       handle NF_STOLEN and returns 0 */
  }
  br_pass_frame_up() {
    ipv4_confirm() {
      __nf_conntrack_confirm(ct) {
        /* this one attempts to write to LIST_POISON2 and causes the oops */
        nf_ct_del_from_dying_or_unconfirmed_list(ct)
      }
    }
  }
}



