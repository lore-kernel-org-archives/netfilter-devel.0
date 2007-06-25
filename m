From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER] early_drop() imrovement (v3)
Date: Mon, 25 Jun 2007 16:36:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706251636010.3137@fbirervta.pbzchgretzou.qr>
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com>
 <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru>
 <461789CF.8000106@cosmosbay.com> <46187770.1070106@sw.ru> <46417137.5080501@sw.ru>
 <467FC8D2.5070102@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1589055184-1182782210=:3137"
Cc: Vasily Averin <vvs@sw.ru>, Eric Dumazet <dada1@cosmosbay.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756332AbXFYOhB@vger.kernel.org>
In-Reply-To: <467FC8D2.5070102@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1589055184-1182782210=:3137
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jun 25 2007 15:53, Patrick McHardy wrote:
>Vasily Averin wrote:
>> +static int early_drop(const struct nf_conntrack_tuple *orig)
>> +{
>> +	unsigned int i, hash, cnt;
>> +	int ret = 0;
>> +
>> +	hash = hash_conntrack(orig);
>> +	cnt = NF_CT_PER_BUCKET;
>> +
>> +	for (i = 0;
>> +		!ret && cnt && i < nf_conntrack_htable_size;
>> +			++i, hash = ++hash % nf_conntrack_htable_size)
>> +		ret = __early_drop(&nf_conntrack_hash[hash], &cnt);
>
>Formatting is a bit ugly, looks much nicer as:
>
>        for (i = 0; i < nf_conntrack_htable_size; i++) {
>
>                ret = __early_drop(&nf_conntrack_hash[hash], &cnt);
>                if (ret || !cnt)
>                        break;
>                hash = ++hash % nf_conntrack_htable_size;
>        }

gcc warning: operation on ‘hash’ may be undefined



	Jan
-- 
---699020219-1589055184-1182782210=:3137--
