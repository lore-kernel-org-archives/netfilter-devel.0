From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the netfilter-next tree with the
 netfilter tree
Date: Thu, 7 Dec 2017 12:58:11 +1100
Message-ID: <20171207125811.550421ae@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>,
        Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  net/netfilter/nf_conntrack_h323_asn1.c

between commit:

  bc7d811ace4a ("netfilter: nf_ct_h323: Convert CHECK_BOUND macro to function")

from the netfilter tree and commit:

  e3e52b49c9e7 ("netfilter: nf_conntrack_h323: Remove unwanted comments.")

from the netfilter-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc net/netfilter/nf_conntrack_h323_asn1.c
index dc6347342e34,475fc8a9b477..000000000000
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@@ -164,20 -166,6 +165,19 @@@ static unsigned int get_len(struct bits
  	return v;
  }
  
 +static int nf_h323_error_boundary(struct bitstr *bs, size_t bytes, size_t bits)
 +{
 +	bits += bs->bit;
 +	bytes += bits / BITS_PER_BYTE;
 +	if (bits % BITS_PER_BYTE > 0)
 +		bytes++;
 +
 +	if (*bs->cur + bytes > *bs->end)
 +		return 1;
 +
 +	return 0;
 +}
 +
- /****************************************************************************/
  static unsigned int get_bit(struct bitstr *bs)
  {
  	unsigned int b = (*bs->cur) & (0x80 >> bs->bit);
