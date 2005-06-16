From: pud <pud@safetpin.homeunix.org>
Subject: Re: kernel panic with ctnetlink/nfnetlink
Date: Thu, 16 Jun 2005 03:02:25 +0200
Message-ID: <20050616010225.GA18652@safetpin.homeunix.org>
References: <20050615164034.GA15168@safetpin.homeunix.org>
	<42B0BC21.3020004@eurodev.net>
Reply-To: pud@subnet666.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <42B0BC21.3020004@eurodev.net>
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

On Do, 16 Jun 2005, Pablo Neira wrote:

> Please post the whole oops. Are you doing something with the conntrack
> tool? Appreaciate a more detailled description, ruleset, etc...

sorry, i also forgot to mention that
a) i tried recent 2.6-kernels (2.6.11, 2.6.12-rc[56])
b) i wasn't using the conntrack tool, because it was my first try,
    so a cronjob is still parsing /proc/net/ip_conntrack
c) as long as the machine lives, conntrack tool is working,
    and not causing the panic while it runs

i tried some other new modules as well (h323, ipp2p and so on),
but i'm sure it only happens if the kernel is patched with ctnetlink/nfnetlink

the whole ruleset may be too big for a list, but i can send you pm
if you like

here the latest panic:


Unable to handle kernel NULL pointer dereference
 at virtual address 00000084 
 printing eip: 
d0d9f528 
*pgd =    0 
*pmd =    0 
Oops: 0002 [#1] 
Modules linked in:
 twofish serpent blowfish crypto_null af_key ipt_mark ipt_layer7 ipt_MARK cls_fw
 cls_u32 ipt_tos ipt_TOS ipt_length sch_esfq sch_htb ipt_TTL ipt_ECN ipt_account
 ipt_TCPMSS ipt_psd ipt_recent ipt_REJECT ipt_hashlimit ipt_limit ipt_mport
 ipt_mac iptable_mangle ip_nat_amanda ip_conntrack_amanda ip_nat_sip
 ip_conntrack_sip ip_nat_h323 ip_conntrack_h323 ip_nat_irc ip_conntrack_irc
 ipt_connlimit ipt_state ipt_CONNMARK ipt_ipp2p ipt_MASQUERADE ipt_LOG
 ip_nat_ftp ip_conntrack_ftp iptable_nat ip_conntrack iptable_filter
 ip_tables pppoe pppox ppp_generic slhc aes_i586 dm_crypt dm_mod netconsole
 8139too 3c59x mii loop
 
CPU:    0 
EIP:    0060:[<d0d9f528>]    Not tainted VLI 
EFLAGS: 00010246   (2.6.11-brick20)  
eax: 00000000   ebx: c30c4cc8   ecx: c032d618   edx: c30c4cc8 
esi: 000493e0   edi: c30c4cb8   ebp: 00000003   esp: c0321dc4 
ds: 007b   es: 00
7b   ss: 0068 
Process swapper (pid: 0, threadinfo=c0320000 task=c02ccca0)
 
Stack: 
00000000 d0e1a880 c0321e6c c0259f40 00000003 d0e1a045 000493e0 00000001
d0eba040 cf6b0400 c30c4cb8 c0321e6c c30c4d58 d0e1a880 c0321e6c c0259f40
80000000 d0d9c847 c0321e6c c35847a0 d0d9c8ba cf6b0400 c0259f40 d0da3ffc 
 
Call Trace: 
 [<c0259f40>]
 [<d0e1a045>]
 [<c0259f40>]
 [<d0d9c847>]
 [<d0d9c8ba>]
 [<c0259f40>]
 [<c0249fef>]
 [<c0259f40>]
 [<c0259f40>]
 [<c024a30c>]
 [<c0259f40>]
 [<c0258ae0>]
 [<c0259f2d>]
 [<c0259f40>]
 [<c0258af9>]
 [<c024a39f>]
 [<c02589ff>]
 [<c0258ae0>]
 [<c0257af6>]
 [<c02579a0>]
 [<c024a39f>]
 [<c02578f7>]
 [<c02579a0>]
 [<c0240e30>]
 [<c0240f75>]
 [<c024105f>]
 [<c0136803>]
 [<c0136886>]
 [<c0124932>]
 [<c012328a>]
 [<c0120580>]
 [<c01205a3>]
 [<c0120616>]
 [<c010981e>]
 [<c01201b1>]
 
Code: 
da d0 68 00 26 da d0 e8 17 33 39 ef 83 c4 10 e9 
53 ff ff ff a1 60 fa 2c c0 01 f0 89 47 18 89 d8 
8b 53 08 e8 fb a4 39 ef 8b 04 24 88 84 00 00 00
08 e9 58 ff ff ff 68 d0 25 da d0 68 fa 03 00 00
 
panic - not syncing: Fatal exception in interrupt 


=;p)ud

-- 
pgp-key at https://safeTpin.homeunix.org/pud.asc
