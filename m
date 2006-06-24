From: "Paul C. Diem" <PCDiem@FoxValley.net>
Subject: [PATCH] libiptc.c blob parser
Date: Fri, 23 Jun 2006 23:52:29 -0500
Message-ID: <FFEPKIHJDEDDAAFOFDGFCELECBAA.PCDiem@FoxValley.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

We have about 30,000 mangle table rules in about 8,000 chains. iptc_init
takes about 10 seconds just to load and parse the table. The problem is the
second parse phase that iterates through every chain and every rule
searching for the offset of the target for every jump rule.

I've applied the following small patch that loads the offset of the chain
entry into the comefrom field of the first rule ipt entry in each
user-defined chain in the first pass. This comefrom field is then used in
the second pass to easily locate the target chain. This minor change has
reduced the load time of our mangle table to 1 second.

Paul C. Diem
PCDiem@FoxValley.net

309a310,314
> /*+PCD
> * Modification to use the offset to the chain entry in the ipt
> * entry comefrom field as loaded by iptcc_find_chain_by_offset.
> */
> #if 0
319a325,329
> #else
> 	STRUCT_ENTRY * e = ((STRUCT_ENTRY *)((char *)handle->entries->entrytable
+ offset));
> 	return (struct chain_head *)((char *)e + e->comefrom);
> #endif
> /*-PCD*/
496a507,512
> /*+PCD
> * Load the offset to the chain entry relative to the
> * ipt entry into the ipt entry comefrom field.
> */
> 		e->comefrom = (char *)h->chains.prev - (char *)e;
> /*-PCD*/
