From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: [PATCH] ip_nat_cuseeme NAT helper
Date: Thu, 20 Feb 2003 21:40:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030220214021.A24628@linux.karinthy.hu>
References: <1045530785.1570.12.camel@exile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe \(Cronos\)" <filip.sneppe@cronos.be>
Content-Disposition: inline
In-Reply-To: <1045530785.1570.12.camel@exile>; from filip.sneppe@cronos.be on Tue, Feb 18, 2003 at 02:13:05AM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Feb 18, 2003 at 02:13:05AM +0100, Filip Sneppe (Cronos) wrote:
> Hi Harald & others,
> 
> This implements a NAT helper for the CuSeeMe protocol, both as a
> patch against 2.4.20 and as a patch-o-matic patch.
> 
> Note that it requires Brian J. Murrell's newnat-udp-helper.patch
> that should be in 2.4.21+ kernels (the 2.4.20 patch has Brian's
> patch in it).
> 
> The module should work in DNAT and SNAT scenarios - I posted an
> earlier version a couple of months ago, but that code had one
> bug where one would see his/her own messages, yet others didn't
> see anything. This version works in all my SNAT/DNAT tests...
> 
> Regards,
> Filip

Hi Filip!

I've just looked at the patch you sent, and found this piece of code:

++      char new_port_ip[6];
...
++              *((u_int32_t *)(new_port_ip+2)) = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;

This will make oopses on all platforms with strict alignment restrictions.
Probably most RISC platforms fall into this category, some (like Alpha) have
software trap emulation for such cases causing horrible slowdown (a
single assignment could take a few thousand CPU cycles).

Generally, you should not access a 32-bit dword at a memory location whose
two LSB bits are non-zero.
Please consider reworking your patch to make it portable.

Thanks,
Laszlo
