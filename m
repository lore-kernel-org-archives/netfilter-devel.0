From: "Paul C. Diem" <PCDiem@FoxValley.net>
Subject: RE: [PATCH] libiptc.c blob parser
Date: Sat, 15 Jul 2006 15:11:45 -0500
Message-ID: <FFEPKIHJDEDDAAFOFDGFCELOCBAA.PCDiem@FoxValley.net>
References: <44ADE145.7020508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
In-Reply-To: <44ADE145.7020508@trash.net>
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

The counters field is used later on when committing. I went back to my
original patch that loads/uses the self-relative offset to the chain entry
into the comefrom. The only problem with that method is that it assumes the
offset from the ipt blob entry to the chain entry is less than 2^31. This
assume is fine on 32-bit architectures but I'm not sure about 64-but
architectures.

Paul C. Diem
PCDiem@FoxValley.net

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org]On Behalf Of Patrick
McHardy
Sent: Thursday, July 06, 2006 11:21 PM
To: Paul C. Diem
Cc: Jesper Dangaard Brouer; netfilter-devel@lists.netfilter.org
Subject: Re: [PATCH] libiptc.c blob parser


Paul C. Diem wrote:
> The patch I posted earlier assumed that the rule's chain was the last one
on
> the chain list and used the 32-bit comefrom field to hold the offset of
the
> chain list entry.
>
> This improved patch uses the chain_iterator_cur handle field to more
> accurately get the chain, uses the counters field cast as a pointer to
hold
> a pointer directly to the chain list entry and only bothers to load the
> pointer for the first rule in each chain (since that's the only one we
need
> it in).

I'm not very familiar with that code, so I wonder how that affects
the counter values if you specifially set them or use iptables-save
--counters.



--
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.394 / Virus Database: 268.9.9/382 - Release Date: 7/4/2006
