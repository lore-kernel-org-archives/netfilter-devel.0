From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Memory allocation inside target handler
Date: Fri, 17 Aug 2007 17:17:00 +0200
Message-ID: <200708171717.01065.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tvbxGDV3TkxhNXn"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--Boundary-00=_tvbxGDV3TkxhNXn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there,

I'm currently debugging a memory allocation issue in ipt_ACCOUNT running on 
2.6.21.7. The module allocates memory using get_zeroed_page(GFP_ATOMIC) 
inside the target handler code (interrupt context).

This worked so far without problems. After upgrading from 2.4.32
to 2.6.21.7, I get a kernel oops after 15 to 30 minutes. Attached you'll
find a picture of the oops (sorry, no serial console available).

You can see the kernel is allocating memory when an interrupt is fired.
It then enters netfilter and ends up in ipt_ACCOUNT
which also tries to allocate memory -> Boom.

My question is now:
- Is it ok to use get_zeroed_page(GFP_ATOMIC) in interrupt context?
- Do I need some special locking before I can allocate memory inside
  the target handler? Is f.e. kmalloc protected by some special locking?

In addition ipt_ACCOUNT allocates some memory during the module init code
with kmalloc(GFP_KERNEL), but I guess this is not an issue here.

Thanks in advance for any help,
Thomas Jarosch

--Boundary-00=_tvbxGDV3TkxhNXn--
