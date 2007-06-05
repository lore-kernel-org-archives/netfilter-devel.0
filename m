From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Tue, 05 Jun 2007 13:36:47 +0200
Message-ID: <46654ACF.2040200@trash.net>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
	<4662FBB6.9060000@trash.net>
	<Pine.LNX.4.61.0706051025590.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051025590.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Hi,
> 
> 
> On Jun 3 2007 19:34, Patrick McHardy wrote:
> 
>>Jan Engelhardt wrote:
>>
>>>Adds the connlimit match that has been in POM-NG for a long time.
>>
>>This has about half the points I mentioned last time unfixed,
>>starting with proper use of list.h.
> 
> 
> #include <linux/list.h>
> ...
> struct xt_connlimit_conn {
> 	struct list_head list;
> 	struct nf_conntrack_tuple tuple;
> };
> struct xt_connlimit_data {
> 	struct list_head iphash[256];
> 	spinlock_t lock;
> };
> 
> That looks like lists to me. Please enlighten me where you think
> lists were missing.

+	for (lh = hash->next; lh != hash; lh = lh->next) {

+	for (i = 0; i < 256; ++i) {
+		hash = &info->data->iphash[i];
+		while (hash != hash->next) {
+			conn = list_entry(hash->next,
+			       struct xt_connlimit_conn, list);

> 
> I remember "last time" as
> http://lists.netfilter.org/pipermail/netfilter-devel/2006-December/026341.html
> http://lists.netfilter.org/pipermail/netfilter-devel/2007-January/026577.html
> where you did not thought negatively about connlimit. Please let me know of the
> post you were referring to. Thanks!

This one:

http://lists.netfilter.org/pipermail/netfilter/2007-April/068411.html
