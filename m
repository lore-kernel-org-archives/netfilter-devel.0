From: James Morris <jmorris@intercode.com.au>
Subject: [PATCH] Re: Sleeping function called from illegal context at
 slab.c:1378
Date: Wed, 25 Sep 2002 00:53:58 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0209250053120.1632-200000@blackbird.intercode.com.au>
References: <Mutt.LNX.4.44.0209242331430.1239-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="550177381-1764257169-1032879238=:1632"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <Mutt.LNX.4.44.0209242331430.1239-100000@blackbird.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--550177381-1764257169-1032879238=:1632
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 24 Sep 2002, James Morris wrote:

> On Mon, 23 Sep 2002, Andrew Morton wrote:
> 
> > That's a bug in ip_fw_ctl().  It's calling convert_ipfw()
> > inside FWC_WRITE_LOCK_IRQ(&ip_fw_lock, flags);
> > 
> > But convert_ipfw() does kmalloc(GFP_KERNEL).
> > 
> 
> Below a patch to correct this. The bug is also present in 2.2 and 2.4 

Harald,

Attached is the fix for 2.4.20-pre7.


- James
-- 
James Morris
<jmorris@intercode.com.au>


--550177381-1764257169-1032879238=:1632
Content-Type: TEXT/plain; name="diff-ipchains-kmalloc-2420-pre7-01.txt"
Content-Transfer-Encoding: BASE64
Content-ID: <Mutt.LNX.4.44.0209250053580.1632@blackbird.intercode.com.au>
Content-Description: 
Content-Disposition: attachment; filename="diff-ipchains-kmalloc-2420-pre7-01.txt"

ZGlmZiAtdXJOIC1YIGRvbnRkaWZmIGxpbnV4LTIuNC4yMC1wcmU3Lm9yaWcv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwY2hhaW5zX2NvcmUuYyBsaW51eC0yLjQu
MjAtcHJlNy53MS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBjaGFpbnNfY29yZS5j
DQotLS0gbGludXgtMi40LjIwLXByZTcub3JpZy9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXBjaGFpbnNfY29yZS5jCVdlZCBTZXAgMjUgMDA6MDQ6MDAgMjAwMg0K
KysrIGxpbnV4LTIuNC4yMC1wcmU3LncxL25ldC9pcHY0L25ldGZpbHRlci9p
cGNoYWluc19jb3JlLmMJV2VkIFNlcCAyNSAwMDoxOTowMCAyMDAyDQpAQCAt
MTI1Miw3ICsxMjUyLDcgQEANCiAJCXJldHVybiBOVUxMOw0KIAl9DQogDQot
CWZ3a2VybiA9IGttYWxsb2MoU0laRU9GX1NUUlVDVF9JUF9GV19LRVJORUws
IEdGUF9LRVJORUwpOw0KKwlmd2tlcm4gPSBrbWFsbG9jKFNJWkVPRl9TVFJV
Q1RfSVBfRldfS0VSTkVMLCBHRlBfQVRPTUlDKTsNCiAJaWYgKCFmd2tlcm4p
IHsNCiAJCWR1cHJpbnRmKCJjb252ZXJ0X2lwZnc6IGttYWxsb2MgZmFpbGVk
IVxuIik7DQogCQkqZXJybm8gPSBFTk9NRU07DQo=
--550177381-1764257169-1032879238=:1632--
