From: Michael Schwendt <rh0209ms@arcor.de>
Subject: Re: [PATCH] save inverted MAC match
Date: Thu, 14 Nov 2002 23:43:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021114234340.59dbc60a.rh0209ms@arcor.de>
References: <20021106172119.609b16f8.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Thu__14_Nov_2002_23:43:40_+0100_08421500"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021106172119.609b16f8.rh0209ms@arcor.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Multipart_Thu__14_Nov_2002_23:43:40_+0100_08421500
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wed, 6 Nov 2002 17:21:19 +0100, Michael Schwendt wrote:

> The "mac" userspace extension contains a minor bug for both IPv4 and
> IPv6. Upon printing/saving a rule which matches inverted MAC
> addresses, a space character is missing between the '!' prefix and
> the MAC address. Hence iptables-restore fails to parse the output of
> iptables-save. iptables 1.2.5, 1.2.6a, 1.2.7a and CVS are affected.
> 
> Steps to reproduce:
> 
>   iptables -N test
>   iptables -I test -m mac --mac-source ! 01:02:03:04:05:06
>   iptables-save | iptables-restore
> 
> Further reference:
> 
>   https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=77337

In CVS, only the IPv4 code has been fixed (somehow I've missed v1.8
of libipt_mac.c - don't know why).

The IPv6 code still contains the same bug (in CVS libip6t_mac.c
v1.5). Please don't forget to apply the patch. 

- -- 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE91Ccc0iMVcrivHFQRArM7AJ4x4n0YdhEYD45Bg3FYNKHgfky+9gCghax1
Thx88ZNFK4KpS2kSQXXlCgg=
=l7w/
-----END PGP SIGNATURE-----

--Multipart_Thu__14_Nov_2002_23:43:40_+0100_08421500
Content-Type: application/octet-stream;
 name="iptables-1.2.7a-invertmac.patch"
Content-Disposition: attachment;
 filename="iptables-1.2.7a-invertmac.patch"
Content-Transfer-Encoding: base64

UmVkIEhhdCBMaW51eCBidWcgIzc3MzM3OiBBZGQgbWlzc2luZyBzcGFjZSBiZXR3ZWVuICchJyBh
bmQgTUFDCmFkZHJlc3MgdXBvbiBwcmludGluZy9zYXZpbmcgcnVsZXMuCgpkaWZmIC1OYXVyIGlw
dGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMvbGliaXA2dF9tYWMuYyBpcHRhYmxlcy0xLjIu
N2EvZXh0ZW5zaW9ucy9saWJpcDZ0X21hYy5jCi0tLSBpcHRhYmxlcy0xLjIuN2Etb3JpZy9leHRl
bnNpb25zL2xpYmlwNnRfbWFjLmMJV2VkIE1heSAyOSAxNTowODoxNiAyMDAyCisrKyBpcHRhYmxl
cy0xLjIuN2EvZXh0ZW5zaW9ucy9saWJpcDZ0X21hYy5jCVdlZCBOb3YgIDYgMTY6NTA6MTcgMjAw
MgpAQCAtOTAsNyArOTAsNyBAQAogewogCXVuc2lnbmVkIGludCBpOwogCi0JcHJpbnRmKCIlcyUw
MlgiLCBpbnZlcnQgPyAiISIgOiAiIiwgbWFjYWRkcmVzc1swXSk7CisJcHJpbnRmKCIlcyUwMlgi
LCBpbnZlcnQgPyAiISAiIDogIiIsIG1hY2FkZHJlc3NbMF0pOwogCWZvciAoaSA9IDE7IGkgPCBF
VEhfQUxFTjsgaSsrKQogCQlwcmludGYoIjolMDJYIiwgbWFjYWRkcmVzc1tpXSk7CiAJcHJpbnRm
KCIgIik7Cg==

--Multipart_Thu__14_Nov_2002_23:43:40_+0100_08421500--
